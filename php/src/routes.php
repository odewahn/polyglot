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
        foreach ($quotes->find([], ['_id' => 0])->sort->(array('id' => -1))->limit(10) as $quote) {
            $results[] = $quote;
        }

        return $response
            ->withHeader('Content-Type', 'application/json')
            ->getBody()->write(json_encode($results, JSON_PRETTY_PRINT));
    });

    $this->post('', function (Response $response, Request $request, array $args) use ($quotes) {
        $quote = json_decode($request->getBody()->getContents(), JSON_OBJECT_AS_ARRAY);

        if (!isset($quote['content'])) {
            return $response->withStatus(400, 'Post syntax incorrect.');
        }

        $quote['id'] = $quotes->count();
        $quote['id']++;

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
            ['id' => $random],
            ['_id' => 0]
        );

        $record = $random->getNext();

        // Json encode the record
        $record = json_encode($record, JSON_PRETTY_PRINT);

        // Log the record
        $this->logger->info("Random record: \n" . $record . "\n");

        // Return the JSON response as application/json
        return $response
            ->withHeader('Content-Type', 'application/json')
            ->getBody()->write($record);
    });


    $this->group('/{id}', function() use ($quotes) {
        $this->get('', function(Request $request, Response $response, array $args) use ($quotes) {
            if ($result = $quotes->find(['id' => (int)   $args['id']], ['_id' => 0])) {
                $record = $result->getNext();

                $record = json_encode($record, JSON_PRETTY_PRINT);
                return $response
                    ->withHeader('Content-Type', 'application/json')
                    ->getBody()->write($record);
            }

            return $response->withStatus(500, 'Internal Server Error');
        });

        $this->put('', function(Response $request, Response $response, array $args) use ($quotes) {
            $quote = json_decode($request->getBody()->getContents(), JSON_OBJECT_AS_ARRAY);

            if (!isset($quote['content']) && !isset($quote['author'])) {
                return $response->withStatus(400, 'Post syntax incorrect');
            }

            try {
                $quotes->update(['id' => $args['id']], $quote);
                return $response
                    ->withStatus(200, 'OK')
                    ->getBody()
                    ->write(
                        json_encode('succesfully saved', JSON_PRETTY_PRINT)
                    );
            } catch (\MongoCursorException $e) {
                return $response
                    ->withStatus(500, 'Internal Server Error')
                    ->getBody()
                    ->write(json_encode(['error' => $e->getMessage()]));
            }

            return $response->withStatus(500, 'Internal Server Error');
        });

        $this->delete('', function(Response $request, Response $response, array $args) use ($quotes) {
            try {
                $quotes->remove(['id' => $args['id']]);
                return $response->withStatus(200, 'OK')->getBody()->write(json_encode(true, JSON_PRETTY_PRINT));
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

$app->get('/', function(Response $response, Request $request, $args) {
    return $response->getBody()->write('Hello World');
});
