require 'spec_helper'

feature 'User management' do
  scenario 'user creates an account' do

    visit root_path
    expect{
      fill_in 'Name', with: 'Gustavo Sanches'
      fill_in 'Email', with: 'user@email.com'
      fill_in 'Password', with: 'password'
      fill_in 'Confirmation', with: 'password'
      click_button 'Create an account'
    }.to  change(User, :count).by(1)

    expect(page).to have_content 'Gustavo Sanches'
  end
end