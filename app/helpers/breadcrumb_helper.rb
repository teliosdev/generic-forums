module BreadcrumbHelper
  class Breadcrumb
    attr_accessor :name, :link, :info

    def initialize(name=nil, link=nil, info={})
      @name = name
      @link = link
      @info = {}
    end
  end

  class BreadcrumbSet < Array

    def add(opt)
      push Breadcrumb.new(opt[:name], opt[:link], opt[:info] || {})
    end

  end
end
