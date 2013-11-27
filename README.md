# Generic Forums
TODO: Write a description

## Installation

To install generic forums, you'll need `git`, `ruby 2.0` (or a platform
compatible with `ruby 2.0`), and programming knowledge.  Clone the
repository with:

    $ git clone -b release https://github.com/redjazz96/generic-forums.git

Head into the directory, and then execute:

    $ RAILS_ENV=production bundle install

Seeding the server is next, with:

    $ RAILS_ENV=production rake db:schema:load db:seed

And to start the thin server, run:

    $ RAILS_ENV=production rails s --port 80

## Usage

Generic forums is a very flexible rails application.  To configure
some baseline settings, `config/settings.yml` is a good place to
start.  The file is very well documented.

The default account that comes with generic forums is the admin
account, with the credentials:

    username: admin
    password: admin

Very creative, if I do say so myself.

All of the views in `app/views` are modifiable, however themes that
change the views may not yet be supported.  Styles that change the
stylesheets, however, are - but they must be in a seperate folder
under `app/assets/stylesheets`, contain a `<style name>.css` file,
which then includes the rest of the style (which should be under
`app/assets/stylesheets/<style name>`).  Then, the `forum.style` key
in `config/settings.yml` should be changed to match `<style name>`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
