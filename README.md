# Load

Trying to reproduce:
```
F, [2017-12-20T18:59:11.748783 #25193] FATAL -- : [5a1b7d98-b7ed-4268-b577-0531e2ccb360] NameError (uninitialized constant #<Class:0x0055a1368249c0>::Chimp):
F, [2017-12-20T18:59:11.748851 #25193] FATAL -- : [5a1b7d98-b7ed-4268-b577-0531e2ccb360] app/models/advocate/self_code.rb:7:in `add_to_mailchimp'

  6   def add_to_mailchimp
  7     list = Chimp::List.new(Chimp::Settings.list_id('amigos'))
  8     begin
```
which only happens in production.

## td/dl
With Rails 5.0, it no longer makes sense to place any application code in the `lib` directory. Make a home for it in the app directory. In particular, note [this last commit](https://github.com/wbreeze/load/commit/2e81d622ce206f705ccad3d0840a07ca999dc773).

## how
This repository reproduces the problem in a rails app generated from scratch, as simply as possible.
During this excercise, I went scratching around in the Rails release notes for things to do with loading and autoloading and load paths. I found this:
```
"Disabled autoloading of classes in production environment."
```
in the [Rails 5.0 release notes](http://guides.rubyonrails.org/5_0_release_notes.html). It [references a commit](https://github.com/rails/rails/commit/a71350cae0082193ad8c66d65ab62e8bb0b7853b). That commit gave me a clue.

First, I was able to reproduce the problem in test by editing "`config/environments/test.rb`" as follows:
```
# config.eager_load = false
# DOUG, DON'T COMMIT THIS CHANGE
config.eager_load = true
```
That is simply to (temporarily) enable eager loading when running tests. Aha! The error manifests itself differently– rspec throws a stack trace and will not execute –however the fault is the same. The stack trace from rspec shows that it isn't able to load the classes from `lib`.

Now in order to get the code in `lib` working to begin with, I had added the `lib` directory to the autoloaded paths. I did this by updating `config/application.rb` with the line, `config.autoload_paths += Dir["#{config.root}/lib/"]`.  The Rails configuration guide suggests this, sort of. Or I'm not sure where I picked that up. It's an old thing.

With Rails 5.0 and eager loading, it is necessary also to add the same paths to a second configuration, "`config.eager_load_paths`". Eager loading is the default for the production environment (see `config/environments/production.rb`).

Adding the line, `config.eager_load_paths += Dir["#{config.root}/lib/"]` in `config/application.rb` solved the problem.

## but
In the Rails 5.0 generated application you'll find directories, `assets` and `tasks` within the `lib` directory. Does it make sense to eager-load those? Probably not.

Here's a second fix that made everything simple.

Instead of putting my "`chimp`" directory in "`lib`", I made a directory in `app` called "`services`" (`app/services`). Then I moved the `chimp` directory from `lib` to `app/services` (`app/services/chimp`) and deleted the two configuration lines from `config/application.rb`.

Running the tests still worked, and then I reverted the `config.eager_load` change I had made in `config/environments/test.rb`.

## in sum
The moral of the story, for me, is that, with Rails 5.0, it no longer makes sense to place any application code in the `lib` directory. Instead, make a home for it in the `app` directory.

## Some details

The content of this repository was created with:
```
rails new load -M -C --skip-spring --skip-listen --skip-turbolinks
```

The prisoner resource was generated with:
```
rails g resource prisoner name:string rank:string serial_number:string --no-helper --no-javascripts --no-stylesheets
```
