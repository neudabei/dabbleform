require 'rails_helper'

describe Website do 
  it { should have_many :submissions }
  it { should belong_to :account }
end