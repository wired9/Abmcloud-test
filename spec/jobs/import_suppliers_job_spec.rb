require 'rails_helper'

RSpec.describe ImportSuppliersJob, type: :job do
  let(:path) { 'spec/support/suppliers_small.csv' }
  subject { -> { ImportSuppliersJob.perform_now(path) } }

  it { is_expected.to change { Supplier.count }.by(10) }

  context 'old suppliers exist' do
    before(:each) do
      @old_supplier = Supplier.create(id: 1, name: 'old name')
    end

    it { is_expected.to change { Supplier.count }.by(9) }
    it { is_expected.to change { @old_supplier.reload.name }.to('Supplier 1') }
  end
end
