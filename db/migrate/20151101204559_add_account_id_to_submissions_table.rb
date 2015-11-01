class AddAccountIdToSubmissionsTable < ActiveRecord::Migration
  def change
    add_column :submissions, :account_id, :integer
  end
end
