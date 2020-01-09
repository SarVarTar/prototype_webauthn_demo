# prototype_webauthn_demo
This supplies the necessary files for a Web authentication demo app using Rails 6 and webauthn_prototype gem.

# Setup
Download the files and copy them into your created demo_app folder overwriting files.
First create a new empty rails application
```
$ rails new demo_app
```
Install the webpacker erb extension.
```
$ rails webpacker:install:erb
```
Install Bootstrap and dependencies
```
$ yarn add bootstrap jquery popper.js
```
Download the files and copy them into your created demo_app folder overwriting files.\
update your installed gems using bundler.
```
$ bundle update
```
Run Database migrations
```
$ rails db:migrate
```
Now you can test the demo on localhost:3000

# Making the Demo available on Network

To play around in a local network (to test it on mobile devices for example) extra steps are needed. The following describes the process for a Ubuntu 18.04 System. Other OS may need different configurations.\
Open ```/etc/hostname``` in the editor of your choice and enter any name you'd like to use. Our example uses 'bunny' as it's name.\
Add the following line to your ```development.rb``` inside ```config/environments``` of your projects folder.
```
config.hosts << 'bunny'
```
Start the rails server with bound IP
```
 $ rails s -b 0.0.0.0
```
navigate to bunny:3000 and you should see your project.

to actually see your project on another device you will need additional Network information. In most cases /etc/resolv.conf should hold information about network suffixes to use.\
Could look like this
```
...
nameserver 127.0.0.42
search hopp
...
```
This tells us that the nameserver uses hopp to resolve hostnames. So adding 
```
config.hosts << 'bunny.hopp'
```
to your development.rb should make bunny.hopp:3000 available for all devices on the network.
