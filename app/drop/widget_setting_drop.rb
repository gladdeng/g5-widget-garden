class WidgetDrop < Liquid::Drop
  attr_accessor :widget

  def initialize(widget)
    @widget = widget
  end

  def before_method(method)
    setting = widget.settings.find_by(name: method)
    setting.try(:decorate)
  end

end
