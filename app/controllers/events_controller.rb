# frozen_string_literal: true

class EventsController < ApplicationController
  # POST /events
  def create
    run Event::Handle

    render json: result[:json], status: result[:status]
  end
end
