# forum options defined in here

GenericForums::Application.config.forum_name     = "{generic forums}"
GenericForums::Application.config.forum_version  = "0.1.1b"
GenericForums::Application.config.max_login_tries= 5

GenericForums::Application.config.user_options   = {
  :boards_per_page => { :name => "Boards Per Page", :default  => 20 },
  :threads_per_page=> { :name => "Threads Per Page", :default => 20 },
  :posts_per_page  => { :name => "Posts Per Page", :default   => 20 }
}
