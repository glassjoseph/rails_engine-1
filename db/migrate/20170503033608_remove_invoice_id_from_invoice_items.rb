class RemoveInvoiceIdFromInvoiceItems < ActiveRecord::Migration[5.0]
  def change
    remove_column :invoice_items, :invoice_id, :integer
  end
end
