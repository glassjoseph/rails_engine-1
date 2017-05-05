require 'rails_helper'

describe 'total revenue for a merchant endpoint' do 
  let!(:merchant) {create(:merchant) }
  let!(:item_1) { create(:item, merchant: merchant) }
  let!(:item_2) { create(:item, merchant: merchant) }
  let!(:invoice_1) { create(:invoice, merchant: merchant) }
  let!(:invoice_2) { create(:invoice, merchant: merchant) }
  let!(:transaction_1) { create(:transaction, invoice: invoice_1, result: "success") }
  let!(:transaction_2) { create(:transaction, invoice: invoice_2, result: "success") }
  let!(:invoice_item_1) { create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 50, unit_price: 1500) }
  let!(:invoice_item_2) { create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 10, unit_price: 1000) }
  let!(:total_revenue) { (((50 * 1500) + (10 * 1000)) / 100.to_f).to_s}

  context 'All successful invoices ' do
    it 'returns total revenue for that merchant' do
      get "/api/v1/merchants/#{merchant.id}/revenue"
      returned = JSON.parse(response.body)

      expect(response).to be_success
      expect(returned).to be_a(Hash)
      expect(returned).to have_key("revenue")
      expect(returned["revenue"]).to eq(total_revenue)
    end
  end
  # context 'A failed invoice' do
  #   it "does not count a failed invoice in the revenue total" do
  #   end
  # end
end