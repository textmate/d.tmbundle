TextMate.require_bundle 'lib/dmate/compiler'
TextMate.require_bundle 'lib/dmate/dub_project'
TextMate.require_bundle 'lib/dmate/dcd_server'
TextMate.require_bundle 'lib/commands/dcd_command'

class StartDcdServer < DcdCommand
  include DMate

  attr_reader :dcd_server
  attr_reader :dub_project

  def initialize
    super
    @dub_project = DubProject.new
    @dcd_server = DcdServer.new(dcd_client)
  end

  def run
    return unless dcd_server.exists?
    return if dcd_server.running?
    dcd_server.start(import_paths)
  end

  def import_paths
    @import_paths ||= default_import_paths + dub_import_paths
  end

  def default_import_paths
    @default_import_paths ||= Compiler.dmd.import_paths
  end

  def dub_import_paths
    @dub_import_paths ||= dub_project.exists? ? dub_project.import_paths : []
  end
end
