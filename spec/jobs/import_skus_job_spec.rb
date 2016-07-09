require 'rails_helper'

RSpec.describe ImportSkusJob, type: :job do
  let(:path) { 'spec/support/sku_small.csv' }
  subject { -> { ImportSkusJob.perform_now(path) } }

  it { is_expected.to change { SKU.count }.by(10) }

  context 'old sku exist' do
    before(:each) do
      @old_sku = SKU.create(id: 1, price: 9.99)
    end

    it { is_expected.to change { SKU.count }.by(9) }
    it { is_expected.to change { @old_sku.reload.price }.to(10.25) }
  end

  it 'matches existing suppliers' do
    supplier = Supplier.create(id: 256, name: 'Supplier 256')
    ImportSkusJob.perform_now(path)

    expect(SKU.where(supplier: supplier)).to exist
  end
end
