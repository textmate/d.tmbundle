module DdocMacros
  D_CODE = <<-HTML
    <div class="code-sample">
      <div class="dlang">
        <ol class="code-lines">
          <li><code class="code-voice">$0</code></li>
        </ol>
      </div>
    </div>
  HTML

  D_KEYWORD = <<-HTML
    <span class="keyword">$0</span>
  HTML

  D_COMMENT = <<-HTML
    <span class="comment">$0</span>
  HTML

  D_STRING = <<-HTML
    <span class="string_literal">$0</span>
  HTML

  DDOC = <<-HTML
    <!DOCTYPE html>
    <html>
      <head>
        <meta http-equiv="Content-type" content="text/html; charset=utf-8">
        <link rel="stylesheet" type="text/css" href="file://#{TextMate::TextMateSession.current.env.bundle_support}/res/ddoc_theme.css">
      </head>
      <body id="reference" class="ddoc">
        <div class="height-container">
          $(BODY)
        </div>
      </body>
    </html>
  HTML

  DDOC_MODULE_MEMBERS = <<-HTML
    <section class="section symbol">
      $0
    </section>
  HTML

  DDOC_SUMMARY = <<-HTML
    <div class="abstract">
      <p class="para">
        $0
      </p>
    </div>
  HTML

  DDOC_DESCRIPTION = <<-HTML
    <div class="discussion">
      <h4>Discussion</h4>
      <p class="para">
        $0
      </p>
    </div>
  HTML

  DDOC_EXAMPLES = <<-HTML
    <h4>Examples</h4>
    <section class="code-listing">
      $0
    </section>
  HTML

  DDOC_RETURNS = <<-HTML
    <div class="result-description">
      <h4>Return Value</h4>
      <p class="para">
        $0
      </p>
    </div>
  HTML

  DDOC_PARAMS = <<-HTML
    <div class="parameters">
      <h4>Parameters</h4>
      <table cellspacing="0" cellpadding="5" border="0" class="graybox">
        <tbody>
          $0
        </tbody>
      </table>
    </div>
  HTML

  DDOC_PARAM_ROW = <<-HTML
    <tr>
      $0
    </tr>
  HTML

  DDOC_PARAM_ID = <<-HTML
    <td scope="row">
      <code class="code-voice"><em class="term">$0</em></code>
    </td>
  HTML

  DDOC_PARAM_DESC = <<-HTML
    <td>
      <div class="definition">
        <p class="para">
          $0
        </p>
      </div>
    </td>
  HTML

  DDOC_SECTION = <<-HTML
    <div class="non_standard_section">
      <p class="para">
        $0
      </p>
    </div>
  HTML

  DDOC_SECTION_H = <<-HTML
    <span class="section_h">$0</span>
  HTML

  D_INLINECODE = <<-HTML
    <code class="code-voice">$0</code>
  HTML

  def standard_section(name)
    <<-HTML
      <div class="#{name.downcase.gsub(' ', '_')}">
        <h4>#{name}</h4>
        <p class="para">
          $0
        </p>
      </div>
    HTML
  end

  def ddoc_macros
    <<-DDOC
      Macros:
        EMPTY =
        COLON = :

        D_CODE = #{D_CODE}
        D_KEYWORD = #{D_KEYWORD}
        D_INLINECODE = #{D_INLINECODE}
        D_COMMENT = #{D_COMMENT}
        D_STRING = #{D_STRING}
        D_PSYMBOL = D_PSYMBOL

        DDOC = #{DDOC}
        DDOC_BLANKLINE = $(EMPTY)
        DDOC_COMMENT = <!-- $0 -->

        DDOC_MODULE_MEMBERS = #{DDOC_MODULE_MEMBERS}
        DDOC_DECL = $(EMPTY)
        DDOC_DECL_DD = $0
        DDOC_SECTIONS = $0
        DDOC_SUMMARY = #{DDOC_SUMMARY}
        DDOC_DESCRIPTION = #{DDOC_DESCRIPTION}
        DDOC_EXAMPLES = #{DDOC_EXAMPLES}
        DDOC_RETURNS = #{DDOC_RETURNS}
        DDOC_PARAMS = #{DDOC_PARAMS}
        DDOC_PARAM_ROW = #{DDOC_PARAM_ROW}
        DDOC_PARAM_ID = #{DDOC_PARAM_ID}
        DDOC_PARAM_DESC = #{DDOC_PARAM_DESC}
        DDOC_LICENSE = #{standard_section('License')}
        DDOC_AUTHORS = #{standard_section('Authors')}
        DDOC_BUGS = #{standard_section('Bugs')}
        DDOC_COPYRIGHT = #{standard_section('Copyright')}
        DDOC_DATE = #{standard_section('Date')}
        DDOC_DEPRECATED = #{standard_section('Deprecated')}
        DDOC_HISTORY = #{standard_section('History')}
        DDOC_SEE_ALSO = #{standard_section('See Also')}
        DDOC_STANDARDS = #{standard_section('Standards')}
        DDOC_THROWS = #{standard_section('Throws')}
        DDOC_VERSION = #{standard_section('Version')}
        DDOC_SECTION = #{DDOC_SECTION}
        DDOC_SECTION_H = #{DDOC_SECTION_H}

        DDOC_PSYMBOL = DDOC_PSYMBOL
        DDOC_BACKQUOTED = $(D_INLINECODE $0)

        DDOC_DITTO = DDOC_DITTO

        DDOC_MEMBERS = DDOC_MEMBERS
        DDOC_CLASS_MEMBERS = DDOC_CLASS_MEMBERS
        DDOC_STRUCT_MEMBERS = DDOC_STRUCT_MEMBERS
        DDOC_ENUM_MEMBERS = DDOC_ENUM_MEMBERS
        DDOC_TEMPLATE_MEMBERS = DDOC_TEMPLATE_MEMBERS
        DDOC_ENUM_BASETYPE = DDOC_ENUM_BASETYPE
        DDOC_ANCHOR = DDOC_ANCHOR
        DDOC_PSUPER_SYMBOL = DDOC_PSUPER_SYMBOL
        DDOC_KEYWORD = DDOC_KEYWORD
        DDOC_PARAM = DDOC_PARAM
    DDOC
  end
end
