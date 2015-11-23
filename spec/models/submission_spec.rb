require 'rails_helper'

describe Submission do
  it { should belong_to(:account) }
end