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
      def append_class!(options, *new_classes)
        return options if new_classes.empty?
        key = options.key?('class') ? 'class' : :class

        cls = options[key].to_s
        cls << ' ' unless cls.empty?

        cls << new_classes.join(' ')
        options[key] = cls
        options
      end

      # Converts the given Ruby options to HTML attributes.
      #
      # @param options [{ Symbol => String }]
      # @param escape [Boolean] if true will escape HTML
      #
      # @return [String] the HTML attributes
      def tag_options(options, escape = true)
        options.map do |attribute, value|
          attribute = ERB::Util.html_escape(attribute) if escape
          value = ERB::Util.html_escape(value) if escape
          "#{attribute}=\"#{value}\""
        end.join(' ')
      end

      # Extras the hash of options in the given array.
      #
      # Extracts the last element in the given array that is a <tt>Hash<\tt>,
      # replaces the last element with the hash and the current element with
      # <tt>nil<\tt>. If there's no hash in the array the last element will
      # be replaced with an empty hash.
      #
      # @param args [Array<Object>] the arguments to extract the hash from
      #
      # @return [Array<Object>] a new array with the hash as its last element
      def extract_options(*args)
        args = args.dup
        index = args.rindex { |e| e.is_a?(Hash) } || args.length
        args[-1] = args[index] || {}
        args[index] = nil if index < args.length - 1
        args
      end
    end
  end
end
