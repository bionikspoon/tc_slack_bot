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
    else
      Action::Unknown
    end
  end
end
