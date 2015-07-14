require 'spec_helper'
require 'text_mate/helpers/url_helper.rb'

describe TextMate::Helpers::UrlHelper do
  class Mock
    include ::TextMate::Helpers::UrlHelper
  end

  before :all do
    @helper = Mock.new
  end

  attr_reader :helper

  let(:file) { 'path/to/local/file' }
  let(:text) { 'foo' }
  let(:line) { 30 }

  describe 'link_to_error' do
    let(:message) { 'message' }
    let(:href) { "\"txmt://open?url=file://#{file}\"" }
    let(:link) { "<a href=#{href}>#{text}</a>: #{message}<br />" }
    let(:expected) { "<span class=\"err\">#{link}</span>" }

    it 'creates an error link to a local file using the txmt:// protocol' do
      helper.link_to_error(message, text, file).should == expected
    end

    context 'with line number' do
      let(:href) { "\"txmt://open?url=file://#{file}&line=#{line}\"" }
      let(:link) { "<a href=#{href}>#{text}(#{line})</a>: #{message}<br />" }

      it 'creates an error link with line number' do
        helper.link_to_error(message, text, file, line).should == expected
      end

      context 'with column' do
        let(:column) { 2 }

        let(:href) do
          "\"txmt://open?url=file://#{file}&line=#{line}&column=#{column}\""
        end

        let(:link) do
          "<a href=#{href}>#{text}(#{line},#{column})</a>: #{message}<br />"
        end

        it 'creates an error link with line and column number' do
          args = [message, text, file, line, column]
          helper.link_to_error(*args).should == expected
        end

        context 'with attributes' do
          let(:link) do
            content = "#{text}(#{line},#{column})"
            "<a href=#{href} foo=\"bar\">#{content}</a>: #{message}<br />"
          end

          it 'creates an error link with attributes' do
            args = [message, text, file, line, column, foo: 'bar']
            helper.link_to_error(*args).should == expected
          end
        end
      end

      context 'with attributes' do
        let(:link) do
          "<a href=#{href} foo=\"bar\">#{text}(#{line})</a>: #{message}<br />"
        end

        it 'creates an error link with attributes' do
          result = helper.link_to_error(message, text, file, line, foo: 'bar')
          result.should == expected
        end
      end
    end

    context 'with attributes' do
      let(:link) { "<a href=#{href} foo=\"bar\">#{text}</a>: #{message}<br />" }

      it 'creates an error link with attributes' do
        helper.link_to_error(message, text, file, foo: 'bar').should == expected
      end
    end
  end

  describe 'link_to_txmt' do
    let(:href) { "\"txmt://open?url=file://#{file}\"" }
    let(:expected) { "<a href=#{href}>#{text}</a>" }

    it 'creates an HTML link to a local file using the txmt:// protocol' do
      helper.link_to_txmt(text, file).should == expected
    end

    context 'with line number' do
      let(:href) { "\"txmt://open?url=file://#{file}&line=#{line}\"" }

      it 'creates an HTML link with line number' do
        helper.link_to_txmt(text, file, line).should == expected
      end
    end
  end

  describe 'link_to' do
    it 'creates an HTML link' do
      helper.link_to('foo', 'bar').should == '<a href="bar">foo</a>'
    end

    context 'when an option is passed' do
      it 'creates an HTML link with attributes' do
        expected = '<a href="bar" class="err">foo</a>'
        helper.link_to('foo', 'bar', class: 'err').should == expected
      end
    end

    context 'when a block is given' do
      it 'creates an HTML link with the given URL and content' do
        helper.link_to('bar') { 'foo' }.should == '<a href="bar">foo</a>'
      end

      context 'when an option is passed' do
        it 'creates an HTML link with attributes' do
          expected = '<a href="bar" class="err">foo</a>'
          helper.link_to('bar', class: 'err') { 'foo' }.should == expected
        end
      end
    end
  end
end
