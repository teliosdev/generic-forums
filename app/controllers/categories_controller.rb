class CategoriesController < ApplicationController

  load_and_authorize_resource

  def index

  end

  def show
    @ropes = Rope.accessible_by(current_ability).where(
      category_id: @category.id
    ).includes(:user, :last_post => [:user]).
    order(:updated_at).page(params[:page])

    render "show", category: @category, ropes: @ropes
  end
end
