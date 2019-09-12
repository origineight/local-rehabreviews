Elasticsearch::Model.client = Elasticsearch::Client.new(host: ENV['ELASTICSEARCH_HOST'], transport_options: {headers: { content_type: 'application/json' }})
