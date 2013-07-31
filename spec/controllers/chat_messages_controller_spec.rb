require 'rspec'

describe ChatMessagesController do

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
    describe "GET #index" do
      context "correct inspection" do
        it "shows all chat messages for the inspection"
      end
      context "incorrect inspection" do
        it "does not show anything or shows an error"
      end
    end
    describe "POST #create" do
      context "correct inspection" do
        it "creates a message"
      end
      context "incorrect inspection" do
        it "does not create a message, shows nothing or an error"
      end
    end
    describe "DELETE #destroy" do
      context "correct inspection" do
        it "does not destroy message"
      end
      context "incorrect inspection" do
        it "does not destroy message"
      end
    end
  end

end