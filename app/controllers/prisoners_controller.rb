class PrisonersController < ApplicationController
  def create
    @prisoner = Prisoner.create(prisoner_params)
    if @prisoner
      head :created, location: prisoner_url(@prisoner)
    else
      head :failure
    end
  end

  def show
    load_prisoner
    if @prisoner
      render json: @prisoner
    else
      head :not_found
    end
  end

  private

  def prisoner_params
    @prisoner_params ||= params.require(:prisoner).permit(
      :name, :rank, :serial_number)
  end

  def load_prisoner
    @prisoner ||= Prisoner.first(params[:id])
  end
end
