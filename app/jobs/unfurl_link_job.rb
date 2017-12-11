# frozen_string_literal: true

class UnfurlLinkJob < ApplicationJob
  queue_as :default

  def perform(**params)
    Unfurl::Dispatch.call(params)
  end
end
