require 'spec_helper'

describe RemarksController do
  let(:inspection) { create(:inspection) }

  describe "guest access" do
    describe "GET #index" do
      it "requires login"
    end
    describe "POST #create" do
      it "requires login"
    end
    describe "DELETE #destoy" do
      it "requires login"
    end
  end

  describe "authenticated access" do
    context "correct inspection" do
      describe "GET #index" do
        it "shows all remarks for the inspection"
      end

      describe "POST #create" do

        describe "author role" do
          it "does not create a remark"
        end

        describe "moderator" do
          it "creates a remark"
        end

        describe "admin" do
          it "creates remark"
        end

        describe "supervisor" do
          it "creates remark"
        end

        describe "inspector" do
          it "creates remark"
        end
      end

      describe "DELETE #destroy" do

        describe "admin" do
          it "destroys remark"
          #expect { delete: destroy, id: @remark }.to change(Remark, :count).by(-1)
        end

        describe "supervisor" do
          it "destroys remark"
        end

        describe "moderator" do
          it "destroys remark"
        end

        describe "inspector" do
          context "owner" do
            it "destroy remark"
          end
          context "not owner" do
            it "does not destroy remark"
          end
        end

        describe "author" do
          it "does not destroy remark"
        end
      end
    end

    context "incorrect inspection" do

      describe "GET #index" do
        it "does not show anything or shows an error"
      end

      describe "POST #create" do
          it "does not create a message, shows nothing or an error"
      end

      describe "DELETE #destroy" do
        it "does not create a message, shows nothing or an error"
      end
    end
  end
end


