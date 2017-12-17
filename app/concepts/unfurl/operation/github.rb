# frozen_string_literal: true

class Unfurl::Github < Trailblazer::Operation
  step :do_everything!

  def do_everything!(options, params:, **)
    pr = pull(params[:url])

    options[:unfurl] = if pr.nil?
                         get_public_url_meta(params[:url])
                       else
                         get_pr_meta(pr)
                       end
  end

  private

  def pull(url)
    uri = URI(url)
    match = %r{/ThinkCERCA/thinkCERCA/pull/(\d+)}.match(uri.path)
    match[1] unless match.nil?
  end

  def get_pr_meta(_pr)
    {
      text: 'Every day is the test.'
    }
  end

  def get_public_url_meta(url)
    meta = SiteMeta.from_url(url)

    meta.merge(
      title_link: meta[:url],
      text: meta[:description],
      thumb_url: meta[:image],
      author_name: meta[:site_name],
      author_link: meta[:url],
      author_icon: meta[:favicon]
    )
  end
end
