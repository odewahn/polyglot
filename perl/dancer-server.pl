use Dancer;
use Dancer::Plugin::CRUD;
use JSON;
use MongoDB;

my $client = MongoDB->connect();
my $db = $client->get_database('test');
my $quotes = $db->get_collection('quotes');
my $json = JSON->new->allow_nonref;

set content_type => 'application/json';

get '/' => sub{
    return {message => "Hello from Perl and Dancer"};
};

get '/api/quotes' => sub {
    my $response = $quotes->find()->sort({'index' => -1})->limit(10);
    my @results ;
    while(my $quote = $response->next) {
                push (@results,
                        {"content" => $quote->{'content'},
                         "index"   => $quote->{'index'},
                         "author"  => $quote->{'author'}
                         }
                );
        } 
        return \@results;
};

post '/api/quotes' => sub {
    my $response = $quotes->find()->sort({'index' => -1})->limit(10);
        my @results ;
        while(my $quote = $response->next) {
                push (@results,
                        {"content" => $quote->{'content'},
                         "index"   => $quote->{'index'},
                         "author"  => $quote->{'author'}
                         }
                );
        } 
        return \@results;
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
};


dance;

