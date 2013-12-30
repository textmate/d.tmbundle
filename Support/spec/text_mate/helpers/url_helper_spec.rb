require "spec_helper"
require "text_mate/helpers/url_helper.rb"

describe TextMate::Helpers::UrlHelper do
  class Mock
    include ::TextMate::Helpers::UrlHelper
  end

  before :all do
    @helper = Mock.new
  end

  def helper
    @helper
  end

  let(:file) { "path/to/local/file" }
  let(:text) { "foo" }
  let(:line) { 30 }

  describe "link_to_error" do
    it "creates an error link to a local file using the txmt:// protocol" do
      content = "<span class=\"err\">#{text}(#{line})</span>"
      result = "<a href=\"txmt://open?url=file://#{file}&line=#{line}\">#{content}</a>"
      helper.link_to_error(text, file, line).should == result
    end
  end

  describe "link_to_txmt" do
    it "creates an HTML link to a local file using the txmt:// protocol" do
      result = "<a href=\"txmt://open?url=file://#{file}&line=#{line}\">#{text}</a>"
      helper.link_to_txmt(text, file, line).should == result
    end

    context "when no line is given" do
      let(:line) { nil }

      it "creates an HTML link to a local file without the line info" do
        result = "<a href=\"txmt://open?url=file://#{file}\">#{text}</a>"
        helper.link_to_txmt(text, file, line).should == result
      end
    end
  end

  describe "link_to" do
    it "creates an HTML link" do
      helper.link_to("foo", "bar").should == '<a href="bar">foo</a>'
    end

    context "when an option is passed" do
      it "creates an HTML link with attributes" do
        helper.link_to("foo", "bar", :class => "err").should == '<a href="bar" class="err">foo</a>'
      end
    end

    context "when a block is given" do
      it "creates an HTML link with the given URL and content" do
        helper.link_to("bar"){ "foo" }.should == '<a href="bar">foo</a>'
      end

      context "when an option is passed" do
        it "creates an HTML link with attributes" do
          helper.link_to("bar", :class => "err"){ "foo" }.should == '<a href="bar" class="err">foo</a>'
        end
      end
    end
  end
end