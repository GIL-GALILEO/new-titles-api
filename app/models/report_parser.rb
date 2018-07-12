# frozen_string_literal: true

# generate titles, when applicable, from alma report xml
class ReportParser
  def self.title_from(institution, row, medium)
    title_data = case medium
                 when 'electronic'
                   xml_hash_electronic row.element_children
                 when 'physical'
                   xml_hash_physical row.element_children
                 else
                   raise StandardError, 'Report medium error'
                 end
    title_data[:institution] = institution
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
      # when 'Column4' # Network ID
      #   hash[:tbd] = node.text
      when 'Column5'
        hash[:publication_date] = node.text
      when 'Column6'
        hash[:publisher] = node.text
      when 'Column7'
        hash[:subjects] = node.text
      # when 'Column8' # Suppressed from Discovery? Always NO
      #   hash[:tbd] = node.text
      when 'Column9'
        hash[:title] = node.text
      # when 'Column10' # Now Normalize Call. Could be useful for genuine sorting
      #   hash[:institution_code] = node.text
      when 'Column11' # Perm Call #
        hash[:call_number] = node.text
      when 'Column12'
        hash[:classification_code] = node.text
      when 'Column13'
        hash[:location] = node.text
      when 'Column14' # Library Name
        hash[:library] = node.text
      # when 'Column15' # Location Name
      #   hash[:location] = node.text
      when 'Column16'
        hash[:material_type] = node.text
      when 'Column17'
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
      when 'Column2'
        hash[:isbn] = node.text
      when 'Column3'
        hash[:call_number] = node.text
      when 'Column4'
        hash[:mms_id] = node.text
      when 'Column5'
        # hash[:] = node.text
      when 'Column6'
        hash[:publication_date] = node.text
      when 'Column7'
        hash[:publisher] = node.text
      when 'Column8'
        hash[:subjects] = node.text
      when 'Column9'
        # hash[:] = node.text
      when 'Column10'
        hash[:title] = node.text
      when 'Column11'
        hash[:portfolio_name] = node.text
      when 'Column12'
        date = node.text == '' ? '' : date_from(node.text)
        hash[:portfolio_activation_date] = date
        hash[:receiving_date] = date
      when 'Column13'
        hash[:material_type] = node.text
      else
        next
      end
    end
    hash
  end

  def self.date_from(val)
    str = val.gsub(/[^0-9]/, '')
    return Date.strptime(val, '%Y') if str.length == 4
    Date.parse str
  rescue StandardError
    nil
  end
end