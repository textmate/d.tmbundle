require File.join(File.dirname(__FILE__), "tag_helper")

module TextMate
  module Helpers
    module UrlHelper
      include TagHelper

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