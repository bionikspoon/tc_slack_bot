# frozen_string_literal: true

class Action::LinkShared < Trailblazer::Operation
  success :queue!
  step :handle!

  def queue!(_options, params:, **)
    links = params.require(:event).permit(links: %i[domain url])
                  .to_h.deep_symbolize_keys[:links]

    links.each do |link|
      UnfurlLinkJob.perform_async(
        channel: params.require(:event).require(:channel),
        ts: params.require(:event).require(:message_ts),
        links: [link]
      )
    end
  end

  def handle!(options, *)
    options[:json] = { status: :ok }
    options[:status] = :ok
  end
end
