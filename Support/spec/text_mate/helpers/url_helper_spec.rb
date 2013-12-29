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