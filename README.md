[![Build Status](https://travis-ci.org/catkins/punchline.svg)](https://travis-ci.org/catkins/punchline) [![Dependency Status](https://gemnasium.com/catkins/punchline.svg)](https://gemnasium.com/catkins/punchline) [![Coverage Status](https://img.shields.io/coveralls/catkins/punchline.svg)](https://coveralls.io/r/catkins/punchline) [![Code Climate](https://codeclimate.com/github/catkins/punchline/badges/gpa.svg)](https://codeclimate.com/github/catkins/punchline) [![Gem Version](https://badge.fury.io/rb/punchline.svg)](http://badge.fury.io/rb/punchline)

# Punchline

Punchline is a Redis backed Minimum Priority Queue with enforced uniqueness and atomicity fuelled by lua scripts.

## Motivation

At Doceo, we needed a way to atomically keep track of dirty records that needed reprocessing, whilst also avoiding doing extra work if records are marked as dirty and haven't been processed yet.

## Prerequisites

- Redis 2.6+

Currently tested against Ruby 2.0.0, 2.1.0 and JRuby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'punchline', '~> 0.1.0'
```

And then execute:

```bash
$ bundle install
```

## Usage

```ruby
require 'punchline'

# optionally override Punchline with your own Redis client, eg. Redis::Namespace
redis_url = ENV["REDIS_URL"] || "redis://localhost:6379"
client = Redis.new url: redis_url
namespaced_client = Redis::Namespace.new Rails.env, client

Punchline.configure do |config|
  config.redis = namespaced_client
end

# create a queue
queue = Punchline::MinQueue.new :awesome_key
queue.length # => 0

# add a key
queue.enqueue 'hello!' # => true

queue.length # => 1

# shortly after... higher priority score is rejected
queue.enqueue 'hello!' # => false

queue.length # => 1

# original key is retrieved
queue.dequeue # => { :priority => 1411405014, :value => "hello!" }

# queue is now empty
queue.length # => 0

# optionally set your own priority value
queue.enqueue 'hello!', priority: 155 # => true

# fetch all without dequeuing
queue.enqueue 'hello!'
queue.enqueue 'adding values!'
queue.all # [{:value=>"hello", :priority=>1411445996}, {:value=>"adding values!", :priority=>1411446073}]

# clear out queue
queue.clear!
queue.all # => []
queue.length # => 0

```

## Contributing

1. Fork it ( http://github.com/catkins/punchline/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
