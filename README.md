# prototype_webauthn_demo
This supplies the necessary files for a Web authentication demo app using Rails 6 and webauthn_prototype gem.

# Setup

First create a new empty rails application
```
$ rails new demo_app
```
Download the files and copy them into your created demo_app folder overwriting files.\
Download webauthn_prototype_ruby gem and install according to instructions.\
In your Gemfile.rb change:
```ruby
gem "prototype_webauthn", path: "~/change/this"
```
to
```ruby
gem "prototype_webauthn", path: "path/to/webauthn_prototype"
```
Install the webpacker erb extension.
```
$ rails webpacker:install:erb
```

update your installed gems using bundler.
```
$ bundle
```
Since Web Authentication needs a secure channel you need to enable SSL in your local environment to test the app.
```

```


