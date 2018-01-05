class CatsController < ApplicationController
  before_action :require_login, only: [:update, :edit]
  def index
    if logged_in?
      @cats = Cat.all
      render :index
    else
      redirect_to new_session_url
    end
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = find_cat
    if @cat.user_id == current_user.id
      render :edit
    else
      flash[:errors] = ["That's not your cat. You can't edit it. Foo."]
      redirect_to cat_url(@cat)
    end
  end

  def update
    @cat = find_cat
    if @cat.user_id == current_user
      if @cat.update_attributes(cat_params)
        redirect_to cat_url(@cat)
      else
        flash.now[:errors] = @cat.errors.full_messages
        render :edit
      end
    else
      flash[:errors] = ["That's not your cat. You can't edit it. Foo."]
      redirect_to cat_url(@cat)
    end
  end

  private

  def find_cat
    Cat.find_by(params[:user_id])
  end

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :description, :name, :sex, :user_id)
  end
end
