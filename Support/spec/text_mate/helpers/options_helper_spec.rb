require "spec_helper"
require "text_mate/helpers/options_helper.rb"

describe TextMate::Helpers::OptionsHelper do
  class Mock
    include ::TextMate::Helpers::OptionsHelper
  end

  before :all do
    @helper = Mock.new
  end

  def helper
    @helper
  end

  let(:options) { { :class => "foo", :id => "bar" } }
  let(:result) { options.dup }

  describe "append_class!" do
    context "when a class exists" do
      it "appends the given classes existing class key" do
        result[:class] << " bar"
        helper.append_class!(options, "bar").should == result
      end

      context "when multiple classes are appended" do
        it "appends all the given classes" do
          result[:class] << " bar baz"
          helper.append_class!(options, "bar", :baz).should == result
        end
      end

      context "when a string is used as the class key" do
        let(:options) { { "class" => "foo", :id => "bar" } }

        it "appends the given classes existing class key" do
          result["class"] << " bar"
          helper.append_class!(options, "bar").should == result
        end
      end
    end

    context "when no class exists" do
      it "creates a new class key with the given classes" do
        options.delete(:class)
        result[:class] = "bar"
        helper.append_class!(options, "bar").should == result
      end
    end
  end

  describe "tag_options" do
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
end