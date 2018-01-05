class CatRentalRequestsController < ApplicationController
  def approve
    if current_user.id == current_cat.user_id
      current_cat_rental_request.approve!
      redirect_to cat_url(current_cat)
    else
      flash[:errors] = ["Not yo cat, son"]
      redirect_to cat_url(current_cat)
    end
  end

  def create
    @rental_request = CatRentalRequest.new(cat_rental_request_params)
    @rental_request.user_id = current_user.id
    @rental_request.cat = params[:cat_id]
    if @rental_request.save
      redirect_to cat_url(@rental_request.cat)
    else
      flash.now[:errors] = @rental_request.errors.full_messages
      render :new
    end
  end

  def deny
    if current_user.id == current_cat.user_id
      current_cat_rental_request.deny!
      redirect_to cat_url(current_cat)
    else
      flash[:errors] = ["Not yo cat, son"]
      redirect_to cat_url(current_cat)
    end
  end

  def new
    @rental_request = CatRentalRequest.new
  end

  private

  def current_cat_rental_request
    @rental_request ||=
      CatRentalRequest.includes(:cat).find(params[:id])
  end

  def current_cat
    current_cat_rental_request.cat
  end

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :end_date, :start_date, :status, :user_id)
  end

  private

  def is_requester?
    @rental_request.user_id == current_user.id
  end

  def is_owner?
    @rental_request.user_id == current_cat.id
  end
end
