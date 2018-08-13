class AddCallNumberSort < ActiveRecord::Migration[5.2]
  def change
    add_column :titles, :call_number_sort, :string
  end
end
