require 'rails_helper'

RSpec.describe 'merchant bulk discounts index', type: :feature do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Skin Care')
    @discount1 = BulkDiscount.create!(percentage: 20, threshold: 10, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(percentage: 5, threshold: 2, merchant_id: @merchant1.id)
    @discount3 = BulkDiscount.create!(percentage: 10, threshold: 5, merchant_id: @merchant1.id)
    @discount4 = BulkDiscount.create!(percentage: 40, threshold: 12, merchant_id: @merchant2.id)

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10,
                           merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8,
                           merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5,
                           merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: 'Hair tie', description: 'This holds up your hair', unit_price: 1,
                           merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203_942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230_948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234_092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230_429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102_938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879_799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203_942, result: 1, invoice_id: @invoice_2.id)

    visit merchant_bulk_discounts_path(@merchant1)
  end

  it 'shows each of the merchants discounts' do
    within("#bulk_discount-#{@discount1.id}") do
      expect(page).to have_link(@discount1.percentage)
      expect(page).to have_content(@discount1.percentage)
      expect(page).to have_content(@discount1.threshold)
      expect(page).to_not have_content(@discount4.percentage)
      expect(page).to_not have_content(@discount4.threshold)
    end
    within("#bulk_discount-#{@discount2.id}") do
      expect(page).to have_link(@discount2.percentage)
      expect(page).to have_content(@discount2.percentage)
      expect(page).to have_content(@discount2.threshold)
      expect(page).to_not have_content(@discount4.percentage)
      expect(page).to_not have_content(@discount4.threshold)
    end
    within("#bulk_discount-#{@discount3.id}") do
      expect(page).to have_link(@discount3.percentage)
      expect(page).to have_content(@discount3.percentage)
      expect(page).to have_content(@discount3.threshold)
      expect(page).to_not have_content(@discount4.percentage)
      expect(page).to_not have_content(@discount4.threshold)
    end
  end

  it 'shows the link to create a discount' do
    expect(page).to have_content('Create New Bulk Discount')
    click_link 'Create New Bulk Discount'
    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
  end
end
