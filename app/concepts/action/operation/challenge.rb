# frozen_string_literal: true

class Action::Challenge < Trailblazer::Operation
  step :handle!

  def handle!(options, params:, **)
    options[:json] = params.slice(:challenge)
    options[:status] = :ok
  end
end
