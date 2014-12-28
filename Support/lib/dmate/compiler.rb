module DMate
  #
  module Compiler
    module_function

    def self.cached_tm_env(symbol, default_value = symbol)
      instance_name = :"@#{symbol}"

      self.class.send(:define_method, symbol) do
        value = instance_variable_get(instance_name)
        return value if value

        value = TextMate.env[symbol.to_s.upcase] || default_value.to_s
        instance_variable_set(instance_name, value)
        value
      end
    end

    cached_tm_env(:dmd, 'dmd')
    cached_tm_env(:rdmd)
    cached_tm_env(:dub)

    def run_shell
      'run.sh'
    end

    def version(compiler)
      `#{compiler} | head -n 1`
    end
  end
end
