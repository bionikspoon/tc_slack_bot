# frozen_string_literal: true

class Action::LinkShared < Trailblazer::Operation
  step :handle!

  def handle!(options, *)
    options[:json] = { status: :ok }
    options[:status] = :ok
  end
end
