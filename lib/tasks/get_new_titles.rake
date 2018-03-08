# frozen_string_literal: true

# require 'rake'
# require 'nokogiri'
# require 'cgi'
# require 'net/smtp'
# require 'rest-client'

# The following commented table details what the headings are and their
# corresponding 'Column' in the XML file

# Column0 -> place holder
# Column1 ->  Author
# Column2 -> Creation Date
# Column3 -> MMSID
# Column4 -> Title
# Column5 -> Public Name
# Column6 -> Institution code
# Column7 -> Institution Name
# Column8 -> LC classification code
# Column9 -> Portfolio Activation Date
# Column10 -> Portfolio Creation Date
# Column11 -> Availability
# Column12 -> Material Type

task get_daily_report: :environment do

  report = AlmaReportsApi.pull '/shared/Galileo Network/Reports/New Titles Electronic Daily'

  titles = []

  report.rows.each do |title_xml|
    t = Title.create_from_xml title_xml
    unless t
      puts 'Failed to find institution for: ' + title_xml.element_children[6].text
      next
    end
    t.save
    titles << t
  end

  puts 'Title objects created: ' + titles.length.to_s
  puts 'XML Rows: ' + report.rows.length.to_s

end

task get_physical_daily_report: :environment do

  puts "Getting daily physical titles report"
  #get the report from analytics api call
  #puts "I went into the get report function"


  #The following commented table details what the headings are and their corresponding 'Column' in the XML file
  #Column0 -> place holder
  #Column1 ->  Author
  #Column2 -> ISBN
  #Column3 -> MMSID
  #Column4 -> Publication Date
  #Column5 -> Publisher
  #Column6 -> Title
  #Column7 -> Normalized Call Number
  #Column8 -> Permanent Call Number
  #Column9 -> Permanent Lc Classification code
  #Column10 -> Institution Code
  #Column11 -> Institution Name
  #Column12 -> Library Name
  #Column13 -> Location Name
  #Column14 -> Material Type
  #Column15 -> Receiving Date

  url = 'https://api-eu.hosted.exlibrisgroup.com/almaws/v1/analytics/reports'
  headers = { :params => {CGI::escape('path') => '/shared/Galileo Network/Reports/New Physical Titles Daily',
                           CGI::escape('limit') => '1000', CGI.escape('apikey') => Rails.application.secrets.api_key}}

  billing_report_xml = RestClient::Request.execute :method=> 'GET', :url=>url, :headers => headers

  xml_doc = Nokogiri::XML(billing_report_xml)
  xml_doc.remove_namespaces!

  #for testing to see if the the report is gotten
  #puts xml_doc

  #get tokens to for the possibility of having to fetch the next part of the report.
  is_finished = xml_doc.xpath("//IsFinished").text.to_s
  resume_token = xml_doc.xpath("//ResumptionToken").text.to_s


  #functionality for fetching other parts of the report, if the report is over 1000 lines
  while is_finished != "true"
    #puts "Went into while statment"
    #puts "URL is " + url
    headers_redo = { :params => {CGI::escape('token') => resume_token,
                                  CGI::escape('limit') => '1000', CGI.escape('apikey') => Rails.application.secrets.api_key}}
    billing_report_xml_redo = RestClient::Request.execute :method=> 'GET', :url=>url, :headers => headers_redo

    xml_doc_redo = Nokogiri::XML(billing_report_xml_redo)#.search('Row')
    xml_doc_redo.remove_namespaces!

    is_finished = xml_doc_redo.xpath("//IsFinished").text.to_s

    new_xml_rows = xml_doc_redo.xpath("//Row")
    xml_doc.at('rowset').add_child(new_xml_rows)

    #puts "The report is finished (while loop):" + isFinished
  end
  puts "Got the report"

  xml_rows = xml_doc.xpath("//Row")
  #puts xml_rows

  total_rows = 0
  xml_rows.each do |row|
    total_rows +=1
  end

  puts total_rows

end

