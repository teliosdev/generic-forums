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

  cache = {}

  def json_url(record)
    polymorphic_url record, :format => :json, :routing_type => :path
  end

  def board_breadcrumbs(board)
    breadc = []
    breadc.push :name => board.name, :link => url_for(board)
    board_list(board).each do |board|
      breadc.push :name => board.name, :link => url_for(board)
    end
    breadc
  end

  def board_list(board)
    boards = []
    boards.push board
    while cboard = board.parent
      boards.push cboard
    end
    boards
  end
end
