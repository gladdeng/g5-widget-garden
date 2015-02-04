class WidgetSettingDrop < Liquid::Drop
  attr_accessor :id, :name, :value

  def initialize(setting)
    @setting = setting
  end

end
