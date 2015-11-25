class Website < ActiveRecord::Base
  belongs_to :account
  has_many :submissions
  validates :domain, uniqueness: true
end