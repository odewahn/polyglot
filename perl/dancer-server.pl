use Dancer;
use Dancer::Plugin::CRUD;
use MongoDB;

my $client = MongoDB->connect();
my $db = $client->get_database('test');
my $quotes = $db->get_collection('quotes');
my $json = JSON->new->allow_nonref;

set content_type => 'application/json';
set port         => 8080;

get '/' => sub{
    return {message => "Hello from Perl and Dancer"};
};

set public => path(dirname(__FILE__), '..', 'static');

get "/demo/?" => sub {
    send_file '/index.html'
};

get '/api/quotes' => sub {
    my $response = $quotes->find()->sort({'index' => -1})->limit(10);
    my @results = ();
    while(my $quote = $response->next) {
                push (@results,
                        {"content" => $quote->{'content'},
                         "index"   => $quote->{'index'},
                         "author"  => $quote->{'author'}
                         }
                );
        } 
        if (! scalar (@results)) {
            status 404;
            return;
        }
        return \@results;
};

post '/api/quotes' => sub {
    my $max_id = $quotes->count() + 1;
    # get the author and content from the parameters
    if (!params->{content}) {
        status 400;
        return {message => "Content is required for new quotes."};
    }

    my %response = (
        'author' => params->{author},
        'content' => params->{content},
        'id' => $max_id
    );

    my $response = $quotes->insert_one(\%response);
    status 201;
    return $max_id;
};


get '/api/quotes/random' => sub {
    my $max_id = $quotes->count();
    my $random = int(rand($max_id));
    my $response = $quotes->find({"index" => $random});
    my $quote = $response->next;
    return {"content" => $quote->{'content'},
            "index"   => $quote->{'index'},
            "author"  => $quote->{'author'}
    };
};


get '/api/quotes/:index' => sub {
    
    my $response = $quotes->find({"index" => int(params->{'index'})}); 
    while(my $quote = $response->next) {
        return {"content" => $quote->{'content'},
            "index"   => $quote->{'index'},
            "author"  => $quote->{'author'}
        };
    };
    status 404;
    return;
};

put '/api/quotes/:index' => sub {
    if (!params->{content} && !params->{author}) {
        status 400;
        return {message => "Content or author is required for updated quotes."};
    }
    my $original = $quotes->find({index => int(params->{'index'})}); 
    my $author = $original->{author};
    my $content = $original->{content};
    if (params->{author}) { $author = params->{author}}
    if (params->{content}) { $content = params->{content}}
    
    my $response = $quotes->update_one({'index' => params->{index}}, 
                        {'$set' => {'author'=>$author, 'content'=>$content}});

    status 202;
    return params->{'index'};
};

del '/api/quotes/:index' => sub {
    my $response = $quotes->delete_one({index => int(params->{'index'})});

    status 204;
    return;
};


dance;

