# frozen_string_literal: true

class Unfurl::Pivotal < Trailblazer::Operation
  step :handle!

  def handle!(options, params:, **)
    options[:unfurl] = get_unfurl(params[:url])
  end

  private

  def get_unfurl(url)
    case URI(url).path
    when %r{/story/show/(?<story>\d+)}i
      private_story_meta($LAST_MATCH_INFO['story'])
    else
      public_url_meta(url)
    end
  end

  def private_story_meta(story)
    meta = API::Pivotal.story(story)
    title = "#{meta[:name]} · ##{meta[:id]}"

    fields = []

    if meta[:labels].count.positive?
      labels = meta[:labels].map { |label| "`#{label[:name]}`" }.join(' ')
      fields << { title: 'Labels', value: labels, short: false }
    end

    {
      footer_icon: 'https://pivotaltracker.com/favicon.ico',
      footer: 'Pivotal',
      mrkdwn_in: %i[text fields],
      text: meta[:description],
      title_link: meta[:url],
      title: title,
      fields: fields,
      color: story_color(meta[:current_state])
    }
  end

  def story_color(state)
    case state
    when 'unscheduled'
      'e4eff7'
    when 'unstarted'
      'ffffff'
    when 'started'
      'e0e2e5'
    when 'finished'
      '203e64'
    when 'delivered'
      'f39300'
    when 'accepted'
      '629200'
    when 'rejected'
      'a71f39'
    end
  end

  def public_url_meta(url)
    meta = SiteMeta.from_url(url)

    {
      footer_icon: meta[:favicon],
      footer: 'Pivotal',
      text: meta[:description],
      thumb_url: meta[:image],
      title_link: meta[:url],
      title: meta[:title]
    }
  end
end
