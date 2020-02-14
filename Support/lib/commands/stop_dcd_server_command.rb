TextMate.require_bundle 'lib/commands/dcd_command'

class StopDcdServerCommand < DcdCommand
  def run
    enforce_dcd_client
    _, stderr = dcd_client.execute('--shutdown')
    enforce(stderr)
  end
end
