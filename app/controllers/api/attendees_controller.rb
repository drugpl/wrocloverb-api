class Api::AttendeesController < ApiController
  before_filter :require_token, except: [:index, :show]

  def index
    attendees = Attendee.all
    respond_with attendees
  end

  def show
    attendee = Attendee.find(params[:id])
    respond_with attendee
  end

  def create
    attendee = Attendee.new
    consume!(attendee)

    if attendee.save
      respond_with attendee, status: :created, location: api_attendee_url(attendee)
    else
      respond_with attendee, status: :unprocessable_entity
    end
  end

  def update
    attendee = Attendee.find(params[:id])
    consume!(attendee)

    if attendee.save
      head :no_content
    else
      respond_with attendee, status: :unprocessable_entity
    end
  end

  def destroy
    attendee = Attendee.find(params[:id])
    attendee.destroy
    head :no_content
  end
end
