class TitlesDatatable
  delegate :params,  to: :@view

  def initialize(view, institution = nil)
    @view = view
    @institution = institution
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Title.count,
        iTotalDisplayRecords: titles.total_count,
        aaData: data
    }
  end

  private

  def data
    titles.map do |title|
      [
          title.receiving_date,
          title.title ? "<a href='#{title.institution.url} + #{title.mms_id}'>#{title.title.titleize}</a>" : nil,
          title.author ? title.author.titleize: nil,
          title.material_type,
          title.publisher ? title.publisher.titleize : nil,
          title.call_number,
          title.call_number_sort,
          title.library,
          if institution_specified?
            title.location
          else
            title.inst_name
          end
      ]
    end
  end

  def titles
    @titles ||= fetch_titles
  end

  def fetch_titles
    titles = Title.order("#{sort_column} #{sort_direction}")
    titles = titles.page(page).per(per_page)
    if institution_specified?
      titles = titles.where(institution: @institution)
    end
    if params[:sSearch].present?
      titles = titles.where("LOWER(title) like :search or LOWER(author) like :search or LOWER(publisher) like :search or LOWER(material_type) like :search or LOWER(call_number) like :search or LOWER(mms_id) like :search or LOWER(location) like :search", search: "%#{params[:sSearch]}%".downcase)
    end
    titles.includes(:institution)
  end

  def page
    params[:iDisplayStart].to_i / per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[receiving_date title material_type author publisher call_number call_number_sort location]
    columns << 'institutions.name' unless @institution
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "asc" : "desc"
  end

  def institution_specified?
    @institution && !@institution.usg?
  end

end