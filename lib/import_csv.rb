class ImportCSV
  CHUNK_SIZE = 10_000
  COL_SEP = '¦'
  VALIDATE = false

  def self.import(path, model_class, headers)
    chunks = SmarterCSV.process(
      path,
      col_sep: COL_SEP,
      chunk_size: CHUNK_SIZE,
      user_provided_headers: headers,
      headers_in_file: false
    )

    Parallel.map(chunks) do |chunk|
      ActiveRecord::Base.connection.reconnect!
      models = []

      chunk.each do |row|
        yield row if block_given?
        models << row.values
      end

      model_class.import headers, models,
                         on_duplicate_key_update: updated_columns(model_class),
                         validate: VALIDATE
    end
  end

  private

  def self.updated_columns(model_class)
    model_class.content_columns.map(&:name) -
      %w(created_at updated_at)
  end
end
