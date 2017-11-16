# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "pathutil"
require_relative "../utils"
require "jekyll/assets"
require "jekyll"

module Jekyll
  module Assets
    module Plugins
      # --
      # Searches for `<img>` that have `<img asset>` or
      # `<img asset="args">` and runs them through the asset
      # system.  This allows you to use real assets inside
      # of your Markdown pre-convert.
      # --
      class Searcher
        def initialize(doc)
          @doc = doc
        end

        # --
        def run
          html.search("img[@asset]").each do |v|
            raise ArgumentError, "src is empty" unless v[:src]
            args = "#{v.delete('src')&.value} #{v.delete('asset')&.value}"
            pctx = ::Liquid::ParseContext.new

            attrs = v.attributes.keys
            args, = Tag.new("asset", args, pctx).render_raw(ctx)
            args.to_h(html: true).each do |k, vv|
              unless attrs.include?(k.to_s)
                v.set_attribute(k, vv)
              end
            end
          end

          @doc.output = html
            .to_html
        end

        # --
        private
        def ctx
          ::Liquid::Context.new({}, {}, {
            site: @doc.site,
          })
        end

        # --
        private
        def html
          @html ||= begin
            Nokogiri::HTML.parse(@doc.output)
          end
        end
      end
    end
  end
end

Jekyll::Hooks.register [:pages, :documents, :posts], :post_render do |d|
  Jekyll::Assets::Plugins::Searcher.new(d).run
end