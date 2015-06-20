module DMate
  module Support
    module CodeToFile
      def code_to_file(code)
        file = Tempfile.new('foo')
        TempFiles.files << file
        file.write(code)
        file
      ensure
        file.close
      end
    end
  end
end
