class ImportSuppliersJob < ActiveJob::Base
  queue_as :default

  def perform(path)
    headers = %w(id name)

    ParallelCSV.new(path, headers: headers).process do |models|
      models.each do |row|
        row[0] = row[0].tr('s', '').to_i
      end

      Supplier.import headers, models,
        on_duplicate_key_update: Supplier.content_columns.map(&:name) - %w(created_at, updated_at),
        validate: false
    end
  end
end
