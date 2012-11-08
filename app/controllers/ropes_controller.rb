class RopesController < ApplicationController

  before_filter :load_board, :handle_breadcrumbs
  before_filter :check_permissions, :only => [:show]
  before_filter :check_create_permissions, :only => [:new, :create]

  def index
    #puts "DEBUG" + ("_" * 20)
    #p @board.id
    #p params[:page]
    #p AppConfig.user_options.posts_per_page.default
    @threads = Rope.where(:board_id => @board.id, :is_ghost => false)
      .page(params[:page]).per(@user.per_page :threads) #(:page => params[:page], :per_page => @user.per_page(:threads))
  end

  def create
    puts "ERROR_STILL_NOT_RIGHT_" + ("_"*20) if cannot? :create, @board
    @thread = Rope.new params[:rope]
    @thread.board = @board
    @thread.user  = @user
    @thread.main_post.rope = @thread
    @thread.main_post.user = @user
    p @thread, @thread.main_post
    unless @thread.save
      render "new"
    else
      @thread.touch
      redirect_to board_rope_posts_path(@thread.board.id, @thread.id)
    end

  end

  def new
    @thread       = Rope.new
    @thread.board = @board
    @thread.user  = @user
    @post         = Post.new
    @post.rope    = @thread
    @thread.main_post = @post
    @breadcrumbs.add :name => "New Thread", :link => "#!/", :class => "new_thread_breadcrumb"
  end

  def show
    @thread  = Rope.find(params[:id])
  end

  protected

  def load_board
    @board   = Board.find(params[:board_id])
  end

  def handle_breadcrumbs
    board_breadcrumbs(@board).each do |b|
      @breadcrumbs.add b
    end if @board
  end

  def check_permissions
    render 'error/404' unless can? :read, @board
    render 'error/404' unless @thread and can? :read, @thread
  end

  def check_create_permissions
    render 'error/404' unless can? :create, @board
  end

end
