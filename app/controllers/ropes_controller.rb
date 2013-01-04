class RopesController < ApplicationController

  before_filter :load_board, :handle_breadcrumbs
  before_filter :check_create_permissions,  :only => [:new, :create]
  before_filter :check_destroy_permissions, :only => [:destroy]

  helper :posts

  def index
    #puts "DEBUG" + ("_" * 20)
    #p @board.id
    #p params[:page]
    #p AppConfig.user_options.posts_per_page.default
    @threads = Rope.where(:board_id => @board.id, :is_ghost => false).select do |t|
      #(can? :read, t) or t.soft_destroyed?
      true
    end
    @threads = Kaminari.paginate_array(@threads).page(params[:page]).per(current_user.per_page :threads)
  end

  def create
    @thread = Rope.new :title => params[:rope][:title], :main_post_attributes => params[:rope][:main_post_attributes]
    @thread.board = @board
    @thread.user  = current_user
    @thread.set_tags params[:rope][:tags].split(/(?:\s|\,)/).reject { |tag|
      tag.length > 3
    }
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

  def destroy
    if params[:hard] and can? :hard_destroy, @rope
      @rope.hard_destroy
    else
      @rope.soft_destroy
    end
    redirect_to board_ropes_path(@board)
  end

  def undelete
    @rope = Rope.find params[:rope_id]
    return error(400) unless can? :undelete, @rope
    @rope.undestroy
    redirect_to board_rope_posts_path(@board, @rope)
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

  def check_create_permissions
    error(404) unless can? :create, @board
  end

  def check_destroy_permissions
    @rope = Rope.find(params[:id])
    error(404) unless can? :destroy, @rope
  end

end
