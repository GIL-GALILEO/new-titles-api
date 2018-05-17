class StringifyPublicationDate < ActiveRecord::Migration[5.1]
  def change
    change_column :titles, :publication_date, :string
  end
end
