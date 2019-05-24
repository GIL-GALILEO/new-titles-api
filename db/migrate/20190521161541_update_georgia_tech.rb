class UpdateGeorgiaTech < ActiveRecord::Migration[5.2]
  def up
    gt = Institution.find_by_shortcode('tech')
    gt.shortcode= 'gatech'
    gt.institution_code = '01GALI_GIT'
    gt.image = 'http://www.comm.gatech.edu/sites/default/files/images/brand-graphics/gt-logo-gold.png'
    gt.api_key = '01GALI_GIT_key'
    gt.url = 'https://gatech-primo.hosted.exlibrisgroup.com/primo-explore/search?vid=01GALI_GIT&search_scope=default_scope&query=addsrcrid,exact,'
    gt.electronic_path =
        '/shared/Georgia Institute of Technology Library/Reports/USG/USG New Titles Electronic'
    gt.physical_path =
        '/shared/Georgia Institute of Technology Library/Reports/USG/USG New Titles Physical'
    gt.save!
  end

  def down
    gt = Institution.find_by_shortcode('gatech')
    gt.shortcode = 'tech'
    gt.institution_code = ''
    gt.image = 'http://www.library.gatech.edu/images/gt-logo-solid-blue.png'
    gt.api_key = '_key'
    gt.url = 'https://www.library.gatech.edu/'
    gt.electronic_path = nil
    gt.physical_path = nil
    gt.save!
  end
end
