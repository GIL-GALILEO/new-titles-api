class UpdateGeorgiaTech < ActiveRecord::Migration[5.2]
  def up
    gt = Institution.find_by_shortcode('tech')
    gt.name = 'Georgia Institute of Technology Library'
    gt.electronic_path =
        '/shared/Georgia Institute of Technology Library/Reports/USG/USG New Titles Electronic'
    gt.physical_path =
        '/shared/Georgia Institute of Technology Library/Reports/USG/USG New Titles Physical'
    gt.save!
  end

  def down
    gt = Institution.find_by_shortcode('tech')
    gt.name = 'Georgia Institute of Technology'
    gt.electronic_path = nil
    gt.physical_path = nil
    gt.save!
  end
end
