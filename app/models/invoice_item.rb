class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def best_discount
    bulk_discounts.where('? >= threshold', quantity)
                  .order(percentage: :desc)
                  .first
  end

  def total_cost_per_item
    quantity * unit_price
  end

  def discount_savings
    (total_cost_per_item * best_discount.percentage.to_f/100)
  end

  def total_cost_with_discount
    total_cost_per_item - discount_savings
  end

  def revised_cost_with_discount
    if best_discount.nil?
      total_cost_per_item
    else
      total_cost_with_discount
    end
  end
end
