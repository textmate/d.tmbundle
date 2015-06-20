RSpec::Matchers.define :be_parsed_as do |scope|
  match do |temp_file|
    lines = gtm(temp_file.path).split("\n")
    filterd = lines.reject { |e| lines_to_filter.include?(e) }
    filterd.first =~ /#{Regexp.escape(scope)}/
  end

  failure_message do |temp_file|
    "expected '#{code(temp_file)}' to be parsed as scope #{scope}"
  end

  failure_message_when_negated do |temp_file|
    "expected '#{code(temp_file)}' not to be parsed as scope #{scope}"
  end

  private

  def gtm(path)
    `gtm < "#{path}" Syntaxes/D.tmLanguage 2>&1`
  end

  def code(temp_file)
    File.read(temp_file.path)
  end

  def lines_to_filter
    [
      'grammar_for_scope: unable to find a grammar for ‘text.html.javadoc’',
      '*** couldn’t resolve text.html.javadoc',
      '*** couldn’t resolve #regular_expressions',
      'failed to resolve text.html.javadoc'
    ].freeze
  end
end
