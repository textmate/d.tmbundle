#
module TextMate
  #
  module Env
    module_function

    def [](name)
      name = name.to_s
      name = "TM_#{name}" unless name.start_with?('TM_')
      ENV[name]
    end

    def method_missing(name)
      self[name.to_s.upcase]
    end

    def dialog
      ENV['DIALOG']
    end
  end

  module_function

  def env
    Env
  end

  def require_bundle(path)
    require File.join(env.bundle_support, path)
  end

  def require_support(path)
    require File.join(env.support_path, path)
  end

  def project_path
    env.project_directory
  end

  def project?
    !project_path.nil?
  end
end
