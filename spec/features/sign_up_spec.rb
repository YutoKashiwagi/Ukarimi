require 'rails_helper'

RSpec.feature "SignUps", type: :feature do
  it '正常にサインアップできること' do
    visit new_user_registration_paht
    fill_in 'Name', with: 'foobar'
    fill_in 'Email', with: 'foobar@foobar.com'
    fill_in 'Password', with: 'foobar'
    fill_in 'Password confirmation', with: 'foobar'
    click_button 'Sign up'
    expect(page).to have_content 'foobar'
  end
end
