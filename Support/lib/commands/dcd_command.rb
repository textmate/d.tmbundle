TextMate.require_bundle 'lib/dmate/dcd_client'

class DcdCommand
  include DMate

  attr_reader :session
  attr_reader :dcd_client

  def initialize
    @session = TextMate::TextMateSession.current
    @dcd_client = DcdClient.new
  end

  def dcd_args
    raise NotImplementedError, "Abstract method 'dcd_args' not implemented"
  end

  def run
    enforce_dcd_client
    enforce_current_word
    # this elaborate way to call `capture3` is to make it compatible with
    # both Ruby 1.8 and later. In Ruby 1.8 it's not possible to have any
    # arguments after a splat (*).
    args = dcd_args + [{ :stdin_data => session.document.content }]
    stdout, stderr = dcd_client.execute(*args)
    enforce(stderr)
    stdout
  end

  private

  def enforce(error_message)
    TextMate.exit_show_tool_tip(error_message) unless error_message.empty?
  end

  def enforce_dcd_client
    unless dcd_client.exists?
      TextMate.exit_show_tool_tip('Failed to find the DCD client')
    end
  end

  def enforce_current_word
    if session.env.current_word.to_s.empty?
      TextMate.exit_show_tool_tip('No symbol selected')
    end
  end

  def exit_no_result
    current_word = session.env.current_word
    message = "No matching definition found for '#{current_word}'"
    TextMate.exit_show_tool_tip(message)
  end
end
