module TextMate
  class Document
    attr_reader :env

    def initialize(env)
      @env = env
    end

    def lines
      @lines ||= $stdin.readlines
    end

    def content
      @content ||= lines.join('')
    end

    def uuid
      env.document_uuid
    end
  end
end
