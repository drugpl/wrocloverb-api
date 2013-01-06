class Api::VenuesController < ApiController
  before_filter :require_token, except: [:index, :show]

  def index
    venues = Venue.all
    respond_with venues
  end

  def show
    venue = Venue.find(params[:id])
    respond_with venue
  end

  def create
    venue = Venue.new
    consume!(venue)

    if venue.save
      respond_with venue, status: :created, location: api_venue_url(venue)
    else
      respond_with venue, status: :unprocessable_entity
    end
  end

  def update
    venue = Venue.find(params[:id])
    consume!(venue)

    if venue.save
      head :no_content
    else
      respond_with venue, status: :unprocessable_entity
    end
  end

  def destroy
    venue = Venue.find(params[:id])
    venue.destroy
    head :no_content
  end
end
