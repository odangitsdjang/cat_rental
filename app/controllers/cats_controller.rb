class CatsController < ApplicationController
  def index
    @cats = Cat.all
    # @cats = @cats.to_a
    # (3 - (@cats.length % 3)).times { @cats << Cat.new }
    render :index
  end

  def show
    @cat = Cat.find_by(id: params[:id])
    @cat_requests = CatRentalRequest.where(["cat_id = ?", @cat.id]).order(:start_date)
    if @cat
      render :show
    else
      render json: "No cat here"
    end
  end

  def edit
    @cat = Cat.find_by(id: params[:id])
    if @cat
      render :edit
    else
      render json: @cat.errors.full_messages, status: 422
    end
  end

  def update
    @cat = Cat.find_by(id: params[:id])

    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      render json: @cat.errors.full_messages, status: 422
    end
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)

    if @cat.save
      redirect_to cat_url(@cat)
    else
      render json: @cat.errors.full_messages, status: 422
    end

  end

  private

  def cat_params
    params.require(:cat).permit(:name, :sex, :color, :description, :birth_date)
  end
end
