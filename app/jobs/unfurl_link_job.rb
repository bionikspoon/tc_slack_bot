# frozen_string_literal: true

class UnfurlLinkJob < ApplicationJob
  def perform(**params)
    _perform do
      Unfurl::Dispatch.call(params)
    end
  end
end
