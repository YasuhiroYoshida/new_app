class CreateUsers < ActiveRecord::Migration
  def change
    drop_table :users do
    end
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
