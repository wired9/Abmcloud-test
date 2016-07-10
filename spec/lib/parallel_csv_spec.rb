require 'rails_helper'

RSpec.describe ParallelCSV do
  let(:path) { 'spec/support/suppliers.csv' }
  subject { ParallelCSV.new(path,
                            chunk_size: 50,
                            process_num: 1,
                            headers: headers) }
  let(:headers) { %w(id name) }

  it 'raises exception if file does not exist' do
    path = "file_dont_exist"
    expect { ParallelCSV.new(path).process }.to raise_error(Errno::ENOENT)
  end

  describe '.process' do
    before(:each) do
      @chunks = []
      subject.process do |chunk|
        @chunks << chunk
      end
    end

    it 'produces correct number of chunks' do
      expect(@chunks.length).to be_eql(20)
    end

    it 'produces chunks of correct length' do
      expect(@chunks.first.length).to be_eql(50)
    end

    it 'produces rows as arrays of values' do
      expect(@chunks.first.first).to be_eql(['s0001', 'Supplier 1'])
    end
  end
end
