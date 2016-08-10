module TextMate
  class TextMateSession
    def self.current
      @session ||= TextMateSession.new
    end

    def document
      @document ||= Document.new(env)
    end

    def env
      Env
    end

    def dialog
      @dialog ||= Dialog.new(env)
    end

    def line
      env.line_number.to_i
    end

    def column
      env.line_index.to_i
    end

    # Returns the position of the cursor in bytes
    def cursor
      @cursor ||= document.lines.first(line - 1).join('').bytes.to_a.length + column
    end

    # Returns the line and column for the given cursor in bytes and content
    def to_column_line(cursor, content)
      content_before_cursor = content[0 .. cursor]
      lines = content_before_cursor.split("\n")
      line = lines.length
      column = lines.last.bytes.length
      [line, column]
    end

    def bundle_support_path
      env.bundle_support
    end
  end
end
