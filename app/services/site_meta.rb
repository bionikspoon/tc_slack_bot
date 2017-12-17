# frozen_string_literal: true

class SiteMeta
  class << self
    def call(html)
      doc = Nokogiri::HTML(html)

      open_graph_props(doc)
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
      tag_hash = doc.css('link[rel=icon]').first.to_h.symbolize_keys

      { favicon: tag_hash[:href] }
    end
  end
end
