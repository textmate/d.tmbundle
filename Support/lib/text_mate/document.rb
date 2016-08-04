module TextMate
  class Document
    def lines
      @lines ||= $stdin.readlines
    end

    def content
      @content ||= lines.join('')
    end
  end
end
