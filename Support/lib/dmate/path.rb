module DMate
  # Helper for manipulating the PATH environment variable
  module Path
    module_function

    # @return `true` if the given filename exists in the PATH environment
    #   variable and is executable
    def executable_exists?(filename)
      ENV['PATH'].
        split(File::PATH_SEPARATOR).
        map { |path| File.join(path, filename) }.
        any? { |e| File.executable?(e) }
    end
  end
end
