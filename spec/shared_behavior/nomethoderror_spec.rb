# frozen_string_literal: true

require "spec_helper"

shared_examples "an object raising NoMethodError" do |callback|
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

  it "raises an error if the property has been deleted" do
    user.delete(:email)
    expect { user.email }.to raise_error(NoMethodError)
  end

  it "defaults to expected behavior when non existent methods are applied" do
    expect { json_user.non_existent_method }.to raise_error( NoMethodError )
    expect { user.non_existent_method }.to raise_error( NoMethodError )
  end
end
