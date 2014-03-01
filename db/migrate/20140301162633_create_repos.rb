class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
  end
end
