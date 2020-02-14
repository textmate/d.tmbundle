require 'English'
require 'tempfile'

TextMate.require_bundle 'lib/commands/dcd_command'
TextMate.require_bundle 'lib/commands/ddoc_macros'
TextMate.require_bundle 'lib/dmate/compiler'

class DocummentationCommand < DcdCommand
  include DdocMacros
  include DMate

  def initialize
    super
    TextMate::TextMateSession.current.document.content
  end

  def dcd_args
    ['--doc', '-c', session.cursor.to_s]
  end

  def run
    result = super
    parse_result(result)
  end

  private

  def parse_result(result)
    lines = result.split("\n")
    exit_no_result if lines.empty?
    lines.each { |line| handle_doc_line(line) }
  end

  def handle_doc_line(documentation)
    documentation.gsub!('\n', "\n")
    documentation = append_template(documentation)
    puts generate_ddoc(documentation)
  end

  def append_template(documentation)
    ddoc_components = [
      "module foo;\n/**",
      documentation,
      ddoc_macros,
      "*/\nvoid foo();"
    ]

    ddoc_components.join("\n")
  end

  def generate_ddoc(documentation)
    Dir.mktmpdir do |dir|
      ddoc_file, output_file = build_ddoc_filenames(dir)
      File.write(ddoc_file, documentation)
      execute_ddoc_command(dir, ddoc_file, output_file)
      File.read(output_file)
    end
  end

  def execute_ddoc_command(dir, ddoc_file, output_file)
    result = Dir.chdir(dir) do
      `#{Compiler.dmd} -D -c -o- #{ddoc_file} -of#{output_file} 2>&1`
    end

    enforce(result)
  end

  def build_ddoc_filenames(dir)
    uuid = session.document.uuid
    filename = File.join(dir, uuid)
    ddoc_file = filename + '.d'
    output_file = filename + '.html'
    [ddoc_file, output_file]
  end
end
