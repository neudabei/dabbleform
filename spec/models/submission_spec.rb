require 'rails_helper'

describe Submission do
  it { should belong_to(:website) }
end