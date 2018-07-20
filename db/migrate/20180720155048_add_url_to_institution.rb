class AddUrlToInstitution < ActiveRecord::Migration[5.2]
  def change
    add_column :institutions, :url, :string, null: false
  end
end
