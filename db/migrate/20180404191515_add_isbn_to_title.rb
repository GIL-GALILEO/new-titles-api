class AddIsbnToTitle < ActiveRecord::Migration[5.1]
  def change
    add_column :titles, :isbn, :string
    add_column :titles, :publication_date, :date
    add_column :titles, :portfolio_name, :string
  end
end
