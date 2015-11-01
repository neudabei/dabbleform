class CreateTables < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :email
      t.string :website
      t.boolean :verified
      t.timestamps
    end

    create_table :submissions do |t|
      t.string :email
      t.string :name
      t.text :message
      t.timestamps
    end
  end
end
