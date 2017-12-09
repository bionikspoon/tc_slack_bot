class EventsController < ApplicationController
  before_action :authorize!
  before_action :accept_action!

  # POST /events
  def create
    render json: event_params.slice(:challenge)
  end

  private

  def authorize!
    json = { error: 'unauthorized' }
    invalid_token = params.require(:token) != SLACK_TOKEN

    render json: json, status: :unauthorized if invalid_token
  end

  def accept_action!
    json = { error: 'unprocessable_entity' }
    invalid_type = event_params[:type] != 'url_verification'

    render json: json, status: :unprocessable_entity if invalid_type
  end

  # Only allow a trusted parameter "white list" through.
  def event_params
    params.permit(:challenge, :type, :token)
  end
end
