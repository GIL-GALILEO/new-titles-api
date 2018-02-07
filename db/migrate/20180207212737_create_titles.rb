class CreateTitles < ActiveRecord::Migration[5.1]
  def change
    create_table :titles do |t|
      t.references :institution
      t.string :title
      t.string :author
      t.string :publisher
      t.string :call_number
      t.string :library
      t.string :location
      t.string :material_type
      t.date :receiving_date
      t.timestamps
    end
  end
end
