module ApplicationHelper
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

    def add(opt)
      push Breadcrumb.new(opt[:name], opt[:link])
    end

    def each(&block)
      @_set.each &block
    end
  end

  def resolve(item, user)
    unless item.is_a?(Post)
      p = item.permissions.where :group_id => user.groups.map { |x| x.id }
      str = ""
      p.find_each do |prm|
        str+= prm.permissions.to_s
      end
    end
    case item.class
    when Board
    when Rope
      str+= resolve item.board, user
    when Post
      str+= resolve item.thread, user
    end
    str = str.split("").sort.join("")
    res = Permission.new do |p|
      p.permissions = str.squeeze
    end
    res
  end

  def json_url(record)
    polymorphic_url record, :format => :json, :routing_type => :path
  end
end
