require 'rails_helper'

RSpec.describe 'merchant bulk discounts new', type: :feature do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
  end

  it 'shows the new bulk discount form' do 
    visit new_merchant_bulk_discount_path(@merchant1)
    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
    fill_in(:percentage, with: 20)
    fill_in(:threshold, with: 5)
    click_button 'Create'
    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
    expect(page).to have_content(20)
    expect(page).to have_content(5)
  end
end