module DdocMacros
  def ddoc_macros
    res_directory = File.join(
      TextMate::TextMateSession.current.env.bundle_support, 'res'
    )

    ddoc_path = File.join(res_directory, 'ddoc_theme.ddoc')
    ddoc_css_path = File.join(res_directory, 'ddoc_theme.css')
    ddoc_macros = File.read(ddoc_path)

    <<-DDOC
      Macros:
        #{ddoc_macros.gsub('<%= ddoc_macros %>', 'file://' + ddoc_css_path)}
    DDOC
  end
end
