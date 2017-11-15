require "spec_helper"

shared_examples "an object" do |callback|
  let(:user) {
    {
      name: "Example Name",
      email: "example@gmail.com",
      address: address,
      phone: nil
    }
  }

  let(:address) {
    {
      street: "1234 Sesame",
      city: "New York",
      state: "NY",
      zip: "12345"
    }
  }

  let(:json_user) { JSON.parse(user.to_json) }

  before(:each) do
    result = callback.call

    if result.is_a?(Hash) && result[:action]
      user.send(result[:action], result[:args] || {})
      json_user.send(result[:action], result[:args] || {})
    end
  end

  after(:each) {
    Hash.use_dot_syntax = false
    Hash.hash_dot_use_default = false
  }

  it "allows hashes to access nested hashes" do
    expect( user.address.city ).to eq( user[:address][:city] )
  end

  it "can set hash properties" do
    user.address.city = "White Plains"
    user.name = "New Name"

    expect( user.address.city ).to eq( "White Plains" )
    expect( user.address ).to eq( address.merge(city: "White Plains"))
    expect( user.name ).to eq( "New Name" )
  end

  it "allows the dot syntax to access new properties" do
    user[:suffix] = "Esquire"

    expect( user.suffix ).to eq( "Esquire" )
  end

  it "handles JSON parsing of json strings" do
    expect( json_user.address.city ).to eq( user[:address][:city] )

    json_user.address.city = "White Plains"
    json_user.name = "New Name"

    expect( json_user.address.city ).to eq( "White Plains" )
    expect( json_user.name ).to eq( "New Name" )
  end

  it "recognizes a key with a nil value" do
    expect(user.phone).to be_nil
  end

  it "does not alter the hash structure" do
    original_user = json_user.dup
    json_user.name

    expect(json_user).to eq(original_user)
  end
end
