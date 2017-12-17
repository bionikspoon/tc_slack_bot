# frozen_string_literal: true

class Unfurl::Github < Trailblazer::Operation
  step :handle!

  def handle!(options, *)
    options[:unfurl] = { text: 'Every day is the test.' }
  end
end
