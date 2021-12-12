class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @pets = @application.pets
    if params[:search].present?
      @pets = Pet.search(params[:search])
    end
  end

  def new
  end

  def create
    application = Application.create(application_params)

    if application.save
      redirect_to "/applications/#{application.id}"
    else
      flash[:alert] = "Error: Name can't be blank, Address can't be blank, City can't be blank, State can't be blank, Zip can't be blank, Description can't be blank"
      redirect_to "/applications/new"
    end
  end

  private

  def application_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
