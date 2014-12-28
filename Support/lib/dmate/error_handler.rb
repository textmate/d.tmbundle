require 'pathname'

TextMate.require_bundle 'lib/text_mate/helpers/url_helper'

module DMate
  class ErrorHandler
    include TextMate::Helpers::UrlHelper

    EXCEPTION_PATTERN = /^(.*?)@(.*?)\((\d+)\):(.*)?/
    COMPILE_ERROR_PATTERN = /^(.*?)\((\d+)(,(\d+))?\): (.+)?/

    def handle(line, type)
      return if type != :err

      if line =~ EXCEPTION_PATTERN
        handle_exception(Regexp.last_match[1], Regexp.last_match[2],
          Regexp.last_match[3], Regexp.last_match[4])
      elsif line =~ COMPILE_ERROR_PATTERN
        handle_compile_error(Regexp.last_match[1], Regexp.last_match[2],
          Regexp.last_match[4], Regexp.last_match[5])
      end
    end

    private

    def handle_exception(exception, module_name, line, message)
      path = DMate.module_to_path(module_name)
      file, url, display_name = DMate.actual_path_name(path)
      url = '' if File.executable?(file)
      display_name = exception + '@' + DMate.display_name(module_name)

      error_marks(file, line, nil, message)

      link_to_error message, display_name, file, line
    end

    def handle_compile_error(file, line, column_or_message, message = nil)
      if message.nil?
        message = column_or_message
      else
        column = column_or_message
      end

      file, url, display_name = DMate.actual_path_name(file)
      error_marks(file, line, column, message)

      link_to_error message, display_name, file, line, column
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
  end

  module_function

  def display_name(module_name)
    if File.file?(module_name)
      ext = File.extname(module_name)
      File.basename(module_name, ext)
    else
      module_name
    end
  end

  def module_to_path(module_name)
    return module_name if File.file?(module_name)
    module_name = module_name.gsub(/\./, '/')
    module_name += '.d'
    module_name
  end

  def is_file?(module_name)
    return true if module_name.empty?
    module_name.end_with?('.d') || module_name.end_with?('.di')
  end

  def actual_path_name(path)
    prefix = ''

    2.times do
      begin
        file = Pathname.new(prefix + path).realpath.to_s
        url = File.executable?(file) ? '' : '&amp;url=file://' + file
        display_name = File.basename(file)
        return file, url, display_name
      rescue Errno::ENOENT
        # Hmm lets try to prefix with project directory
        prefix = "#{ENV['TM_PROJECT_DIRECTORY']}/"
      end
    end

    [path, '', path]
  end
end
