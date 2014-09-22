[![Build Status](https://travis-ci.org/catkins/mindy.svg)](https://travis-ci.org/catkins/mindy) [![Dependency Status](https://gemnasium.com/catkins/mindy.svg)](https://gemnasium.com/catkins/mindy) [![Coverage Status](https://img.shields.io/coveralls/catkins/mindy.svg)](https://coveralls.io/r/catkins/mindy)

# Mindy

Mindy is a Redis backed Minimum Priority Queue with enforced uniqueness and atomicity fuelled by lua scripts.

## Motivation

At Doceo, we needed a way to atomically keep track of dirty records that needed reprocessing, whilst also avoiding doing extra work if records are marked as dirty and haven't been processed yet.

## Prerequisites

- Redis 2.6+

Currently against Ruby 2.0.0, 2.1.0 and JRuby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mindy', github: 'catkins/mindy'
```

And then execute:

```bash
$ bundle
```

## Usage

```ruby
require 'mindy'

# optionally override Mindy a Redis client, otherwise defaults to Redis.new
Mindy.config.redis = Redis.new host: "10.0.1.1", port: 6830

# create a queue
queue = Mindy::MinQueue.new
queue.length # => 0

# add a key
queue.enqueue priority: Time.now.to_i, value: 'hello!' # => true
queue.length # => 1

# shortly after... higher priority score is rejected
queue.enqueue priority: Time.now.to_i, value: 'hello!' # => false
queue.length # => 1

# original key is retrieved
queue.dequeue # => { :priority => 1411405014, :value => "hello!" }

# queue is now epty
queue.length # => 0

```

## TODO

- Add support for Redis::Namespace
- Come up with a gem name that isn't taken...
- Push to rubygems

## Contributing

1. Fork it ( http://github.com/catkins/mindy/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
