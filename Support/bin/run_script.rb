require_relative 'script_helper'

class RunScript
  include ScriptHelper

  def run_shell_path
    @run_path ||= File.join(TextMate.project_path, Compiler.shell.run)
  end

  def dub_command
    Compiler.dub.run
  end
end

RunScript.new.run
