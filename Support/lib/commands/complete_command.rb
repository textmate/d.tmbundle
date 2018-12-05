TextMate.require_support 'lib/ui'
TextMate.require_support 'lib/exit_codes'

TextMate.require_bundle 'lib/commands/dcd_command'

class CompleteCommand < DcdCommand
  BUNDLE_IDENTIFIER = 'com.github.textmate.d'

  ICON_MAP = {
    'l' => 'alias',
    'a' => 'array',
    'A' => 'associative_array',
    'c' => 'class',
    'e' => 'enum_member',
    'g' => 'enum',
    'f' => 'function',
    'i' => 'interface',
    'k' => 'keyword',
    'T' => 'mixin_template',
    'M' => 'module',
    'P' => 'package',
    's' => 'struct',
    't' => 'template',
    'u' => 'union',
    'v' => 'variable_name',
    'm' => 'variable'
  }.freeze

  def initialize
    super
    TextMate::TextMateSession.current.document.content
    register_icons
  end

  def dcd_args
    ['--extended', '-c', session.cursor.to_s]
  end

  def run
    result = parse_completion_result(super)
    TextMate::UI.complete(result, :extra_chars => '_', :case_insensitive => true)
  end

  def register_icons
    support_path = session.bundle_support_path
    icons_directory = File.join(support_path, 'res/completion_icons')

    icons = ICON_MAP.values.map do |e|
      [icon_name(e), "#{icons_directory}/#{e}.pdf"]
    end

    icons = Hash[icons]
    session.dialog.register_images(icons)
  end

  private

  def parse_completion_result(result)
    completions = result.split("\n")
    return no_completions if completions.empty?
    return show_calltip(completions[1 .. -1]) if calltip?(completions)
    extract_completions(completions)
  end

  def no_completions
    TextMate.exit_show_tool_tip('No completions found')
  end

  def extract_completions(completions)
    completions[1 .. -1].map do |line|
      columns = line.split("\t")
      icon = map_icon(columns[1])
      {
        'match' => columns.first,
        'display' => display(columns),
        'image' => icon,
        'tooltip' => columns[4] || ''
      }
    end
  end

  def calltip?(completions)
    completions.first == "calltips"
  end

  def show_calltip(calltips)
    calltips = calltips.map do |line|
      line.split("\t").reject { |e| e.empty? }[1]
    end.join("\n")

    TextMate.exit_show_tool_tip(calltips)
  end

  def map_icon(symbol_type)
    key = ICON_MAP[symbol_type]
    raise "No icon mapping for '#{symbol_type}'" if key.nil?
    icon_name(key)
  end

  def icon_name(name)
    BUNDLE_IDENTIFIER + '-' + name
  end

  def display(columns)
    display = columns[2] || columns.first
    display.empty? ? columns.first : display
  end
end
