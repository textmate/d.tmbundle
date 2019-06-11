module DMate
  class DcdServer
    def initialize(client)
      @client = client
    end

    def running?
      @running ||= begin
        _, _, status = client.execute('--status')
        status.success?
      end
    end

    def exists?
      @exists ||= begin
        session.env.dcd_server || Path.executable_exists?('dcd-server')
      end
    end

    def start(import_paths = [])
      cmd = [executable] + import_paths.flat_map { |e| ['-I', e] }
      TextMate::Process.detach { exec(*cmd) }
    end

    private

    attr_reader :client

    def executable
      @dcd_server ||= session.env.dcd_server || 'dcd-server'
    end

    def session
      @session ||= TextMate::TextMateSession.current
    end
  end
end
