class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices
  has_many :customers, through: :invoices

  def revenue
    invoice_items
      .merge(InvoiceItem.success)
      .sum('quantity * unit_price')
  end

  def date_revenue(date)
    invoice_items
      .merge(InvoiceItem.success)
      .merge(Invoice.select_date(date))
      .sum('quantity * unit_price')
  end

  def self.most_revenue(quantity)
    joins(:invoice_items)
      .merge(InvoiceItem.success)
      .group(:id)
      .order('sum(invoice_items.quantity * invoice_items.unit_price) DESC')
      .limit(quantity)
  end

  def self.revenue_by_date(date)
    joins(:invoice_items)
      .merge(Invoice.select_date(date))
      .merge(InvoiceItem.success)
      .sum('quantity * unit_price')
  end

  def self.most_items(quantity)
    joins(:invoice_items)
      .merge(InvoiceItem.success)
      .group(:id)
      .order('sum(invoice_items.quantity) DESC')
      .limit(quantity)
  end

  def self.favorite_customer(id)
    Merchant.find(id.to_i).customers.joins(:transactions)
    .merge(Transaction.success)
    .group("customers.id")
    .order("count(transactions.result) DESC")
    .take
  end

end
