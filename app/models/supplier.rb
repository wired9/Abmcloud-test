class Supplier < ActiveRecord::Base
  has_many :skus, class_name: 'SKU'
end
