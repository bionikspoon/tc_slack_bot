# frozen_string_literal: true

class Unfurl::Github < Trailblazer::Operation
  step :handle!

  def handle!(_options, *)
    true
  end
end
