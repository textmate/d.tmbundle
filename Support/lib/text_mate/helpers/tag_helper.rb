require_relative 'options_helper'

module TextMate
  module Helpers
    module TagHelper
      include OptionsHelper

      # Creates an HTML tag with the given name and content.
      #
      # @param name [String, Symbol] the name of the tag
      #
      # @param content [String, { Symbol => String }] the content of the tag. If a block is
      #   given this is considered to be the same as options
      #
      # @param options [{ Symbol => String }] this hash will be converted to HTML attributes
      #
      # @param escape [Boolean] if true will escape HTML. Defaults to true when no block is
      #   given
      #
      # @param block [Proc] if a block is given, the return value will be used as content
      #
      # @return [String] the HTML tag
      def content_tag (name, content = nil, options = {}, escape = nil, &block)
        if block_given?
          options = content if content.is_a?(Hash)
          escape = false if escape.nil?
          content_tag_string(name, block.call, options, escape)
        else
          escape = true if escape.nil?
          content_tag_string(name, content, options, escape)
        end
      end

      # Creates an HTML start or end tag with the given name.
      #
      # @param name [Symbol, String] the name of the tag
      # @param options [Hash] hash of options
      #
      # @option options [Boolean] :end_tag (false) if true it will return an end tag
      #
      # @option options [Boolean] :self_closing (false) if true it will return self closing
      #   tag
      #
      # @option options [Boolean] :escape (true) if true will escape HTML
      #
      # @option option [{ Symbol => String }] :options ({}) a hash of options that will
      #   be converted to HTML attributes. Will be ignored if :end_tag or :self_closing is
      #   true
      def tag (name, options = {})
        name = ERB::Util.html_escape(name) if options[:escape]
        return "</#{name}>" if options[:end_tag]
        return "<#{name} />" if options[:self_closing]

        attributes = tag_options(options[:options] || {}, options[:escape])
        result = "<#{name}"
        result << " #{attributes}" unless attributes.empty?
        result << ">"
      end

    private

      def content_tag_string (name, content, options, escape)
        content = ERB::Util.html_escape(content) if escape
        tag(name, :options => options) << content << tag(name, :end_tag => true)
      end
    end
  end
end
