require "spec_helper"
require "shared_behavior/an_object_spec"
require "shared_behavior/nomethoderror_spec"
require "shared_behavior/use_default_spec"

describe "Hash dot syntax" do
  context "given default universal hash-dot syntax" do
    it "does not allow dot syntax for hashes" do
      expect { { name: "Mary" }.name }.to raise_error( NoMethodError )
    end
  end

  context "given universal hash-dot syntax" do
    it_behaves_like "an object", -> { Hash.use_dot_syntax = true }
    it_behaves_like "an object raising NoMethodError", -> { Hash.use_dot_syntax = true }

    context "when respecting defaults" do
      it_behaves_like "an object", -> {
        Hash.use_dot_syntax = true
        Hash.hash_dot_use_default = true
      }
      it_behaves_like "an object that respects Hash#default", -> {
        Hash.use_dot_syntax = true
        Hash.hash_dot_use_default = true
      }
    end
  end

  context "when using #to_dot" do
    it "allows dot access for a specific instance" do
      one = { a: 1 }.to_dot
      two = { a: 2 }

      expect( one.a ).to eq( 1 )
      expect { two.a }.to raise_error( NoMethodError )
    end

    it "allows dot send access for a nested instance" do
      one = { a: { b: 1 } }.to_dot

      expect( one.send('a.b') ).to eq( 1 )
    end

    it "allows dot set for a specific instance" do
      one = { a: 1 }.to_dot
      one.b = 2

      expect( one.a ).to eq( 1 )
      expect( one.b ).to eq( 2 )
    end

    it "allows dot send set for a nested instance" do
      one = { a: { b: nil } }.to_dot
      one.send("a.b=", 1)

      expect( one.send("a.b") ).to eq( 1 )
      expect( one.a.b ).to eq( 1 )
    end

    it "recognizes keys as methods via #respond_to?" do
      one = { a: 1 }.to_dot
      two = { a: 2 }

      expect( one.respond_to?(:a) ).to be_truthy
      expect( one.respond_to?(:b) ).to be_falsey
      expect( two.respond_to?(:a) ).to be_falsey
    end

    it_behaves_like "an object", -> { { action: :to_dot } }
    it_behaves_like "an object raising NoMethodError", -> { { action: :to_dot } }

    context "when respecting defaults" do
      it_behaves_like "an object", -> { { action: :to_dot, args: {use_default: true} } }
      it_behaves_like "an object that respects Hash#default", -> { { action: :to_dot, args: {use_default: true} } }

      it "uses the hash default for unknown methods" do
        one = { }.to_dot(use_default: true)
        two = { }.to_dot
        three = Hash.new('hi').to_dot(use_default: true)

        expect( one.a ).to eq( nil )
        expect { two.a }.to raise_error( NoMethodError )
        expect( three.a ).to be == 'hi'
      end
    end
  end
end
