require_relative 'script_helper'

class RunSingleScript
  include ScriptHelper

  def run_project
    run_single_file
  end
end

RunSingleScript.new.run
