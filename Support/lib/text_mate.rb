require File.expand_path('text_mate/text_mate', File.dirname(__FILE__))

TextMate.require_support 'lib/exit_codes'

TextMate.require_bundle 'lib/text_mate/core_ext/capture3'
TextMate.require_bundle 'lib/text_mate/text_mate_session'
TextMate.require_bundle 'lib/text_mate/dialog'
TextMate.require_bundle 'lib/text_mate/document'
