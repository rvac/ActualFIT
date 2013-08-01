require 'spec_helper'

describe CampaignsController do
  before :each do
    @user = create(:user)
    @user.add_role(:admin)
    @campaign = create(:campaign)
    session[:current_user] = @user
    request.cookies[:remember_token] = @user.remember_token
  end

  describe "GET 'new'" do
    it "assigns new campaigns to @campaign" do
      get :new
      expect(assigns(:campaign)).to be_a_new(Campaign)
    end

    it "renders a new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST 'create'" do
    it "to redirect to campaigns#index" do
      post :create, campaign: attributes_for(:campaign)
      expect(response).to redirect_to campaigns_path
    end
  it "to increase number of campaigns by one" do
      expect{
        post :create, campaign: attributes_for(:campaign)
      }.to change(Campaign, :count).by(1)
    end
  end
  describe "GET #index" do
    it "populates an array of campaigns" do
      #campaign = create(:campaign)
      get :index
      expect(assigns(:campaigns)).to match_array [ @campaign ]
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET 'show'" do
    it "assigns the requested campaign to @campaign" do
      #campaign = create(:campaign)
      get :show, id: @campaign.id
      expect(assigns(:campaign)).to eq @campaign
    end

    it "to render campaign#show template" do
      get :show, id: @campaign.id
      expect(response).to render_template :show
    end
  end

  #describe "GET 'archive'" do
  #  it "returns http success" do
  #    get 'archive'
  #    response.should be_success
  #  end
  #end



  describe "GET 'edit'" do
    it "returns http success" do
      get :edit, id: @campaign.id
      expect(response).to render_template :edit
    end
  end
  describe "PUT 'update'" do
    it "changes @campaign attributes" do
      put :update, id: @campaign.id, campaign: attributes_for(:campaign, name: 'NEW NAME')
      @campaign.reload
      expect(@campaign.name).to eq 'NEW NAME'
    end
    it "redirects to a campaign #show page" do
      put :update, id: @campaign, campaign: attributes_for(:campaign)
      expect(response).to redirect_to campaign_path(@campaign)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes the campaign' do
      expect{
        delete :destroy, id: @campaign.id
      }.to change(Campaign, :count).by(-1)
    end
    it 'redirects to campaigns#index' do
      delete :destroy, id: @campaign.id
      expect(response).to redirect_to campaigns_path
    end
  end

end
