class Account < ActiveRecord::Base
  has_many :submissions
end