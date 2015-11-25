class Account < ActiveRecord::Base
  has_many :websites
  validates :website, uniqueness: true
end