# frozen_string_literal: true

class UnfurlLinkJob < ApplicationJob
  def perform(**params)
    Unfurl::Dispatch.call(params)
  end
end
