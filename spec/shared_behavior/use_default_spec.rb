# frozen_string_literal: true

require "spec_helper"

shared_examples "an object that respects Hash#default" do |callback|
  let(:user) {
    {
      name: "Example Name",
      email: "example@gmail.com",
      address: address,
      alt_emails: [
        { type: "main", email: "foo@example.com" },
        { type: "tech", email: "bar@example.com" }
      ],
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
    json_user.default = "hello!"
  end

  after(:each) {
    Hash.use_dot_syntax = false
    Hash.hash_dot_use_default = false
  }

  it "uses the hash default for unknown methods" do
    expect( user.a ).to eq( nil )
    expect( json_user.a ).to eq( "hello!" )
  end

  it "uses the default across array boundaries" do
    expect( user.alt_emails.first.foo ).to be_nil
  end
end
