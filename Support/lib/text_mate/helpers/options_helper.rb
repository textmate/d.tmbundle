module TextMate
  module Helpers
    module OptionsHelper
      # Appends the given classes to the given options hash.
      #
      # It will look for both the "class" and :class key. This will create a new
      # :class key in the given hash if neither exists.
      #
      # @param options [Hash] hash of options to append the classes to
      # @param new_classes [Array<String>] the classes to append
      #
      # @return [Hash] options
      def append_class! (options, *new_classes)
        return options if new_classes.empty?
        key = options.key?("class") ? "class" : :class

        cls = options[key].to_s
        cls << " " unless cls.empty?

        cls << new_classes.join(" ")
        options[key] = cls
        options
      end

      # Converts the given Ruby options to HTML attributes.
      #
      # @param options [{ Symbol => String }]
      # @param escape [Boolean] if true will escape HTML
      #
      # @return [String] the HTML attributes
      def tag_options (options, escape = true)
        options.map do |attribute, value|
          attribute = ERB::Util.html_escape(attribute) if escape
          value = ERB::Util.html_escape(value) if escape
          "#{attribute}=\"#{value}\""
        end.join(" ")
      end
    end
  end
end