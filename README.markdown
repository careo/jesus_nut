# The Jesus Nut
    (c) 2009 Dane Jensen (careo), mostly.
    some bits shamelessly borrowed from ezmobius and somic

A 'jesus nut' is another name for the 'main rotor retaining nut'. In this case, the name comes from the fact that these experiments were partially used to test out a possible architecture in which it might be a rather large single point of failure.

Now, it's more of a test bed for various bits of http/amqp glue.

See http://en.wikipedia.org/wiki/Jesus_nut for more about the origins of name.

## Setup

The Thin examples require raggi's async thin:
    http://github.com/raggi/thin/tree/async_for_rack

## Running

Run thin:

    $ thin -R thin/jesus_nut.ru -p 4000 start
    
Run the sinatra app:

    $ ruby rabbit_rackup.rb
    
... and more 

## Todos

 * Check on Ruby 1.9
 * Automate launching of the numerous processes, and running of ab against it all
 * Make the backend useable both over http and amqp
 * Add proper timeout handling
 * Try out something in neverblock
 * Throw in some fibers somewhere, just because they're neat
 * Include some ab results comparing all the options
 * ... and more!

## License

Same as Ruby's, except for bits close enough to ezmobius and somic's code that it should really be Apache License, Version 2.0.