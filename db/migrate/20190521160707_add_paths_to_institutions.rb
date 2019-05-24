class AddPathsToInstitutions < ActiveRecord::Migration[5.2]
  def change
    add_column :institutions, :electronic_path, :string
    add_column :institutions, :physical_path, :string
  end
end
