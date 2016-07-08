class ImportSkusJob < ActiveJob::Base
  queue_as :default

  def perform(path)
    prop_headers = (1..6).map { |i| 'property_' + i.to_s }

    headers = %w(id supplier_id) + prop_headers + ['price']
    ImportCSV.import(path, SKU, headers) do |row|
      row[:supplier_id] = row[:supplier_id].tr('s', '').to_i
    end
  end
end
