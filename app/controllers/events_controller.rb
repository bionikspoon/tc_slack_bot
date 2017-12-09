class EventsController < ApplicationController
  before_action :authorize!
  before_action :accept_action!

  # POST /events
  def create
    render json: event_params.slice(:challenge)
  end

  private
    def authorize!
      if params.require(:token) != SLACK_TOKEN
        render json: {error: 'unauthorized'}, status: :unauthorized
      end
    end
    def accept_action!
      if event_params[:type] !='url_verification'
        render json: {error: 'unprocessable_entity'}, status: :unprocessable_entity
      end
    end


    # Only allow a trusted parameter "white list" through.
    def event_params
      params.permit(:challenge, :type, :token)
    end
end
