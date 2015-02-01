class WidgetSerializer < ActiveModel::Serializer
  attributes  :name,
              :slug,
              :summary,
              :garden_id,
              :thumbnail,
              :lib_javascripts,
              :lib_stylesheets,
              :javascript,
              :stylesheet,
              :property_groups

  def name
    object.try(:name).to_s
  end

  def slug
    object.try(:g5_uid).to_s
  end

  def summary
    object.try(:summary).to_s
  end

  def garden_id
    object.try(:widget_id).to_s.to_i
  end

  def thumbnail
    object.try(:photo).to_s
  end

  def lib_javascripts
    object.respond_to?(:g5_lib_javascripts) ? object.try(:g5_lib_javascripts).map(&:to_s) : []
  end

  def lib_stylesheets
    lib_css = object.try(:g5_stylesheets)
    lib_css.reject! { |css| css == object.try(:g5_stylesheet) } if lib_css
    lib_css ? lib_css.map(&:to_s) : []
  end

  def javascript
    object.try(:g5_show_javascript).to_s
  end

  def stylesheet
    object.try(:g5_stylesheet).to_s
  end

  def property_groups
    groups = []
    if object.respond_to?(:g5_property_groups)
      object.g5_property_groups.each do |pg|
        pg = pg.format
        group = {
          name: pg.try(:name).to_s,
          categories: categories(pg),
          properties: properties(pg)
        }
        groups << group
      end
    end
    groups
  end

  def categories(property_group)
    property_group.respond_to?(:categories) ? property_group.categories.map(&:to_s) : []
  end

  def properties(property_group)
    property_group.respond_to?(:g5_properties) ? property_group.g5_properties.map { |p| property(p) } : []
  end

  def property(prop)
    prop = prop.format
    {
      name: prop.try(:g5_name).to_s,
      editable: prop.try(:g5_editable).to_s.downcase == 'true' ? true : false,
      default: prop.try(:g5_default_value).to_s
    }
  end
end
