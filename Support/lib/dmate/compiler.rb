module DMate
  class Compiler < BasicObject
    class << self
      def dmd
        @dc ||= Dmd.new
      end

      def rdmd
        @rdmd ||= Rdmd.new
      end

      def dub
        @dub ||= Dub.new
      end

      def shell
        @shell ||= Shell.new
      end
    end

    def __class__
      (class << self; self end).superclass
    end

    def executable
      @executable ||= begin
        class_name = __class__.name.split('::').last
        ::TextMate.env[class_name.upcase] || class_name.downcase
      end
    end

    def method_missing(*args, &block)
      executable.send(*args, &block)
    end

    def version_options
      { version_args: '--help' }
    end

    class Dmd < Compiler
    end

    class Rdmd < Compiler
    end

    class Dub < Compiler
      def version_options
        super.merge(version_regex: /.+(DUB version.+)$/m, version_replace: '\1')
      end

      def run
        'run'
      end

      def build
        'build'
      end

      def test
        'test'
      end
    end

    class Shell < Compiler
      def run
        'run.sh'
      end

      def build
        'build.sh'
      end

      def test
        'test.sh'
      end
    end
  end
end
