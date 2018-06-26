# frozen_string_literal: true

# Add shortcode field to Institution
class AddShortcodeToInstitution < ActiveRecord::Migration[5.2]
  def change
    add_column :institutions, :shortcode, :string, null: false
  end
end
