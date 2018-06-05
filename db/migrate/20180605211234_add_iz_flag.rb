# frozen_string_literal: true

# add a flag to Titles table indicating if the title came from an IZ report
class AddIzFlag < ActiveRecord::Migration[5.2]
  def change
    add_column :titles, :iz, :boolean, default: false
  end
end
