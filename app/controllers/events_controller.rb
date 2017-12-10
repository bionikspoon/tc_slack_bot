class EventsController < ApplicationController
  # POST /events
  def create
    run Event::Handle

    render json: result[:json], status: result[:status]
  end

  private

  # Only allow a trusted parameter "white list" through.
  def event_params
    params.permit(:challenge, :type, :token)
  end
end
