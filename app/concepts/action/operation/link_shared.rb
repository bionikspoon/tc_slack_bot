# frozen_string_literal: true

class Action::LinkShared < Trailblazer::Operation
  success :queue!
  step :handle!

  def queue!(_options, params:, **)
    UnfurlLinkJob.perform_later(
      channel: params.require(:event).require(:channel),
      ts: params.require(:event).require(:message_ts),
      links: params.require(:event).permit(links: %i[domain url])
        .to_h.deep_symbolize_keys[:links]
    )
  end

  def handle!(options, *)
    options[:json] = { status: :ok }
    options[:status] = :ok
  end
end
