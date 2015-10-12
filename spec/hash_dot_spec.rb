require 'spec_helper'

describe 'Hash dot syntax' do
  let(:user) {
    {
      name: "Example Name",
      email: "example@gmail.com",
      address: {
        street: "1234 Sesame",
        city: "New York",
        state: "NY",
        zip: '12345'
      }
    }
  }

  let(:json_user) { JSON.parse(user.to_json) }

  context 'given default universal hash-dot syntax' do
    it 'does not allow dot syntax for hashes' do
      expect{ user.name }.to raise_error( NoMethodError )
    end
  end

  context 'given universal hash-dot syntax' do
    before(:each) { HashDot.universal_dot_syntax = true }

    it 'allows hashes to access nested hashes' do
      expect( user.address.city ).to eq("New York")
    end

    it 'can set hash properties' do
      user.address.city = "White Plains"
      user.name = "New Name"

      expect( user.address.city ).to eq("White Plains")
      expect( user.name ).to eq("New Name")
    end

    it 'handles JSON parsing of json strings' do
      expect( json_user.address.city ).to eq("New York")

      json_user.address.city = "White Plains"
      json_user.name = "New Name"

      expect( json_user.address.city ).to eq("White Plains")
      expect( json_user.name ).to eq("New Name")
    end

    it 'defaults to expected behavior when non existent methods are applied' do
      expect { json_user.non_existent_method }.to raise_error(NoMethodError)
      expect { user.non_existent_method }.to raise_error(NoMethodError)
    end
  end
end
