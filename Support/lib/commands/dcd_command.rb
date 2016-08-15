class DcdCommand
  attr_reader :session
  attr_reader :dcd_client

  def initialize
    @session = TextMate::TextMateSession.current
    @dcd_client = session.env.dcd_client || 'dcd-client'
  end

  def dcd_args
    raise NotImplementedError, "Abstract method 'dcd_args' not implemented"
  end

  def run
    enforce_current_word
    stdout, stderr = Open3.capture3(dcd_client, *dcd_args,
      stdin_data: session.document.content)
    enforce(stderr)
    stdout
  end

  private

  def enforce(error_message)
    TextMate.exit_show_tool_tip(error_message) unless error_message.empty?
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
