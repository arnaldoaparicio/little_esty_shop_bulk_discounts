require 'rails_helper'

RSpec.describe 'merchant bulk discounts edit page', type: :feature do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @discount1 = BulkDiscount.create!(percentage: 20, threshold: 10, merchant_id: @merchant1.id)
  end

  it 'shows the edit bulk discount form with existing info' do
    visit edit_merchant_bulk_discount_path(@merchant1, @discount1)
    expect(page).to have_field(:percentage, with: 20)
    expect(page).to have_field(:threshold, with: 10)
    click_button 'Save Changes'
    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount1))
    expect(page).to have_content(@discount1.percentage)
    expect(page).to have_content(@discount1.threshold)
  end

  it 'changes the bulk discount info' do 
    visit edit_merchant_bulk_discount_path(@merchant1, @discount1)
    fill_in :percentage, with: 9
    fill_in :threshold, with: 5
    click_button 'Save Changes'
    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount1))
    expect(page). to have_content(9)
    expect(page). to have_content(5)
  end
end
