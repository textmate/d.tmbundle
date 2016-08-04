module TextMate
  class TextMateSession
    def self.current
      @session ||= TextMateSession.new
    end

    def document
      @document ||= Document.new
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
      @cursor ||= document.lines.first(line - 1).join('').length + column
    end

    def bundle_support_path
      env.bundle_support
    end
  end
end
