# Rails Application Template

This is my template for generating new applications. I try to keep it up to date with the latest things which I often use in an application or which are always useful.

```
rails new awesomeness -m http://rails.adamcooke.io --skip-spring
```

## Features

* Sets up an initial git repository
* Removes some gems which I don't take advantage of from the default Gemfile (including sdoc, turbolinks and jbuilder)
* Adds a number of gems which I always use
* Uses HAML rather than ERB (including replacing the default application layout)
* Uses SCSS rather than CSS
* Uses Coffeescript rather than plain JS
* Disables all generators
* Autoloads from /lib
* Adds environment specific configuration for development to config/environment.yml
