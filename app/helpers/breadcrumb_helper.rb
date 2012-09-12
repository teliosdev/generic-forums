module BreadcrumbHelper
  class Breadcrumb
    attr_accessor :name, :link, :info

    def initialize(name=nil, link=nil, info={})
      @name = name
      @link = link
      @info = {}
    end
  end

  class BreadcrumbSet
    def initialize
      @_set = []
    end

    def [](index)
      @_set[index]
    end

    def []=(index, value)
      @_set[index] = value
    end

    def push(value)
      @_set.push value
    end

    def length
      @_set.length
    end

    def add(opt)
      push Breadcrumb.new(opt[:name], opt[:link])
    end

    def each(&block)
      @_set.each &block
    end
  end
end
