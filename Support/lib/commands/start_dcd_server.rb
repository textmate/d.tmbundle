TextMate.require_bundle 'lib/dmate/compiler'
TextMate.require_bundle 'lib/commands/dcd_command'

class StartDcdServer < DcdCommand
  include DMate

  attr_reader :dcd_server

  def initialize
    super
    @dcd_server = session.env.dcd_server || 'dcd-server'
  end

  def run
    return unless has_server?
    return if server_running?
    start_dcd_server
  end

  def start_dcd_server
    cmd = [dcd_server] + import_paths.flat_map { |e| ['-I', e] }
    TextMate::Process.detach { exec(*cmd) }
  end

  def import_paths
    @import_paths ||= default_import_paths + dub_import_paths
  end

  def default_import_paths
    @default_import_paths ||= Compiler.dmd.import_paths
  end

  def dub_import_paths
    @dub_import_paths ||= []
  end

  def server_running?
    _, _, status = Open3.capture3(dcd_client, '--status')
    status.success?
  end

  def has_server?
    return true if session.env.dcd_server

    ENV['PATH']
      .split(File::PATH_SEPARATOR)
      .map { |path| File.join(path, 'dcd-server') }
      .any? { |e| File.executable?(e) }
  end
end
