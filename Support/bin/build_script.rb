require_relative 'script_helper'

class BuildScript
  include ScriptHelper

  def run_single_file
    super << '--build-only'
  end

  def run_shell_path
    @run_path ||= File.join(TextMate.project_path, Compiler.shell.build)
  end

  def dub_command
    Compiler.dub.build
  end
end

BuildScript.new.run
