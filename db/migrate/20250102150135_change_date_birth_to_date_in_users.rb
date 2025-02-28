class ChangeDateBirthToDateInUsers < ActiveRecord::Migration[7.2]
  def change
    change_column :users, :date_birth, :date
  end
end
