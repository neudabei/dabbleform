require 'rails_helper'

describe Account do
  it { should have_many(:websites) }
  it { should validate_uniqueness_of(:email) }
end