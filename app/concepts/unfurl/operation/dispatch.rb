# frozen_string_literal: true

class Unfurl::Dispatch < Trailblazer::Operation
  step :unfurl_each!
  step :process_unfurls!
  step :set_body!
  step :update_slack!

  # def dispatch!(_options, params:, **)
  #   case params[:domain]
  #   when 'github.com'
  #     Unfurl::Github
  #   when 'pivotaltracker.com'
  #     Unfurl::Pivotal
  #   else
  #     Unfurl::Unknown
  #   end
  # end

  def unfurl_each!(options, params:, **)
    options[:unfurl_pairs] = params[:links].map do |link|
      [
        link[:url],
        dispatch(link)
      ]
    end
  end

  def process_unfurls!(options, unfurl_pairs:, **)
    options[:unfurls] = unfurl_pairs.map do |key, result|
      [key, result[:unfurl]]
    end.to_h.symbolize_keys
  end

  def set_body!(options, unfurls:, params:, **)
    options[:body] = {
      channel: params[:channel],
      ts: params[:ts],
      unfurls: unfurls
    }
  end

  def update_slack!(_options, body:, **)
    API::Slack.unfurl(body)
  end

  private

  def dispatch(url:, domain:)
    case domain
    when 'github.com'
      Unfurl::Github.call(url: url)
    when 'pivotaltracker.com'
      Unfurl::Pivotal.call(url: url)
    else
      Unfurl::Unknown.call(url: url)
    end
  end
end
