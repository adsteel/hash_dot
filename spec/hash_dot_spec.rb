require "spec_helper"
require "shared_behavior/an_object_spec"

describe "Hash dot syntax" do
  context "given default universal hash-dot syntax" do
    it "does not allow dot syntax for hashes" do
      expect { { name: "Mary" }.name }.to raise_error( NoMethodError )
    end
  end

  context "given universal hash-dot syntax" do
    it_behaves_like "an object", -> { Hash.use_dot_syntax = true }
  end

  context "when using #to_dot" do
    it "allows dot access for a specific instance" do
      one = { a: 1 }.to_dot
      two = { a: 2 }

      expect( one.a ).to eq( 1 )
      expect { two.a }.to raise_error( NoMethodError )
    end
    
    it "says it responds to messages for a specific instance" do
      one = { a: 1 }.to_dot
      two = { a: 2 }

      expect( one.respond_to?(:a) ).to be_truthy
      expect( one.respond_to?(:b) ).to be_falsey
      expect( two.respond_to?(:a) ).to be_falsey
    end
    

    it_behaves_like "an object", -> { { action: :to_dot } }
  end
end
