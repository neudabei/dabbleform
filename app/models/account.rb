class Account < ActiveRecord::Base
  has_many :websites
  #has_many :submissions, through: :websites

  validates :email, uniqueness: true
end