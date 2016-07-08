class ImportSuppliersJob < ActiveJob::Base
  queue_as :default

  def perform(path)
    ImportCSV.import(path, Supplier, %w(id name)) do |row|
      row[:id] = row[:id].tr('s', '').to_i
    end
  end
end
