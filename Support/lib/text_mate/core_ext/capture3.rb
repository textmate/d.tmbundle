require 'open3'

unless Open3.respond_to?(:capture3)
  module Open3
    def self.capture3(stdin_data, *cmd)

      Open3.popen3(*cmd) do |i, o, e, t|
        out_reader = Thread.new { o.read }
        err_reader = Thread.new { e.read }

        begin
          i.write stdin_data
        rescue Errno::EPIPE
        end

        i.close
        [out_reader.value, err_reader.value]
      end
    end
  end
end
