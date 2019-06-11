TextMate.require_bundle 'lib/dmate/compiler'
TextMate.require_bundle 'lib/dmate/dub_project'

module DMate
  class DubProject
    def exists?
      @exists ||= !dub_configuration_path.nil?
    end

    def import_paths
      @import_paths ||= begin
        args = [
          dub,
          'describe',
          '--import-paths',
          '--compiler', Compiler.dmd.executable,
          '--root', session.env.project_directory
        ]

        if has_dub?
          stdout, _, status = Open3.capture3(*args)
          status.success? ? extract_import_paths(stdout) : []
        else
          []
        end
      end
    end

    private

    def dub_configuration_path
      @dub_configuration_path ||=
        possible_dub_configuration_paths.find { |path| File.exist?(path) }
    end

    def possible_dub_configuration_paths
      @possible_dub_configuration_paths ||= [
        File.join(session.env.project_directory, "dub.sdl"),
        File.join(session.env.project_directory, "dub.json"),
      ]
    end

    def has_dub?
      @has_dub ||= session.env.dub || Path.executable_exists?('dub')
    end

    def dub
      @dub ||= session.env.dub || 'dub'
    end

    def session
      @session ||= TextMate::TextMateSession.current
    end

    def extract_import_paths(stdout)
      stdout.split("\n").select { |line| line.start_with?('/') }
    end
  end
end
