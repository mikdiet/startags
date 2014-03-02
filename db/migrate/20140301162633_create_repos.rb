class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :name, null: false
      t.index :name, unique: true
      t.text :description

      t.timestamps
    end
  end
end
