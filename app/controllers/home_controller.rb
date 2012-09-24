class HomeController < ApplicationController

  def index
    @breadcrumbs.add :name => "Error", :link => "/home/error"
  end

  # The Markdown file used to generate this is in
  # app/views/home/_rules.md.  It is recommended that you write your
  # own rules instead of using generic forums'; rules should be
  # specific to the community that the board is used for.
  def rules

  end

  # The Markdown file used to generate this is in
  # app/views/home/_about.md.  It's not needed to change this.
  def about
    @breadcrumbs.add :name => "About", :link => home_about_path
  end

  def error
    flash[:error] = "testing"
    redirect_to "/home/index"
  end
end
