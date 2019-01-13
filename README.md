# Postman

[![Build Status](https://travis-ci.org/iamd3vil/postman.svg?branch=master)](https://travis-ci.org/iamd3vil/postman)

This is a service which sends Emails using multiple Email providers. This is supposed to be used as a standalone service which you can deploy independently and will take care of all the emails you have to send to your users. Postman has different ways of interaction.

It exposes a simple API for all your emails Just send a request through the HTTP API or through Rabbitmq, Postman takes care of sending them.

Postman has a lot of configuration options you can use to configure it according to your needs. Please see the docs for everything you can do with Postman.

### Supported ways of interaction

- REST API
- RabbitMQ

### TODO

- [x] Support different email providers
- [x] Streamline HTTP API
- [ ] Documentation
