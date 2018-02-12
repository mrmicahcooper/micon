# Micon
A buildpack that eaily lets you create your own self documented icon SVG server

Here's how it works:

All you need is a directory of svgs that might look something like:

```
project
└───marketing
│   │   file01.svg
│   │   file02.svg
│   │   ...
└───product
│   │   file03.svg
│   │   file04.svg
│   │   ...
└───admin
│   │   file05.svg
│   │   file06.svg
│   │   ...

```

Just make sure all your svgs are within a folder. Then you just:

+ `heroku create myapp --buildpack https://github.com/mrmicahcooper/micon.git`
+ Set a `SECRET_KEY_BASE` config var
  - `heroku config:add SECRET_KEY_BASE=$(openssl rand -base64 32)`
+ Set the `HOST` to your app's domain
  - `heroku config:add HOST=https://my-icon-test.herokuapp.com`
+ `git push heroku master`


Done! Enjoy your svgs!
