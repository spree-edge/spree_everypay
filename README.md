# **Spree Everypay**

## **About**
A Spree extension that provides support for [Everypay](https://www.everypay.gr/) payment using [Direct API](https://docs.everypay.gr/accept-payments/direct-api/) integration method.

EveryPay REST API reference is [here](https://docs.everypay.gr/api-reference).

## **Key Features**
 * Everypay Direct API integration with Spree.
 * Register everypay as new payment gateway.
 * Payment and Refund API support for checkout, refund and order cancelation.

## **Demo**

https://user-images.githubusercontent.com/103247578/169060345-12e33381-d696-456b-935b-7326de2bc2ab.mp4


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

## Testing

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs. The dummy app can be regenerated by using `rake test_app`.

```shell
bundle update
bundle exec rake
```


When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_everypay/factories'
```

**Sandbox account** can be register from [here](https://sandbox-dashboard.everypay.gr/register) and get the secret key that is needed to configure the payment method.

---

## Contributing

[See corresponding guidelines](https://github.com/bluebash-spree-contrib/spree_notes/blob/master/CONTRIBUTING.md)

---

Copyright (c) 2022 Spree Edge, released under the [New BSD License](https://github.com/spree-edge/spree_everypay/blob/master/LICENSE)
