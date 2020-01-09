# prototype_webauthn_demo
This supplies the necessary files for a Web authentication demo app using Rails 6 and webauthn_prototype gem.

# Setup

First create a new empty rails application
```
$ rails new demo_app
```
Download the files and copy them into your created demo_app folder overwriting files.

Install the webpacker erb extension.
```
$ rails webpacker:install:erb
```
Install Bootstrap and dependencies
```
$ yarn add bootstrap jquery popper.js
```
update your installed gems using bundler.
```
$ bundle update
```
