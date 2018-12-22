module TextMate
  module Process
    module_function

    def detach(&block)
      pid = fork do
        STDOUT.reopen(open('/dev/null', 'w'))
        STDERR.reopen(open('/dev/null', 'w'))

        begin
          block.call
        rescue SystemExit => e
          # not sure why this is an exception!?!
        end
      end

      ::Process.detach(pid)
    end
  end
end
