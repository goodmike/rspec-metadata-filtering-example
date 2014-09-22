require 'rails_helper'

RSpec.describe Martini, :type => :model do

    let(:proof_value) { nil }

    context "Testing for NON-inclusion of spec helper module through metadata matching",
        prove_it: "proc" do

        it "should not extend example group with helper methods" do
            expect(self.class).to_not respond_to(:proc_extended_helper_method)
        end

        it "should NOT let a proof value that will be available in examples" do
            expect(proof_value).to be_nil
        end

    end

end
