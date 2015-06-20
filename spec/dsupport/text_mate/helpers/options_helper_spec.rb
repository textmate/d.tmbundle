require 'spec_helper'
require 'text_mate/helpers/options_helper.rb'

describe TextMate::Helpers::OptionsHelper do
  class Mock
    include ::TextMate::Helpers::OptionsHelper
  end

  before :all do
    @helper = Mock.new
  end

  attr_reader :helper

  let(:options) { { class: 'foo', id: 'bar' } }
  let(:result) { options.dup }

  describe 'append_class!' do
    context 'when a class exists' do
      it 'appends the given classes existing class key' do
        result[:class] << ' bar'
        helper.append_class!(options, 'bar').should == result
      end

      context 'when multiple classes are appended' do
        it 'appends all the given classes' do
          result[:class] << ' bar baz'
          helper.append_class!(options, 'bar', :baz).should == result
        end
      end

      context 'when a string is used as the class key' do
        let(:options) { { 'class' => 'foo', :id => 'bar' } }

        it 'appends the given classes existing class key' do
          result['class'] << ' bar'
          helper.append_class!(options, 'bar').should == result
        end
      end
    end

    context 'when no class exists' do
      it 'creates a new class key with the given classes' do
        options.delete(:class)
        result[:class] = 'bar'
        helper.append_class!(options, 'bar').should == result
      end
    end
  end

  describe 'tag_options' do
    it 'converts Ruby hashes to HTML attributes' do
      helper.tag_options(options).should == 'class="foo" id="bar"'
    end

    context 'when the key or value contains HTML' do
      let(:options) { { :class => '<asd>foo', '<asd>id' => 'bar' } }

      it 'escapes the HTML' do
        expected = 'class="&lt;asd&gt;foo" &lt;asd&gt;id="bar"'
        helper.tag_options(options).should == expected
      end
    end
  end

  describe 'extract_options' do
    let(:args) { [1, 2, 3, { a: 1 }] }

    def result
      helper.extract_options(*args)
    end

    it 'extracts the hash of options from an array' do
      result.should == args
    end

    context 'with no hash in the arguments' do
      let(:args) { [1, 2, nil] }

      it 'sets the last element to an empty hash' do
        result.should == [1, 2, {}]
      end
    end

    context 'when hash is not the last element' do
      let(:args) { [1, 2, { a: 3 }, nil] }

      it 'should replace the last element with the hash and set the current element to nil' do
        result.should == [1, 2, nil, { a: 3 }]
      end
    end
  end
end
