TextMate.require_bundle 'lib/dmate/dcd'
TextMate.require_bundle 'lib/dmate/path'

module DMate
  class DcdClient
    include Dcd

    def exists?
      @exists ||= begin
        session.env.dcd_client || Path.executable_exists?('dcd-client')
      end
    end

    def execute(*args)
      args = [executable, '--socketFile', socket_path] + args
      Open3.capture3(*args)
    end

    private

    def executable
      @dcd_client ||= session.env.dcd_client || 'dcd-client'
    end
  end
end
