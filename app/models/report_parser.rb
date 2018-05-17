# frozen_string_literal: true

# generate titles, when applicable, from alma report xml
class ReportParser
  def self.title_from(row, medium)
    title_data = case medium
                 when 'electronic'
                   xml_hash_electronic row.element_children
                 when 'physical'
                   xml_hash_physical row.element_children
                 else
                   raise StandardError, 'Report medium error'
                 end
    title_data[:institution] = institution title_data
    Title.new title_data.except(:institution_name, :institution_code)
  end

  def self.institution(title_data)
    inst = institution_by_code title_data
    inst = institution_by_name(title_data) unless inst
    raise(StandardError, 'Institution could not be set') unless inst
    inst
  end

  def self.institution_by_name(data)
    return nil unless data[:institution_name]
    Institution.find_by_name data[:institution_name]
  end

  def self.institution_by_code(data)
    return nil unless data[:institution_code]
    Institution.find_by_institution_code data[:institution_code]
  end

  def self.xml_hash_physical(nodes)
    hash = {}
    nodes.each do |node|
      case node.name
      when 'Column1'
        hash[:author] = node.text
      when 'Column2'
        hash[:isbn] = node.text
      when 'Column3'
        hash[:mms_id] = node.text
      when 'Column4'
        hash[:publication_date] = node.text
      when 'Column5'
        hash[:publisher] = node.text
      when 'Column6'
        hash[:subjects] = node.text
      when 'Column7'
        hash[:title] = node.text
      when 'Column8'
        hash[:call_number] = node.text
      when 'Column9'
        hash[:classification_code] = node.text
      when 'Column10'
        hash[:institution_code] = node.text
      when 'Column11'
        hash[:institution_name] = node.text
      when 'Column12'
        hash[:library] = node.text
      when 'Column13'
        hash[:location] = node.text
      when 'Column14'
        hash[:material_type] = node.text
      when 'Column15'
        hash[:receiving_date] = date_from node.text
      else
        next
      end
    end
    hash
  end

  def self.xml_hash_electronic(nodes)
    hash = {}
    nodes.each do |node|
      case node.name
      when 'Column1'
        hash[:author] = node.text
      when 'Column3'
        hash[:mms_id] = node.text
      when 'Column4'
        hash[:subjects] = node.text
      when 'Column5'
        hash[:title] = node.text
      when 'Column6'
        hash[:portfolio_name] = node.text
      when 'Column7'
        hash[:institution_code] = node.text
      when 'Column8'
        hash[:institution_name] = node.text
      when 'Column9'
        hash[:classification_code] = node.text
      when 'Column10'
        date = date_from node.text
        hash[:portfolio_activation_date] = date
        # we should also consider this value the receiving date
        hash[:receiving_date] = date
      when 'Column11'
        hash[:portfolio_creation_date] = date_from node.text
      when 'Column12'
        hash[:availability] = node.text
      when 'Column13'
        hash[:material_type] = node.text
      else
        next
      end
    end
    hash
  end

  def self.date_from(val)
    Date.parse val
  end
end