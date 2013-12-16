require "spec_helper"
require "text_mate/helpers/tag_helper.rb"

describe TextMate::Helpers::TagHelper do
  class Mock
    include ::TextMate::Helpers::TagHelper
  end

  before :all do
    @helper = Mock.new
  end

  def helper
    @helper
  end

  describe "tag_options" do
    let(:options) { { :class => "foo", :id => "bar" } }

    it "converts Ruby hashes to HTML attributes" do
      helper.tag_options(options).should == 'class="foo" id="bar"'
    end

    context "when the key or value contains HTML" do
      let(:options) { { :class => "<asd>foo", "<asd>id" => "bar" } }

      it "escapes the HTML" do
        helper.tag_options(options).should == 'class="&lt;asd&gt;foo" &lt;asd&gt;id="bar"'
      end
    end
  end

  describe "content_tag" do
    context "when no content is given" do
      it "creates an HTML start and end tag with the given name" do
        helper.content_tag(:div).should == "<div></div>"
      end
    end

    context "when content is given" do
      it "creates an HTML tag with the given name and content" do
        helper.content_tag(:div, "foo").should == "<div>foo</div>"
      end
    end

    context "when the content contains HTML" do
      it "escapes the HTML content" do
        helper.content_tag(:div, "<bar>foo").should == "<div>&lt;bar&gt;foo</div>"
      end
    end

    context "when a option hash is passed" do
      it "creates an HTML tag with attributes" do
        helper.content_tag(:div, "foo", :class => "bar", :id => "primary").should == '<div class="bar" id="primary">foo</div>'
      end
    end

    context "when a block is given" do
      it "creates an HTML tag with the given name and content" do
        helper.content_tag(:div){ "foo" }.should == "<div>foo</div>"
      end
    end
  end

  describe "tag" do
    it "create an HTML start tag with the given name" do
      helper.tag(:div).should == "<div>"
    end

    context "end tag" do
      it "create an HTML end tag with the given name" do
        helper.tag(:div, :end_tag => true).should == "</div>"
      end
    end

    context "self closing tag" do
      it "create an HTML self closing end tag with the given name" do
        helper.tag(:div, :self_closing => true).should == "<div />"
      end
    end

    context "with options" do
      let(:options) do
        { :options => { :class => "bar" } }
      end

      it "create an HTML start tag with the given name and attributes" do
        helper.tag(:div, options).should == '<div class="bar">'
      end

      context "and with end tag" do
        it "create an HTML end tag with the given name WITHOUT attributes" do
          helper.tag(:div, options.merge(:end_tag => true)).should == '</div>'
        end
      end

      context "and with self closing tag" do
        it "create an HTML end tag with the given name WITHOUT attributes" do
          helper.tag(:div, options.merge(:self_closing => true)).should == '<div />'
        end
      end
    end
  end
end