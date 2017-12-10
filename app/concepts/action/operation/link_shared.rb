# frozen_string_literal: true

class Action::LinkShared < Trailblazer::Operation
  success :queue!
  step :handle!

  def queue!(_options, params:, **)
    params.dig(:event, :links).each do |link|
      UnfurlLinkJob.perform_later(
        token: params[:token],
        channel: params.dig(:event, :channel),
        ts: params.dig(:event, :message_ts),
        domain: link[:domain],
        url: link[:url]
      )
    end
  end

  def handle!(options, *)
    options[:json] = { status: :ok }
    options[:status] = :ok
  end
end
