require 'spec_helper'

describe InspectionsController do
  before :each do
    @user = create(:user)
    @inspection = create(:inspection)
    session[:current_user] = @user
    request.cookies[:remember_token] = @user.remember_token
  end

  describe "GET 'show'" do
    it "assigns the required inspection to @inspection" do
      get :show, id: @inspection.id
      expect(assigns(:inspection)).to eq @inspection
    end

    it "renders a the required inspection" do
      get :show, id: @inspection
      expect(response).to render_template :show
    end
  end

  describe "GET 'new'" do
    context "admin" do
      before :each do
        @user.add_role(:admin)
      end
      it "assigns new inspection to @inspection" do
        get :new
        expect(assigns(:inspection)).to be_a_new(Inspection)
      end

      it "renders a new template" do
        get :new
        expect(response).to render_template :new
      end
    end
    context "regular user" do
      it "gives an error" do
        get :new
        expect(response).not_to be_success
      end
    end
  end

  describe "POST 'create'" do
    context "admin" do
      before :each do
        @user.add_role(:admin)
      end
      it "to redirect to inspection#show" do
        post :create, inspection: attributes_for(:inspection)
        expect(response).to redirect_to inspection_path(Inspection.last)
      end
      it "to increase number of inspections by one" do
        expect{
          post :create, inspection: attributes_for(:inspection)
        }.to change(Inspection, :count).by(1)
      end
    end
    context "regular user"  do
      it "does not increase number of inspections by one" do
        expect{
          post :create, inspection: attributes_for(:inspection)
        }.not_to change(Inspection, :count).by(1)
      end
    end
  end


  describe "GET 'show'" do
    it "assigns the requested inspection to @inspection" do
      get :show, id: @inspection.id
      expect(assigns(:inspection)).to eq @inspection
    end

    it "to render inspection#show template" do
      get :show, id: @inspection.id
      expect(response).to render_template :show
    end
  end

  describe "GET 'edit'" do
    context "admin" do
      it "renders inspection#edit template" do
        @user.add_role(:admin)
        get :edit, id: @inspection
        expect(response).to render_template :edit
      end
    end
  context "regular user" do
      it "renders inspection#edit template" do
        get :edit, id: @inspection
        expect(response).not_to be_success
      end
    end
  end
  describe "PUT 'update'" do
    context "admin" do
      before :each do
        @user.add_role(:admin)
      end
      it "changes @inspection attributes" do
        put :update, id: @inspection.id, inspection: attributes_for(:inspection, name: 'NEW NAME')
        @inspection.reload
        expect(@inspection.name).to eq 'NEW NAME'
      end
      it "redirects to inspection#show page" do
        put :update, id: @inspection.id, inspection: attributes_for(:inspection)
        expect(response).to redirect_to campaign_path(@inspection)
      end
    end
    context "regular user" do
      it "gives and error" do
        put :update, id: @inspection.id, inspection: attributes_for(:inspection)
        expect(response).not_to be_success
        end
      it "does not update the inspection" do
        put :update, id: @inspection.id, inspection: attributes_for(:inspection, name: "new name")
        expect(@inspection.name).not_to eq "new name"
      end
    end
  end

  describe 'DELETE destroy' do
    context "admin" do
      before :each do
        @user.add_role(:admin)
      end
      it 'deletes the inspection' do
        expect{
          delete :destroy, id: @inspection.id
        }.to change(Inspection, :count).by(-1)
      end
      it 'redirects to inspection#index' do
        delete :destroy, id: @inspection.id
        expect(response).to redirect_to inspections_path
      end
    end
    context "regular user" do
      before :each do
        @user.add_role(:admin)
      end
      it 'does not delete the inspection' do
        expect{
          delete :destroy, id: @inspection.id
        }.not_to change(Inspection, :count).by(-1)
      end
    end
  end
  describe 'GET inspection#download_artifacts' do
    it 'saves artifacts on disk'
  end

  describe 'GET inspection#upload_remarks' do
    it 'renders upload_remarks template' do
      get :upload_remarks, id: @inspection.id
      expect(response).to render_template :show
    end
  end
  describe 'POST inspection#upload_remarks' do
     it "creates new remarks from file" do
       post :upload_remarks
       expect(response).to be_success
     end
     it 'redirects to inspection#show' do
       post :upload_remarks
       expect(response).to be_success
     end
  end

end