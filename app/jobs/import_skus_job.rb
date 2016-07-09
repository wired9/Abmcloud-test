class ImportSkusJob < ActiveJob::Base
  queue_as :default

  def perform(path)
    prop_headers = (1..6).map { |i| 'property_' + i.to_s }
    headers = %w(id supplier_id) + prop_headers + ['price']

    ParallelCSV.new(path, headers: headers).process do |models|
      models.each do |row|
        row[1] = row[1].tr('s', '').to_i
      end

      SKU.import headers, models,
        on_duplicate_key_update: SKU.content_columns.map(&:name) - %w(created_at, updated_at),
        validate: false
    end
  end
end
