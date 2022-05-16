# **Spree Everypay**

## **About**
A Spree extension that provides support for [Everypay](https://www.everypay.gr/) payment using [Direct API](https://docs.everypay.gr/accept-payments/direct-api/) integration method.

EveryPay REST API reference is [here](https://docs.everypay.gr/api-reference).

## **Key Features**
 * Everypay Direct API integration with Spree.
 * Register everypay as new payment gateway.
 * Payment and Refund API support for checkout, refund and order cancelation.

## **Demo**

## **Installation**

1. Add this extension to your Gemfile with this line:

    ```ruby
    gem 'spree_everypay'
    ```

2. Install the gem using Bundler

    ```ruby
    bundle install
    ```

3. Copy & run migrations

    ```ruby
    bundle exec rails g spree_everypay:install
    ```

4. Restart your server

  If your server was running, restart it so that it can find the assets properly.


## Contributing

If you'd like to contribute, please take a look at the
[instructions](CONTRIBUTING.md) for installing dependencies and crafting a good
pull request.

Copyright (c) 2022 Spree Edge, released under the [New BSD License](https://github.com/spree-edge/spree_everypay/blob/master/LICENSE))
