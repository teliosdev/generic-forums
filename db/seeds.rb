# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

Group.create! [
  {:name => "guest", :avatar_size => "0"        },
  {:name => "user" , :avatar_size => "80x80>"   },
  {:name => "admin", :avatar_size => "100x100>" },
  {:name => "system",:avatar_size => "100%"     }
]

def group(name)
  Group.find_by_id(name) || Group.find_by_name(name)
end

guest_pass = SecureRandom.hex(5)
User.create!(:username => "guest",
             :password => guest_pass,
             :password_confirmation => guest_pass,
             :email => "guest@localhost.com") do |u|
  u.id = 0
  u.group_ids = [1]
  u.primary_group = group(1)
  u.options = AppConfig.user_settings
end
User.create!(:username => "admin",
             :password => "password",
             :password_confirmation => "password",
             :email => "admin@localhost.com") do |u|
  u.group_ids = [1,2,3]
  u.primary_group = group(3)
end
system_pass = SecureRandom.hex(5)
User.create!(:username => "system",
             :password => system_pass,
             :password_confirmation => system_pass,
             :email => "system@localhost.com") do |u|
  u.group_ids = [1,2,3,4]
  u.primary_group = group(4)
end

Board.create! [
  {
    :name => "primary",
    :sub  => "first"
  },
  {
    :name => "secondary",
    :sub  => "second",
    :parent_id => 1
  }
]

b = Board.find(1)
ghost1 = b.ropes.create! :title => "ghost" do |r|
  r.is_ghost   = true
  r.ghost_data = {  }
  r.user_id    = 2
end
ghost2 = b.ropes.create! :title => "ghost-deleted" do |r|
  r.is_ghost   = true
  r.ghost_data = { :deleted => true }
  r.user_id    = 2
end
ghost1.do_ghost!
ghost2.do_ghost!

PaperTrail.whodunnit = 1


welcome_rope = b.ropes.create! :title => "Welcome" do |r|
  r.user_id = 1
end

if Rails.env.development?
  ro = b.ropes.create! :title => "Hello World", :main_post_attributes => {
    :body => "hello world", :format => "plain"
    } do |r|
    r.main_post.user_id = r.user_id = 1
  end
  # versioning example
  po = ro.posts.create! :body => <<-DOC, :format => "markdown" do |r|
Hello

```C
#include <stdio.h>

/* this is a comment */
// this is also a comment

int test(args* hello);
int main() {
    printf("try this");
}

```
  DOC
    r.user_id = 1
  end

  edits = []

  edits << <<-DOC
Hello

```C
#include <stdio.h>
#include <string.h>
/* this is a comment */
// this is also a comment
int test(args* hello);
int main() {
    printf("try this");
}
```
  DOC

  edits << <<-DOC
Hello

```C
#include <stdio.h>
#include <string.h>
int test(args* hello);
int main() {
    printf("try this");
}
```
  DOC

  edits << <<-DOC
Hello

```C
#include <stdio.h>
#include <string.h>
int test(args* hello);
int main(int argc, char* argv[]) {
    printf("try this");
}
```
  DOC

  edits << <<-DOC
Hello

```C
#include <stdio.h>
#include <string.h>
int test(char*);
int main(int argc, char* argv[]) {
    printf("try this");
}
int test(char* arg) {
}
```
  DOC

  edits << <<-DOC
Hello

```C
#include <stdio.h>
#include <string.h>
int test(char*);
int main(int argc, char* argv[]) {
    printf("try this: %s", argv[1]);
    return test(argv[2]);
}
int test(char* arg) {
    if (strncmp("zero", arg)) {
        return 0;
    } else if (strncmp("one", arg)) {
        return 1;
    } else if (strncmp("two", arg)) {
        return 2;
    } else {
        return 3;
    }
}
```
  DOC

  edits << <<-DOC
Hello

```C
#include <stdio.h>
#include <string.h>
int test(char*);
int main(int argc, char* argv[]) {
    printf("hello %s", argv[1]);
    return test(argv[2]);
}
int test(char* arg) {
    if (strncmp("zero", arg)) {
        return 0;
    } else if (strncmp("one", arg)) {
        return 1;
    } else if (strncmp("two", arg)) {
        return 2;
    } else {
        return 3;
    }
}
```
  DOC

  edits << <<-DOC
Hello

```C
#include <stdio.h>
#include <string.h>
int test(char*);
int main(int argc, char* argv[]) {
    printf("hello %s", argv[1]);
    return test(argv[2]);
}
int test(char* arg) {
    if (strncmp("zero", arg, 3)) {
        return 0;
    } else if (strncmp("one", arg, 3)) {
        return 1;
    } else if (strncmp("two", arg, 3)) {
        return 2;
    } else {
        return 3;
    }
}
```
  DOC

  edits.each do |edit|
    po.body = edit
    po.save!
  end
end


welcome_rope.posts.create!(:format => "markdown", :body => <<-BODY
# Welcome to Generic Forums! #
We hope that your experience with these forums will be a pleasant one.  If you have any problems setting it up, you can just contact us at <redjazz96@gmail.com>.

Thanks for using Generic Forums!
BODY
) do |p|
  p.user_id = 1
end

b.permissions.create! :action => :read,   :group_id => 1
b.permissions.create! :action => :create, :group_id => 2
b.permissions.create! :action => :manage, :group_id => 3

r = ghost1
posts = ghost1.posts

[:read, :post].each do |p|
  r.permissions.create! :action => p, :group_id => 2
end
r.permissions.create! :action => :read,   :group_id => 1
r.permissions.create! :action => :manage, :group_id => 3

[:edit_post, :see_history].each do |p|
  posts.last.permissions.create! :action => p, :group_id => 2
end
posts.first.permissions.create! :action => :manage, :group_id => 3

ghost2.permissions.create! :action => :manage, :group_id => 3
