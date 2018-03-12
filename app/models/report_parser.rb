# frozen_string_literal: true

# generate titles, when applicable, from alma report xml
class ReportParser
  def self.title_from(row)
    title_data = xml_hash row.element_children
    title_data[:institution_id] = institution title_data
    Title.new title_data
  end

  def self.institution(title_data)
    inst = Institution.find_by_institution_code title_data[:institution_id]
    inst = Institution.find_by_name title_data[:institution_id] unless inst
    raise StandardError('Institution could not be set') unless inst
    inst.id
  end

  def self.xml_hash(nodes)
    {
      author: nodes[4].text,
      title: nodes[3].text,
      institution_id: nodes[6].text,
      mms_id: nodes[2].text,
      material_type: nodes[11].text,
      # publisher: ,
      # call_number: ,
      # library: ,
      # location: ,
    }
  end
end