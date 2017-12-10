# frozen_string_literal: true

class Action::Unknown < Trailblazer::Operation
  step :handle!
  failure :handle_unknown!

  def handle!(_options, *)
    false
  end

  def handle_unknown!(options, *)
    options[:status] = :unprocessable_entity
    options[:json] = { error: :unprocessable_entity }
  end
end
