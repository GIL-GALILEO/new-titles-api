# frozen_string_literal: true

# represent a title
class Title < ApplicationRecord
  def self.create_from_xml(title_xml)
    data = title_xml.element_children
    institution = Institution.find_by_institution_code data[6].text
    institution = Institution.find_by_name data[6].text unless institution
    return nil unless institution
    new(
      institution_id: institution, title: data[4].text, author: data[1].text,
      # publisher: data[].text,
      call_number: data[8].text,
      # library: data[].text,
      # location: data[].text,
      material_type: data[12].text,
      receiving_date: data[2].text,
      mms_id: data[3].text
    )
  rescue StandardError => e
    puts "Error: #{e}"
    puts data.to_s
  end
end
