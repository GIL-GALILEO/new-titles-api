# frozen_string_literal: true

# generate titles, when applicable, from alma report xml
class ReportParser
  SUPPORTED_MEDIUMS = ['electronic', 'physical']

  # Creates a new Title instance from an xml row from alma report api response
  # @param [Institution] institution
  # @param [Nokogiri::XML] xml_row
  # @param [String] medium
  # @return [Title]
  def self.title_from(institution, xml_row, medium)
    title_data = case medium
                 when 'electronic'
                   xml_hash_electronic xml_row.element_children
                 when 'physical'
                   xml_hash_physical xml_row.element_children
                 else
                   raise ArgumentError, "medium not supported: #{medium}. Supported Reports: #{SUPPORTED_MEDIUMS}"
                 end
    title_data[:institution] = institution
    finalize_location(title_data)
    Title.new title_data
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
      when 'Column10'
        hash[:call_number_sort] = node.text
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
      when 'Column18'
        hash[:temporary_location] = node.text
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
        date = node.text&.blank? ? '' : date_from(node.text)
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
    return if val.blank?

    str = val&.gsub(/[^0-9]/, '')
    if str&.length == 4
      Date.strptime(str, '%Y')
    else
      Date.parse str
    end
  rescue ArgumentError
    nil
  end

  def self.finalize_location(title_data)
    unless title_data[:temporary_location].blank? ||
           title_data[:temporary_location].casecmp('None').zero?
      title_data[:location] = title_data[:temporary_location]
    end
    title_data.delete(:temporary_location)
  end
end