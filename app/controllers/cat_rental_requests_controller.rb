class CatRentalRequestsController < ApplicationController
  def new
    @cat_id = params[:cat_id]
    @cat_id = @cat_id.to_i unless @cat_id.nil?
    # byebug
    @cat_request = CatRentalRequest.new
    @cats = Cat.all
    render :new
  end

  def edit

  end

  def create
    @cat_request = CatRentalRequest.new(cat_rental_request_params)
    if @cat_request.save
      redirect_to cat_url(@cat_request.cat_id)
    else
      render json: @cat.errors.full_messages, status: 422
    end
  end


  def approve!
    @cat_request = CatRentalRequest.find_by(id: params[:id])
    @cat_request.approve!

    redirect_to cat_url(@cat_request.cat_id)
  end

  private

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end

end
