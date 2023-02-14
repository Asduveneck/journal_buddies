class CreateJournals < ActiveRecord::Migration[7.0]
  def change
    create_table :journals do |t|
      t.string :name
      t.text :description
      t.string :visibility, default: ""

      t.timestamps
    end
  end
end
