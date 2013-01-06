class Api::OrganizersController < ApiController
  before_filter :require_token, except: [:index, :show]

  def index
    organizers = Organizer.all
    respond_with organizers
  end

  def show
    organizer = Organizer.find(params[:id])
    respond_with organizer
  end

  def create
    organizer = Organizer.new
    consume!(organizer)

    if organizer.save
      respond_with organizer, status: :created, location: api_organizer_url(organizer)
    else
      respond_with organizer, status: :unprocessable_entity
    end
  end

  def update
    organizer = Organizer.find(params[:id])
    consume!(organizer)

    if organizer.save
      head :no_content
    else
      respond_with organizer, status: :unprocessable_entity
    end
  end

  def destroy
    organizer = Organizer.find(params[:id])
    organizer.destroy
    head :no_content
  end
end