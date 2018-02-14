require_relative 'script_helper'

class TestScript
  include ScriptHelper

  def run_shell_path
    @run_path ||= File.join(TextMate.project_path, Compiler.shell.test)
  end

  def run_single_file
    compiler = Compiler.dmd

    [
      Compiler.rdmd.executable,
      '-vcolumns',
      '-unittest',
      "--compiler=#{compiler.executable}",
      TextMate.env.filepath,
      compiler.version_options
    ]
  end

  def dub_command
    Compiler.dub.test
  end
end

TestScript.new.run
