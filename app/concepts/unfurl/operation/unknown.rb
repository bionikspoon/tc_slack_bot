# frozen_string_literal: true

class Unfurl::Unknown < Trailblazer::Operation
  step :fail!

  def fail!(_options, *)
    false
  end
end
