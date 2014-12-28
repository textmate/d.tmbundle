require 'pathname'

require ENV['TM_BUNDLE_SUPPORT'] + '/lib/text_mate/text_mate'

TextMate.require_support 'lib/tm/executor'
TextMate.require_support 'lib/tm/save_current_document'

TextMate.require_bundle 'lib/dmate/compiler'
TextMate.require_bundle 'lib/dmate/error_handler'

class ScriptRunner
  include DMate

  def initialize
    @error_handler = ErrorHandler.new
  end

  def run
    restore_working_directory do
      TextMate.save_current_document
      cmd = TextMate.project? ? run_project : run_single_file
      run_command(cmd)
    end
  end

  private

  attr_reader :error_handler

  def run_single_file
    rdmd = Compiler.rdmd
    compiler = Compiler.dmd
    [rdmd, '-vcolumns', "--compiler=#{compiler}", TextMate.env.filepath]
  end

  def run_project
    if dub?
      [Compiler.dub, 'run']
    elsif run_shell?
      ['bash', run_shell_path]
    else
      run_single_file
    end
  end

  def run_command(cmd)
    TextMate::Executor.run(*cmd) do |line, type|
      error_handler.handle(line, type)
    end
  end

  def run_shell_path
    @run_path ||= File.join(TextMate.project_path, Compiler.run_shell)
  end

  def restore_working_directory(&block)
    current_dir = Dir.pwd
    block.call
  ensure
    Dir.chdir current_dir
  end

  def dub?
    path = File.join(TextMate.project_path, 'dub.json')
    File.exist?(path)
  end

  def run_shell?
    File.exist?(run_shell_path)
  end
end

ScriptRunner.new.run
