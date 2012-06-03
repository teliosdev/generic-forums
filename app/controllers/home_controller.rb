class HomeController < ApplicationController
  def index
    @breadcrumbs.add :name => "Error", :link => "/home/error"
  end

  def error
    flash[:error] = "testing"
    redirect_to "/home/index"
  end
end
