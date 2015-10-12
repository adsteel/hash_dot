require 'spec_helper'
require 'shared_behavior/an_object_spec'

describe 'Hash dot syntax' do
  context 'given default universal hash-dot syntax' do
    it 'does not allow dot syntax for hashes' do
      expect{ {name: 'Mary'}.name }.to raise_error( NoMethodError )
    end
  end

  context 'given universal hash-dot syntax' do
    it_behaves_like 'an object', -> { HashDot.universal_dot_syntax = true }
  end
end
