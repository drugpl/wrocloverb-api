class Api::SupportersController < ApiController
  before_filter :require_token, except: [:index, :show]

  def index
    supporters = Supporter.all
    respond_with supporters
  end

  def show
    supporter = Supporter.find(params[:id])
    respond_with supporter
  end

  def create
    supporter = Supporter.new
    consume!(supporter)

    if supporter.save
      respond_with supporter, status: :created, location: api_supporter_url(supporter)
    else
      respond_with supporter, status: :unprocessable_entity
    end
  end

  def update
    supporter = Supporter.find(params[:id])
    consume!(supporter)

    if supporter.save
      head :no_content
    else
      respond_with supporter, status: :unprocessable_entity
    end
  end

  def destroy
    supporter = Supporter.find(params[:id])
    supporter.destroy
    head :no_content
  end

  protected

  def require_token
    authenticate_or_request_with_http_basic { |token, password| ApiToken.find_by_token(token) }
  end    
end
