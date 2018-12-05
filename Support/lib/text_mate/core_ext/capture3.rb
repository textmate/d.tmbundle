require 'open3'

unless Open3.respond_to?(:capture3)
  module Open3
    def self.capture3(*cmd)
      if cmd.last.is_a?(Hash)
        options = cmd.last
        args = cmd[0 ... -1]
      else
        options = {}
        args = cmd
      end

      Open3.popen3(*args) do |i, o, e, t|
        out_reader = Thread.new { o.read }
        err_reader = Thread.new { e.read }

        begin
          i.write options[:stdin_data]
        rescue Errno::EPIPE
        end

        i.close
        [out_reader.value, err_reader.value]
      end
    end
  end
end
