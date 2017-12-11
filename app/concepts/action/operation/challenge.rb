# frozen_string_literal: true

class Action::Challenge < Trailblazer::Operation
  step :handle!

  def handle!(options, params:, **)
    options[:json] = { challenge: params.require(:challenge) }
    options[:status] = :ok
  end
end
