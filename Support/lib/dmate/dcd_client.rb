TextMate.require_bundle 'lib/dmate/path'

module DMate
  class DcdClient
    def exists?
      @exists ||= begin
        session.env.dcd_client || Path.executable_exists?('dcd-client')
      end
    end

    def execute(*args)
      args = [executable] + args
      Open3.capture3(*args)
    end

    private

    def executable
      @dcd_client ||= session.env.dcd_client || 'dcd-client'
    end

    def session
      @session ||= TextMate::TextMateSession.current
    end
  end
end
