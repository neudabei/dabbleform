class AllTablesRedone < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :email
      t.boolean :verified
      t.timestamps
    end

    create_table :websites do |t|
      t.string :domain
      t.boolean :verified
      t.string :token
      t.integer :account_id
      t.timestamps
    end

    create_table :submissions do |t|
      t.string :email
      t.string :name
      t.text :message
      t.integer :website_id
      t.timestamps
    end
  end
end
