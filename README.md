# Generic Forums #

The coolest forums you'll ever find.

## Operation ##
In generic forums, there are quite a few things that keep it running.

### Ghosting ###
In generic forums, there are what as known as 'ghost threads' or 'ghost boards' (if applicable).

The point of these is so that all of the default permissions are defined on these 'ghost' items, so that the permissions are not copied for each and every item.  This does a few things:

1. Reduces the load on the database server.  Because the ghost thread is the same thread for all threads in the same board, displaying the index of a board is as easy as asking for only one thread's permissions.
2. Makes it easier to handle.  Instead of having to go in and remove permissions on every thread when you need to, you can just remove the permission on the ghost thread.

Ghost threads can be defined by parameters on the thread; this is known as 'ghost data'.  This allows for you to create more than one ghost thread for each board, each with a differing set of permissions.  **Ghost threads cannot be ghosted**.  Since they contain the list of all permissions for a set of items, they cannot be ghosted by a ghost thread.

Ghost threads got their name from the fact that the threads do exist in the database, but are not used threads; as in, they don't appear on the thread index nor are accessible from the url.

### Groups ###
In generic forums, there are groups; groups can have users.  The user's last group is the one that determines the user's title (TODO: add `primary_group` and `title` to user).  All permissions are defined on groups only; users cannot have permissions that are only defined to them, unless you put the user in a group and define the permission on that group.  Users get all permissions from all groups, basically OR'd together; negated permissions take precidence over any and all permissions, though.

    /********************\             /********************\             /********************\
    |                    |  has many   |                    |  has many   |                    |
    |       users        | ----------> |       groups       | ----------> |    permissions     |
    |                    |             |                    |             |                    |
    \********************/             \********************/             \********************/

### Guest ###
In order to make it easier to define permissions, there is a user with the `id = 0` named `guest`.  It exists so that permissions defined on guest are the permissions that default whenever a user that is not logged in browses the forum.  Please **do not** define negated permissions on `guest`, because by default every user is a part of the guest group.

### Formats ###
Generic forums allows posts to be in multiple formats.  Generic forums comes with 3 default formats: [`markdown`][markdown], [`bbcode`][bbcode], and `plain`.  To add another format, add the format's gem to the gemfile, and modify `config/initializers/post.rb` to use the format (examples are somewhat given in the file).

## Configuration ##
Configuration options for the forum itself are located in `config/app_config.yml`.  The file is very well documented, so please check out the file.

## Public API ##
Generic forums comes with a public API.  Since Generic Forums uses [`rabl`][rabl], formats of the public API requests are by default available in json and xml.  Generic forums can support output formats that rabl can support, but with a few modifications (check out [here](https://github.com/nesquena/rabl/wiki/Configuring-Formats)).  Check the wiki for more information on the public API.

  [markdown]: https://https://github.com/rtomayko/rdiscount
  [bbcode]: https://github.com/jarrett/rbbcode
  [rabl]: https://github.com/nesquena/rabl
