TextMate.require_bundle 'lib/commands/dcd_command'

class GoToDefinitionCommand < DcdCommand
  def initialize
    super
    TextMate::TextMateSession.current.document.content
  end

  def dcd_args
    ['--symbolLocation', '-c', session.cursor.to_s]
  end

  def run
    result = super
    parse_result(result)
  end

  private

  def parse_result(result)
    lines = result.split("\n")

    lines.each do |line|
      if line == 'Not found' && lines.length == 1
        handle_no_result
      else
        handle_definition(line)
      end
    end
  end

  def handle_no_result
    current_word = session.env.current_word
    message = "No matching definition found for '#{current_word}'"
    TextMate.exit_show_tool_tip(message)
  end

  def handle_definition(line)
    path, cursor = line.split("\t")
    cursor = cursor.chomp.to_i

    if path == 'stdin'
      line, column = to_column_line(cursor)
      go_to_uuid(session.document.uuid, line, column)
    else
      line, column = to_column_line(cursor, path)
      go_to(path, line, column)
    end
  end

  def go_to_uuid(uuid, line, column)
    `#{session.env.mate} -u #{uuid} -l #{line}:#{column}`
  end

  def go_to(path, line, column)
    `#{session.env.mate} #{path} -l #{line}:#{column}`
  end

  # Returns the line and column for the given cursor in bytes
  def to_column_line(cursor, path = nil)
    content = path ? File.read(path) : session.document.lines.join('')
    session.to_column_line(cursor, content)
  end
end
