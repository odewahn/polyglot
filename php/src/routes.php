<?php
use \Slim\Http\Request;
use \Slim\Http\Response;

// Routes
$app->group('/api/quotes', function () {
    // Setup DB connection
    $mongo = new MongoClient('mongodb://localhost:27017');
    $mongo->connect();
    $db = $mongo->test;
    $quotes = $db->selectCollection('quotes');

    $this->get('', function (Request $request, Response $response, array $args) use ($quotes) {
        $this->logger->info("Fetching 10 records…\n");
        
        $results = [];
        foreach ($quotes->find([], ['_id' => 0])->sort(['index' => -1])->limit(10) as $quote) {
            $results[] = $quote;
        }
        $response
            ->getBody()->write(json_encode($results, JSON_PRETTY_PRINT));
        $newResponse = $response->withHeader(
            'Content-type',
            'application/json; charset=utf-8'
        );
        return $newResponse;
    });

    $this->post('', function (Request $request, Response $response, array $args) use ($quotes) {
        $quote = json_decode($request->getBody()->getContents(), JSON_OBJECT_AS_ARRAY);

        if (!isset($quote['content'])) {
            return $response->withStatus(400, 'Post syntax incorrect.');
        }

        $quote['index'] = $quotes->count();
        $quote['index']++;

        try {
            $quotes->insert($quote);
            return $response
                ->withStatus(201, "Created")
                ->getBody()
                ->write(
                    json_encode($quotes->count(), JSON_PRETTY_PRINT)
                );
        } catch (\MongoCursorException $e) {
            return $response
                ->withStatus(500, 'Internal Server Error')
                ->getBody()
                ->write(['error' => $e->getMessage()]);
        }

        return $response->withStatus(500, 'Internal Server Error');
    });

    $this->get('/random', function(Request $request, Response $response, array $args) use ($quotes) {
        // Find a random quote
        $random = floor((mt_rand(0, 100) / 100) * $quotes->count());
        $random = $quotes->find(
            ['index' => $random],
            ['_id' => 0]
        );

        $record = $random->getNext();

        // Json encode the record
        $record = json_encode($record, JSON_PRETTY_PRINT);

        // Log the record
        $this->logger->info("Random record: \n" . $record . "\n");

        // Return the JSON response as application/json
        $response
            ->getBody()->write($record);
        $newResponse = $response->withHeader(
                        'Content-type',
                        'application/json; charset=utf-8'
                       );
        return $newResponse;
    });


    $this->group('/{index}', function() use ($quotes) {
        $this->get('', function(Request $request, Response $response, array $args) use ($quotes) {
            if ($result = $quotes->find(['index' => (int)   $args['index']], ['_id' => 0])) {
                $record = $result->getNext();

                $record = json_encode($record, JSON_PRETTY_PRINT);

        	$response->getBody()->write($record);
	        $newResponse = $response->withHeader(
                        'Content-type',
                        'application/json; charset=utf-8'
                       );
		return $newResponse;
	    };
            return $response->withStatus(500, 'Internal Server Error');
        });

        $this->put('', function(Request $request, Response $response, array $args) use ($quotes) {
            $quote = json_decode($request->getBody()->getContents(), JSON_OBJECT_AS_ARRAY);

            if (!isset($quote['content']) && !isset($quote['author'])) {
                return $response->withStatus(400, 'Post syntax incorrect');
            }

            try {
                $quotes->update(['index' => (int) $args['index']], $quote);
                return $response
                    ->withStatus(200, 'OK')
                    ->getBody()
                    ->write(
                        json_encode((int) $args['index'], JSON_PRETTY_PRINT)
                    );
            } catch (\MongoCursorException $e) {
                return $response
                    ->withStatus(500, 'Internal Server Error')
                    ->getBody()
                    ->write(json_encode(['error' => $e->getMessage()]));
            }

            return $response->withStatus(500, 'Internal Server Error');
        });

        $this->delete('', function(Request $request, Response $response, array $args) use ($quotes) {
            try {
                $data = $quotes->remove(['index' => (int) $args['index']], ['j' => false]);
		$row = $quotes->find(['index' => (int) $args['index']]);
                return $response->withStatus(200, 'OK')->getBody()->write(json_encode(['row' => $row, 'quotes' => $quotes, 'data' => $data, 'args' => $args], JSON_PRETTY_PRINT));
            } catch (\MongoCursorException $e) {
                return $response
                    ->withStatus(500, 'Internal Server Error')
                    ->getBody()
                    ->write(json_encode(['error' => $e->getMessage()]));
            }

            return $response->withStatus(500, 'Internal Server Error');
        });
    });
});

$app->get('/', function(Request $request, Response $response, $args) {
    return $response->getBody()->write('Hello World from PHP Slim');
});

$app->get('/demo', function(Request $request, Response $response, $args) {
    $content = file_get_contents('../static/index.html');
    return $response->getBody()->write($content);
});

