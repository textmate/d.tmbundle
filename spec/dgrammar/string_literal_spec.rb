require 'spec_helper'

describe 'string literal' do
  subject { code_to_file(code) }

  describe '" bar("' do
    let(:code) { '" bar("' }
    it { should_not be_parsed_as('meta.definition.method.d') }
  end

  describe 'writeln("foo bar()");' do
    let(:code) { 'writeln("foo bar()");' }
    it { should_not be_parsed_as('meta.definition.method.d') }
  end
end
