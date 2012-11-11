class Api::SpeakersController < ApiController
  before_filter :require_token, except: [:index, :show]

  def index
    speakers = Speaker.all
    respond_with speakers
  end

  def show
    speaker = Speaker.find(params[:id])
    respond_with speaker
  end

  def create
    speaker = Speaker.new
    consume!(speaker)

    if speaker.save
      respond_with speaker, status: :created, location: api_speaker_url(speaker)
    else
      respond_with speaker, status: :unprocessable_entity
    end
  end

  def update
    speaker = Speaker.find(params[:id])
    consume!(speaker)

    if speaker.save
      head :no_content
    else
      respond_with speaker, status: :unprocessable_entity
    end
  end

  def destroy
    speaker = Speaker.find(params[:id])
    speaker.destroy
    head :no_content
  end
end
