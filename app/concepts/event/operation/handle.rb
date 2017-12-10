# frozen_string_literal: true

class Event::Handle < Trailblazer::Operation
  step :authorize!
  failure :handle_unauthorized!, fail_fast: true
  step Nested(:dispatch!)

  def authorize!(_options, params:, **)
    params[:token] == SLACK_TOKEN
  end

  def handle_unauthorized!(options, *)
    options[:status] = :unauthorized
    options[:json] = { error: 'unauthorized' }
  end

  def dispatch!(_options, params:, **)
    case params[:type]
    when 'url_verification'
      Action::Challenge
    when 'event_callback'
      dispatch_event_callback(params)
    else
      Action::Unknown
    end
  end

  private

  def dispatch_event_callback(params)
    case params.dig(:event, :type)
    when 'link_shared'
      Action::LinkShared
    else
      Action::Unknown
    end
  end
end
