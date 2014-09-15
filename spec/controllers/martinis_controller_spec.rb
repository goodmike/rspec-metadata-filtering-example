require 'rails_helper'

RSpec.describe MartinisController, :type => :controller do

    let(:proof_value) { nil }

    context "Testing for inclusion of spec helper module through metadata matching",
        prove_it: "proc" do

        it "should extend example group with helper methods" do
            expect(self.class).to respond_to(:proc_extended_helper_method)
            expect(self.class.proc_extended_helper_method).to be_present
        end

        it "should let a proof value that will be available in examples" do
            expect(proof_value).to be_present
        end

    end

    context "Testing for behavior of spec helper module when NOT all metadata filters match" do

        it "should NOT let a proof value that will be available in examples" do
            expect(proof_value).to be_nil
        end
    end
end
