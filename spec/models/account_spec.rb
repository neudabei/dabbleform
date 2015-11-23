require 'rails_helper'

describe Account do
  it { should have_many(:submissions) }
  it { should validate_uniqueness_of(:website) }
end