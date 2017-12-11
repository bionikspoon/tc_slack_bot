# frozen_string_literal: true

class Unfurl::Dispatch < Trailblazer::Operation
  # step Nested(:dispatch!)
  step :do_everything!

  def dispatch!(_options, params:, **)
    case params[:domain]
    when 'github.com'
      Unfurl::Github
    when 'pivotaltracker.com'
      Unfurl::Pivotal
    else
      Unfurl::Unknown
    end
  end

  def do_everything!(_options, params:, **)
    unfurls_pairs = params[:links].map do |link|
      [
        link[:url],
        {
          text: 'Every day is the test.'
        }
      ]
    end
    unfurls = unfurls_pairs.to_h

    headers = {
      'Authorization' => "Bearer #{SLACK_OAUTH_TOKEN}",
      'Content-Type' => 'application/json; charset=utf-8'
    }

    body = {
      channel: params[:channel],
      ts: params[:ts],
      unfurls: unfurls
    }
    API::Slack.post(
      '/chat.unfurl',
      headers: headers,
      body: body.to_json
    )
  end
end
