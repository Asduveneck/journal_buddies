class CreateJournals < ActiveRecord::Migration[7.0]
  def change
    create_table :journals do |t|
      t.string :name, null: false, default: ""
      t.text :description, default: ""
      t.string :visibility, default: ""

      t.timestamps
    end
  end
end
