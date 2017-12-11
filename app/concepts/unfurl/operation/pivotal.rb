# frozen_string_literal: true

class Unfurl::Pivotal < Trailblazer::Operation
  step :handle!

  def handle!(_options, *)
    true
  end
end
