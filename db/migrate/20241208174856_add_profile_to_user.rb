class AddProfileToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :surname, :string
    add_column :users, :name, :string
    add_column :users, :patron, :string
    add_column :users, :nickname, :string
    add_column :users, :status, :string

    add_column :users, :last_time_online, :string
    add_column :users, :gender, :string
    add_column :users, :date_birth, :string
    add_column :users, :type_activity, :string
    add_column :users, :company, :string
    add_column :users, :description, :string

    add_index :users, :nickname, unique: true
  end
end
