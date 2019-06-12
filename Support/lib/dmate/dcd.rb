require 'digest'
require 'tmpdir'

module DMate
  module Dcd
    private

    def session
      @session ||= TextMate::TextMateSession.current
    end

    def socket_path
      @socket_path ||= begin
        name = Digest::SHA1.hexdigest(session.env.project_directory) + '.sock'
        File.join(Dir.tmpdir, name)
      end
    end
  end
end
