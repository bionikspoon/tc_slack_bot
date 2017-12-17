# frozen_string_literal: true

class SiteMeta
  class << self
    def call(html)
      doc = Nokogiri::HTML(html)

      {}
        .merge(open_graph_props(doc))
        .merge(favicon(doc))
    end

    private

    def open_graph_props(doc)
      doc
        .css('meta[property^=og]')
        .map { |tag| tag.to_h.symbolize_keys }
        .map { |tag| [tag[:property].sub('og:', ''), tag[:content]] }
        .to_h
        .symbolize_keys
    end

    def favicon(doc)
      uri = URI(doc.css('meta[property="og:url"]').first.attributes['content'].value)
      uri.path = '/favicon.ico'

      { favicon: uri.to_s }
    end
  end
end
