# Load

Trying to reproduce:
```
F, [2017-12-20T18:59:11.748783 #25193] FATAL -- : [5a1b7d98-b7ed-4268-b577-0531e2ccb360] NameError (uninitialized constant #<Class:0x0055a1368249c0>::Chimp):
F, [2017-12-20T18:59:11.748851 #25193] FATAL -- : [5a1b7d98-b7ed-4268-b577-0531e2ccb360] app/models/advocate/self_code.rb:7:in `add_to_mailchimp'

  6   def add_to_mailchimp
  7     list = Chimp::List.new(Chimp::Settings.list_id('amigos'))
  8     begin
```
which only happens in production and nothing I'm trying has fixed it.

This repository was created with:
```
rails new load -M -C --skip-spring --skip-listen --skip-turbolinks
```

