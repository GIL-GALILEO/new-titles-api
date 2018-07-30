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
          title.title,
          title.author,
          title.material_type,
          title.publisher,
          title.call_number,
          "<a href='#{title.institution.url} + #{title.mms_id}'>" + title.mms_id + "</a>",
          title.location,
          title.inst_name,
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
      titles = titles.where("title like :search or author like :search or publisher like :search or call_number like :search or mms_id like :search", search: "%#{params[:sSearch]}%")
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
    columns = %w[receiving_date title material_type author publisher call_number mms_id location]
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