#-------------------------------------------------------------------------------------
task get_physical_full_report: :environment do

  puts "Getting full physical titles report"
  #This task is designed to get the full physical new titles report
  #This will be run ideally ONE time to initially populate the datadase with New Physical Titles for the past 6 weeks


  #The following commented table details what the headings are and their corresponding 'Column' in the XML file
  #Column0 -> place holder
  #Column1 ->  Author
  #Column2 -> ISBN
  #Column3 -> MMSID
  #Column4 -> Publication Date
  #Column5 -> Publisher
  #Column6 -> Title
  #Column7 -> Normalized Call Number
  #Column8 -> Permanent Call Number
  #Column9 -> Permanent Lc Classification code
  #Column10 -> Institution Code
  #Column11 -> Institution Name
  #Column12 -> Library Name
  #Column13 -> Location Name
  #Column14 -> Material Type
  #Column15 -> Receiving Date

  url = 'https://api-eu.hosted.exlibrisgroup.com/almaws/v1/analytics/reports'
  headers = { :params => {CGI::escape('path') => '/shared/Galileo Network/Reports/New Physical Titles',
                           CGI::escape('limit') => '1000', CGI.escape('apikey') => Rails.application.secrets.api_key}}

  billing_report_xml = RestClient::Request.execute :method=> 'GET', :url=>url, :headers => headers

  xml_doc = Nokogiri::XML(billing_report_xml)
  xml_doc.remove_namespaces!

  #for testing to see if the the report is gotten
  #puts xml_doc

  #get tokens to for the possibility of having to fetch the next part of the report.
  is_finished = xml_doc.xpath("//IsFinished").text.to_s
  resume_token = xml_doc.xpath("//ResumptionToken").text.to_s


  #functionality for fetching other parts of the report, if the report is over 1000 lines
  while is_finished != "true"
    #puts "Went into while statment"
    #puts "URL is " + url
    headers_redo = { :params => {CGI::escape('token') => resume_token,
                                  CGI::escape('limit') => '1000', CGI.escape('apikey') => Rails.application.secrets.api_key}}
    billing_report_xml_redo = RestClient::Request.execute :method=> 'GET', :url=>url, :headers => headers_redo

    xml_doc_redo = Nokogiri::XML(billing_report_xml_redo)#.search('Row')
    xml_doc_redo.remove_namespaces!

    is_finished = xml_doc_redo.xpath("//IsFinished").text.to_s

    new_xml_rows = xml_doc_redo.xpath("//Row")
    xml_doc.at('rowset').add_child(new_xml_rows)

    #puts "The report is finished (while loop):" + isFinished
  end
  puts "Got the report"

  xml_rows = xml_doc.xpath("//Row")
  #puts xml_rows

  total_rows = 0
  xml_rows.each do |row|
    total_rows +=1
  end

  puts total_rows

end


task get_electronic_full_report: :environment do

  puts 'Getting full electronic titles report'
  # This task is designed to get the full electronic new titles report
  # This will be run ideally ONE time to initially populate the datadase with New Electronic Titles for the past 6 weeks


  # The following commented table details what the headings are and their corresponding 'Column' in the XML file
  # Column0 -> place holder
  # Column1 ->  Author
  # Column2 -> ISBN
  # Column3 -> MMSID
  # Column4 -> Publication Date
  # Column5 -> Publisher
  # Column6 -> Title
  # Column7 -> Normalized Call Number
  # Column8 -> Permanent Call Number
  # Column9 -> Permanent Lc Classification code
  # Column10 -> Institution Code
  # Column11 -> Institution Name
  # Column12 -> Library Name
  # Column13 -> Location Name
  # Column14 -> Material Type
  # Column15 -> Receiving Date

  url = 'https://api-eu.hosted.exlibrisgroup.com/almaws/v1/analytics/reports'
  headers = { :params => {CGI::escape('path') => '/shared/Galileo Network/Reports/New Titles Electronic',
                           CGI::escape('limit') => '1000', CGI.escape('apikey') => Rails.application.secrets.api_key}}

  billing_report_xml = RestClient::Request.execute :method=> 'GET', :url=>url, :headers => headers

  xml_doc = Nokogiri::XML(billing_report_xml)
  xml_doc.remove_namespaces!

  #for testing to see if the the report is gotten
  #puts xml_doc

  #get tokens to for the possibility of having to fetch the next part of the report.
  is_finished = xml_doc.xpath("//IsFinished").text.to_s
  resume_token = xml_doc.xpath("//ResumptionToken").text.to_s


  #functionality for fetching other parts of the report, if the report is over 1000 lines
  while is_finished != "true"
    #puts "Went into while statment"
    #puts "URL is " + url
    headers_redo = { :params => {CGI::escape('token') => resume_token,
                                  CGI::escape('limit') => '1000', CGI.escape('apikey') => Rails.application.secrets.api_key}}
    billing_report_xml_redo = RestClient::Request.execute :method=> 'GET', :url=>url, :headers => headers_redo

    xml_doc_redo = Nokogiri::XML(billing_report_xml_redo)#.search('Row')
    xml_doc_redo.remove_namespaces!

    is_finished = xml_doc_redo.xpath("//IsFinished").text.to_s

    new_xml_rows = xml_doc_redo.xpath("//Row")
    xml_doc.at('rowset').add_child(new_xml_rows)

    #puts "The report is finished (while loop):" + isFinished
  end
  puts "Got the report"

  xml_rows = xml_doc.xpath("//Row")
  #puts xml_rows

  total_rows = 0
  xml_rows.each do |row|
    total_rows += 1
  end

  puts total_rows

end