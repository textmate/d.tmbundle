require 'pathname'

TextMate.require_bundle 'lib/text_mate/helpers/url_helper'

module DMate
  class ErrorHandler
    include TextMate::Helpers::UrlHelper

    EXCEPTION_PATTERN = /^(.*?)@(.*?)\((\d+)\):(.*)?/
    COMPILE_ERROR_PATTERN = /^(.*?)\((\d+)(,(\d+))?\): (.+)?/

    def handle(line, type)
      return if type != :err

      args = if line =~ EXCEPTION_PATTERN
        handle_exception(Regexp.last_match[1], Regexp.last_match[2],
          Regexp.last_match[3], Regexp.last_match[4])
      elsif line =~ COMPILE_ERROR_PATTERN
        handle_compile_error(Regexp.last_match[1], Regexp.last_match[2],
          Regexp.last_match[4], Regexp.last_match[5])
      end

      return if args.nil?

      message, display_name, file, line, column = args
      error_marks(file, line, column, message)
      link_to_error message, display_name, file, line, column
    end

    private

    def handle_exception(exception, file, line, message)
      display_name = display_name(file)
      display_name = "#{exception}@#{display_name}"

      return message, display_name, file, line
    end

    def handle_compile_error(file, line, column_or_message, message = nil)
      if message.nil?
        message = column_or_message
      else
        column = column_or_message
      end

      return message, display_name(file), file, line, column
    end

    def error_marks(file, line, column, message)
      return unless file && line

      column ||= 1
      type = message =~ /^(error|warning|note):/i ? $1 : nil
      type ||= message =~ /^deprecation:/i ? 'warning' : 'error'

      pattern = "#{type}:"
      value = "#{type.downcase}:#{message}"

      args = [file, "--line=#{line}:#{column}", "--set-mark=#{value}"]
      system(ENV['TM_MATE'], *args)
    end

    def display_name(path)
      File.basename(path)
    end
  end
end
