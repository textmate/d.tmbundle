require 'spec_helper'

describe 'condtional' do
  subject { code_to_file(code) }

  describe '"if" inside symbol' do
    let(:code) { 'uniform' }
    it { should_not be_parsed_as('keyword.control.conditional.d') }
  end
end
