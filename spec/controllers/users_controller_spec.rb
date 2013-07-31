require 'spec_helper'

describe UsersController do
  let(:user) { create(:user) }
  describe "guest access" do
    describe "GET #index" do
      it "requires login"  do
        get :index
        expect(response).to redirect_to signin_url
      end
    end
    describe "GET #new" do
      it "renders users#new" do
        get :new
        expect(response).to render_template :new
      end
    end
    describe "POST #create" do
      it "creates a new user" do
        expect{
          post :create, user: attributes_for(:user)
        }.to change(User, :count).by(1)
      end
      it "signs user in and redirect to his profile" do
        post :create, user: attributes_for(:user)
        expect(response).to redirect_to user_path(User.last)
      end
      #it "requires login to create user with admin rights" do
      #  post :create, user: attributes_for(:admin)
      #  expect(response).to redirect_to signin_url
      #end
    end
    describe "DELETE #destoy" do
      it "requires login" do
        #user = create(:user)
        delete :destroy, id: user.id
        expect(response).to redirect_to signin_url
      end
    end
    describe "PUT #update" do
      it "requires login"  do
        #user = create(:user)
        put :update, id: user.id, user: attributes_for(:user)
        expect(response).to redirect_to signin_url
      end
    end
  describe "GET #update" do
      it "requires login"  do
        #user = create(:user)
        get :edit, id: user.id
        expect(response).to redirect_to signin_url
      end
    end
  end

  describe "logged in user" do
      before :each do
        @campaign = create(:campaign_with_users)
        @inspection = @campaign.inspections[1]
        @user = @inspection.users.first
        session[:current_user] = @user
        request.cookies[:remember_token] = @user.remember_token
      end
      describe "GET #index" do
        context "current inspection is not nil;" do
          before :each do
            request.cookies[:current_inspection_id] = @inspection.id
          end
          it "shows all users for current inspection" do
            get :index
            expect(assigns(:users)).to match_array @inspection.users
          end
          it "shows render users#index template" do
            get :index
            expect(response).to render_template :index
          end
        end
        context " user has at least one inspection attached"  do
          before :each do
            request.cookies[:current_inspection_id] = nil
          end
          it "shows all users attached to first inspections in the list" do
            get :index
            expect(assigns(:users)).to match_array @campaign.inspections.first.users
          end
          it "shows all users attached to first inspections in the list" do
            get :index
            expect(response).to render_template :index
          end
        end
        context "user has no inspections attached"  do
          before :each do
            @user_no_insp = create(:user)
            session[:current_user] = @user_no_insp
            request.cookies[:remember_token] = @user_no_insp.remember_token
          end
          it "@users array is empty" do
            get :index
            expect(assigns(:users)).to match_array []
            expect(session[:current_user]).to eq @user_no_insp
          end
        end
      end

      describe "GET #edit" do
        context "current user edit his profile" do
          it "renders user#edit template" do
            get :edit, id: @user.id
            expect(response).to render_template :edit
          end
          it "instance variable is our user" do
            get :edit, id: @user.id
            expect(assigns(:user)).to eq @user
          end
        end
        context "another user tries to edit a profile" do
          context "the modificator is an admin or moderator" do
            before :each do
              @admin = create(:user)
              @admin.add_role(:admin)
              session[:current_user] = @admin
              request.cookies[:remember_token] = @admin.remember_token
            end
            it "renders user#edit template" do
              get :edit, id: @user.id
              expect(response).to render_template :edit
            end
            it "instance variable is a required user" do
              get :edit, id: @user.id
              expect(assigns(:user)).to eq @user
            end
          end
          context "the modificator is an ordinary user"  do
            before :each do
              @other_user = create(:user)
              session[:current_user] = @other_user
              request.cookies[:remember_token] = @other_user.remember_token
            end

            it "redirects to the modificators profile" do
              get :edit, id: @user.id
              expect(response).to redirect_to edit_user_path(@other_user)
              end
            it "renders user#edit template" do
              get :edit, id: @user.id
              expect(response).to render_template :edit
            end
            it "instance variable is the user itself" do
              get :edit, id: @user.id
              expect(session[:current_user]).to eq @other_user
              #should this be like this? may be it should, for security reasons
              expect(assigns(:user)).to eq @other_user
            end
          end
        end
      end
      describe "PUT #update" do
        context "current user edit his profile" do
          it "changes user attribute" do
            put :update, id: @user.id, user: attributes_for(:user, name: "new name")
            @user.reload
            expect(@user.name).to eq "new name"
          end
          it "redirects to user profile" do
            put :update, id: @user.id, user: attributes_for(:user)
            expect(response).to redirect_to user_path(@user)
          end
          it "renders user#show after submission" do
            put :update, id: @user.id, user: attributes_for(:user)
            expect(response).to render_template :show
          end
        end
        context "another user tries to edit a profile" do
          context "the modificator is an admin or moderator" do
            before :each do
              @admin = create(:user)
              @admin.add_role(:admin)
              session[:current_user] = @admin
              request.cookies[:remember_token] = @admin.remember_token
            end
            it "changes user attribute" do
              put :update, id: @user.id, user: attributes_for(:user, name: "new name")
              @user.reload
              expect(@user.name).to eq "new name"
            end
            it "redirects to a list of all users" do
              put :update, id: @user.id, user: attributes_for(:user)
              expect(response).to redirect_to users_path
            end
            it "renders users#index after submission" do
              put :update, id: @user.id, user: attributes_for(:user)
              expect(response).to render_template :index
            end
          end
          context "the modificator is an ordinary user"  do
            before :each do
              @other_user = create(:user)
              session[:current_user] = @other_user
              request.cookies[:remember_token] = @other_user.remember_token
            end

            it "redirects to the modificators profile" do
              put :update, id: @user.id, user: attributes_for(:user)
              expect(response).to redirect_to edit_user_path(@other_user)
            end
            it "renders user#edit template" do
              put :update, id: @user.id
              expect(response).to render_template :edit
              expect(assigns(:user)).to eq @other_user
            end
            it "instance variable is the user itself" do
              put :update, id: @user.id, user: attributes_for(:user)
              expect(session[:current_user]).to eq to @other_user
              #should this be like this? may be it should, for security reasons
              expect(assigns(:user)).to eq @other_user
            end
          end
        end
      end

      describe "DELETE #destroy" do
        context "modificator is" do
          describe "admin" do
            it "can destroy any ordinary user"
            it "can not destroy a privileged user"
          end
          describe "supervisor" do
            it "can destroy any ordinary user"
            it "can destroy a privileged user"
          end
          describe "ordinary user" do
            it "can not destroy any user"
          end
        end
      end
  end
end


