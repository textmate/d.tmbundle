require File.join(File.dirname(__FILE__), "tag_helper")

module TextMate
  module Helpers
    module UrlHelper
      include TagHelper

      TEXT_MATE_PROTOCOL = "txmt://open?url=file://"

      # Creates an HTML link linking to a file on disk using the txmt protocol.
      #
      # @param text [String] the text of the link
      # @param file [String] the path to the file to link to
      # @param line [String, Integer] the line of the file to link to
      # @param options [{ Symbol => String }] this hash will be converted to HTML attributes
      def link_to_txmt (text, file, line = nil, options = {})
        line = line.to_s
        line = "&line=#{line}" unless line.empty?
        url = TEXT_MATE_PROTOCOL + file + line
        link_to(text, url, options)
      end

      # Creates an HTML link with the given text an URL.
      #
      # @param text [String] the text of the link. If a block is given this is considered to
      #   be the same as url
      #
      # @param url [String] the URL of the link. If a block is given this is considered to
      #   be the same as options
      #
      # @param options [{ Symbol => String }] this hash will be converted to HTML attributes
      #
      # @return [String] the HTML link
      def link_to (text, url = nil, options = {}, &block)
        if block_given?
          options = url || {}
          url = text
          text = block.call
        end

        options = { :href => url }.merge(options)
        content_tag(:a, text, options)
      end
    end
  end
end