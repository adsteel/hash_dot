require 'spec_helper'
require 'shared_behavior/an_object_spec'

describe 'Hash dot syntax' do
  context 'given default universal hash-dot syntax' do
    it 'does not allow dot syntax for hashes' do
      expect{ {name: 'Mary'}.name }.to raise_error( NoMethodError )
    end
  end

  context 'given universal hash-dot syntax' do
    it_behaves_like 'an object', -> { Hash.use_dot_syntax = true }
  end

  context 'when using #to_dot' do
    it 'allows dot access for a specific instance' do
      one = {a: 1}.to_dot
      two = {a: 2}

      expect( one.a ).to eq( 1 )
      expect{ two.a }.to raise_error( NoMethodError )
    end

    it_behaves_like 'an object', -> { {action: :to_dot} }
  end

  context 'given a hash that has a key of value nil' do
    it 'does not delete the key from the hash' do
      numbers = { one: 1, two: 2, three: nil }.to_dot

      expect(numbers.three).to be_nil
      expect{ numbers.four }.to raise_error(NoMethodError)
    end
  end
end
