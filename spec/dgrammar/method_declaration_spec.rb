require 'spec_helper'

describe 'method declaration' do
  subject { code_to_file(code) }

  describe 'void foo() {}' do
    let(:code) { 'void foo() {}' }
    it { should be_parsed_as('meta.definition.method.d') }
  end
end
