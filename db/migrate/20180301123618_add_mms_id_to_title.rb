class AddMmsIdToTitle < ActiveRecord::Migration[5.1]
  def change
    add_column :titiles, :mms_id, :string
  end
end
