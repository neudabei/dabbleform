class Account < ActiveRecord::Base
  has_many :submissions
  validates :website, uniqueness: true

end