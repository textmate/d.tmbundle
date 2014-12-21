require File.join(File.dirname(__FILE__), 'tag_helper')

module TextMate
  module Helpers
    module UrlHelper
      include TagHelper

      TEXT_MATE_PROTOCOL = 'txmt://open?url=file://'

      # Create an error link linking to a file on disk using the txmt protocol.
      #
      # @param message [String] the error message
      # @param display_name [String] a short version of the file to link to
      # @param file [String] the full path to the file to link to
      # @param line [String, Integer] the line of the file to link to
      #
      # @param options [{ Symbol => String }] this hash will be converted to
      #   HTML attributes
      #
      # @return [String] the error link
      def link_to_error(message, display_name, file, line = nil, options = {})
        text = display_name
        text += "(#{line})" if line
        text = ERB::Util.html_escape(text)

        message = ': ' + ERB::Util.html_escape(message)

        content_tag(:span, class: 'err') do
          link_to_txmt(text, file, line, options) +
            message +
            tag(:br, self_closing: true)
        end
      end

      # Creates an HTML link linking to a file on disk using the txmt protocol.
      #
      # @param text [String] the text of the link. If a block is given this is
      # considered to be the same as file
      #
      # @param file [String] the full path to the file to link to. If a block
      #   is given this is considered to be the same as line
      #
      # @param line [String, Integer] the line of the file to link to. If a
      #   block is given this is considered to be the same as options
      #
      # @param options [{ Symbol => String }] this hash will be converted to
      #   HTML attributes
      #
      # @param block [Proc] the text of the link
      #
      # @return [String] the link
      def link_to_txmt(text, file, line = nil, options = {}, &block)
        if block_given?
          options = line
          line = file
          file = text
        end

        line = line.to_s
        line = "&line=#{line}" unless line.empty?
        url = TEXT_MATE_PROTOCOL + file + line

        if block_given?
          link_to(url, options, &block)
        else
          link_to(text, url, options)
        end
      end

      # Creates an HTML link with the given text an URL.
      #
      # @param text [String] the text of the link. If a block is given this is
      #   considered to be the same as url
      #
      # @param url [String] the URL of the link. If a block is given this is
      #   considered to be the same as options
      #
      # @param options [{ Symbol => String }] this hash will be converted to
      #   HTML attributes
      #
      # @return [String] the HTML link
      def link_to(text, url = nil, options = {}, &block)
        if block_given?
          options = url || {}
          url = text
        end

        options = { href: url }.merge(options)

        if block_given?
          content_tag(:a, options, &block)
        else
          content_tag(:a, text, options)
        end
      end
    end
  end
end
