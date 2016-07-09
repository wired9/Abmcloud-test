require 'rails_helper'

RSpec.describe ParallelCSV do
  context 'amount of queries' do
    let(:path) { 'spec/support/suppliers.csv' }
    subject { ParallelCSV.new(chunk_size: 50, process_num: 1) }
    let(:headers) { %w(id name) }

    it 'produces correct number of chunks' do
      subject
    end
  end
end
