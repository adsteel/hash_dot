require 'spec_helper'

shared_examples 'an object' do |callback|
  let(:user) {
    {
      name: "Example Name",
      email: "example@gmail.com",
      address: address
    }
  }

  let(:address) {
    {
      street: "1234 Sesame",
      city: "New York",
      state: "NY",
      zip: '12345'
    }
  }

  let(:json_user) { JSON.parse(user.to_json) }

  before(:each) do
    result = callback.call

    if result.is_a?(Hash) && result[:action]
      user.send(result[:action])
      json_user.send(result[:action])
    end
  end

  after(:each) { Hash.use_dot_syntax = false }

  it 'allows hashes to access nested hashes' do
    expect( user.address.city ).to eq( user[:address][:city] )
  end

  it 'can set hash properties' do
    user.address.city = "White Plains"
    user.name = "New Name"

    expect( user.address.city ).to eq( "White Plains" )
    expect( user.address ).to eq( address.merge(city: 'White Plains'))
    expect( user.name ).to eq( "New Name" )
  end

  it 'allows the dot syntax to access new properties' do
    user[:suffix] = 'Esquire'

    expect( user.suffix ).to eq( 'Esquire' )
  end

  it 'raises an error if the property has been deleted' do
    user.delete(:email)

    expect{ user.email }.to raise_error( NoMethodError )
  end

  it 'handles JSON parsing of json strings' do
    expect( json_user.address.city ).to eq( user[:address][:city] )

    json_user.address.city = "White Plains"
    json_user.name = "New Name"

    expect( json_user.address.city ).to eq( "White Plains" )
    expect( json_user.name ).to eq( "New Name" )
  end

  it 'defaults to expected behavior when non existent methods are applied' do
    expect { json_user.non_existent_method }.to raise_error( NoMethodError )
    expect { user.non_existent_method }.to raise_error( NoMethodError )
  end
end
