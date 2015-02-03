class WidgetSetting
  include ActiveModel::Model

  attr_accessor :id, :name, :value

  liquid_methods  :id_hidden_field,
                  :field_name,
                  :field_id,
                  :value_field_name,
                  :value_field_id,
                  :value

  def id_hidden_field
    ActionController::Base.helpers.hidden_field_tag("#{field_name}[id]", id)
  end

  def field_name
    "widget[settings_attributes][#{id}]"
  end

  def field_id
    field_name.underscore
  end

  def value_field_name
    "#{field_name}[value]"
  end

  def value_field_id
    value_field_name.parameterize.gsub(/-/, "_")
  end

end