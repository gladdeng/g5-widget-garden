class WidgetDrop < Liquid::Drop
  attr_reader :widget

  def initialize(widget)
    @widget = widget
  end

  def id
    widget.id
  end
end
