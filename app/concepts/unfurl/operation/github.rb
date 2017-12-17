# frozen_string_literal: true

class Unfurl::Github < Trailblazer::Operation
  step :handle!

  def handle!(options, params:, **)
    options[:unfurl] = get_unfurl(params[:url])
  end

  private

  def get_unfurl(url)
    case URI(url).path
    when %r{/(?<owner>.+)/(?<repo>.+)/pull/(?<number>\d+)}i
      private_pr_meta(
        $LAST_MATCH_INFO['owner'],
        $LAST_MATCH_INFO['repo'],
        $LAST_MATCH_INFO['number']
      )
    else
      public_url_meta(url)
    end
  end

  def private_pr_meta(owner, repo, number)
    meta = API::Github.pr(owner, repo, number)
    title = "#{meta[:title]} · Pull Request #{meta[:number]} · #{meta.dig(:head, :repo, :full_name)}"
    changes = "+#{meta[:additions]} / -#{meta[:deletions]} / #{meta[:changed_files]} #{'file'.pluralize(meta[:changed_files])}"
    fields = []

    if meta[:state] == 'open'
      fields << { title: 'Changes', value: changes, short: true }
      fields << { title: 'Branch', value: "`#{meta.dig(:head, :ref)}`", short: true }
    end

    if owner.casecmp('thinkcerca').zero?
      stories = pivotal_stories(meta[:title])
      if stories.count.positive?
        fields << {
          title: 'Pivotal',
          value: stories.join("\n"),
          short: false
        }
      end
    end

    {
      author_icon: meta.dig(:user, :avatar_url),
      author_link: meta.dig(:user, :html_url),
      author_name: meta.dig(:user, :login),
      fallback: title,
      footer_icon: 'https://github.com/favicon.ico',
      footer: 'Github',
      mrkdwn_in: %i[text fields],
      text: meta[:body],
      title_link: meta[:html_url],
      title: title,
      fields: fields,
      color: pr_color(meta)
    }
  end

  def pivotal_stories(title)
    title.scan(/[^#]*#(\d+)(?=[,\]\s])/).map { |story| "https://pivotaltracker.com/story/show/#{story[0]}" }
  end

  def pr_color(meta)
    if meta[:merged]
      '6f42c1'
    else
      case meta[:state]
      when 'open'
        '2cbe4e'
      when 'closed'
        'cb2431'
      end
    end
  end

  def public_url_meta(url)
    meta = SiteMeta.from_url(url)

    {
      footer_icon: meta[:favicon],
      footer: meta[:site_name],
      text: meta[:description],
      thumb_url: meta[:image],
      title_link: meta[:url],
      title: meta[:title]
    }
  end
end
