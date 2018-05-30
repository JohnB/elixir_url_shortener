# ElixirUrlShortener

# url_shortener

## Requirements

Write a URL shortening service. It should meet the following requirements:

* For a given URL, when entered in the browser input, it should return a shortened version that points to a local service.
* The local service should be able to proxy the shortened URL to the real destination.
* The shortened URL should be less than 8 characters long.

Additional points:
* How would you scale this service to millions of users? _JohnB: See item 4 in the [roadmap](https://github.com/JohnB/url_shortener#roadmap-poc---mvp---pain---scalable) below._
* How would provide analytics or usage metrics on this service? _JohnB: when a short URL is created, used, or not found, initiate some background task to update the appropriate metrics (it should not block or slow down the URL-shortening process)._
* What useful additional feature would you add to this service? _JohnB: See [Known Issues](https://github.com/JohnB/url_shortener#known-issues) section, below._

## Assumptions (to be clarified with imaginary PM)

* When you say “proxy”, I assume you mean a 301-redirect response - which is what the https://goo.gl/ shortener does.
* “URL less than 8 characters” I assume means the “path” portion of the URL - I can't afford a really short domain name (and even `bit.ly/` takes up 7 characters so a _true_ 8-character shortener would only handle a pointlessly small set of URLs).
* I’ll make it case insensitive and disallow similar characters, so people can more easily type it when they’re using a mobile browser. The downside of this is that eight characters can only support _142 giga-URLs_ (152587890625) - but it may take a long while to exhaust the address space.

## Roadmap (POC -> MVP -> Pain -> Scalable)

* [x] Proof of Concept: Rails app that responds to http://localhost:3000/shortURL with a 301
to the real destination.
* [ ] Minimal Viable Product: Elixir/phoenix app directly maps URLs to DB rows (just like the Rails POC)
* [ ] Hockey Stick: pay for larger DB and more and more and more app servers.
* [ ] Scalable: elixir process holds an LRU cache (since this is mostly read-only data) which falls back to a DB lookup if not found in the cache. This can be deployed to multiple servers, with no need to synch their LRU caches (due to the DB fallback).


## Installation

```
git clone git@github.com:JohnB/elixir_url_shortener.git
cd elixir_url_shortener
mix deps.get
mix ecto.create && mix ecto.migrate
cd assets && npm install && cd ..
mix phx.server
open http://localhost:4000/
```

## Known Issues

1. Has no concept of users, authentication, or security - anyone can create (or update!) short URLs.
1. Sub-minimal tests.
1. No retries for random (less than 1 in 100 billion) collisions when creating a short URL - the user will get a uniqueness-constraint error (but it will probably work fine if they just retry).
1. Does not yet RickRoll random users.
