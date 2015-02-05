class WidgetsController < ApplicationController
	protect_from_forgery except: [:index,:show]

  def index
  	_widgets
  end

  def show
  	_widgets
  end

  def show_html
    _html(:g5_show_template)
  end

  def edit_html
    _html(:g5_edit_template)
  end

  def show_htmls
    _htmls(:g5_show_template)
  end

  def edit_htmls
    _htmls(:g5_edit_template)
  end

  private

  def get_garden_ids
    return [params[:garden_id].to_i] if params[:garden_id]
    return params[:garden_ids].split(',').map(&:to_i).uniq if params[:garden_ids]
    return get_widget_params.map { |p| p[:garden_id].to_i }.uniq if get_widget_params
    "all"
  end

  def get_widgets(garden_ids=[])
    @widgets = G5ComponentGarden.all.map
    unless garden_ids.blank? || garden_ids.include?('all')
      @widgets = @widgets.select { |w| garden_ids.include?(w.try(:widget_id).to_s.to_i) }
    end
    @widgets
  end

   def _widgets
    begin
      get_widgets(get_garden_ids)
      respond_to do |format|
        format.json { render :json => widget_json }
        format.css  { render :text => widget_css, :content_type => "text/css" }
        format.js   { render :text => widget_js, :content_type => "text/javascript" }
      end
    rescue Exception => e
      puts e.message
    end
  end

  def widget_json(widgets=@widgets, root=true)
    json = []
    widgets.each do |widget|
      ws = WidgetSerializer.new(widget)
      json << ws.as_json(root: false)
    end
    json = {widgets: json} if root
    json.to_json
  end

  def widget_css(widgets=@widgets)
   	scss = ""
    dependencies = []
   	widgets.each do |w|
      dependencies << widget_dependencies(w, 'css')
   		path = "public/#{w.g5_stylesheet}" if w.respond_to?(:g5_stylesheet)
   		scss << File.read(path) if path && File.exists?(path)
   	end
    scss.prepend(load_widget_dependencies(dependencies))
    scss
  end

  def widget_js(widgets=@widgets)
   	js = ""
    dependencies = []
   	widgets.each do |w|
      dependencies << widget_dependencies(w, 'js')
      path = "public/#{w.g5_show_javascript}" if w.respond_to?(:g5_show_javascript)
   		js << File.read(path) if path && File.exists?(path)
   	end
    js.prepend(load_widget_dependencies(dependencies))
    js
  end

  def _html(template)
    get_widgets(get_garden_ids)
    if @widgets.size == 1
      params = get_widget_params.first unless get_widget_params.blank?
      render :text => single_widget_html(template, @widgets.first, params)
    end
  end

  def _htmls(template)
    get_widgets(get_garden_ids)
    render :json => multi_widget_html(template)
  end

  def single_widget_html(template, widget, params=nil)
    html = ""
    path = "public/#{widget.try(template).to_s}" if widget.respond_to?(template)
    if path && File.exists?(path)
      begin
        widget_id = params.has_key?(:id) ? params[:id] : 0
        settings = params.has_key?(:settings) ? params[:settings] : []
        html << Liquid::Template.parse(File.read(path)).render("widget" => load_widget_settings(widget, widget_id, settings))
      rescue Exception => e
        puts "error parsing #{widget.try(:g5_uid)} - #{e.message}"
      end
    end
    html
  end

  def multi_widget_html(template)
    json = {widgets: []}
    params = get_widget_params
    params.each do |p|
      component = @widgets.detect { |w| w.try(:widget_id).to_s.to_i == p[:garden_id] }
      json[:widgets] << {
        id: p[:id],
        garden_id: p[:garden_id],
        html: single_widget_html(template, component, p)
      }
    end if params
    json.to_json
  end

  def widget_dependencies(component, format)
    return case format
    when "css"
      lib_css = component.try(:g5_stylesheets)
      lib_css.reject! { |css| css == component.try(:g5_stylesheet) } if lib_css
      lib_css ? lib_css.map(&:to_s) : []
    when "js"
      component.try(:g5_lib_javascripts) ? component.try(:g5_lib_javascripts).map(&:to_s) : []
    end
  end

  def widget_from_json(component)
    JSON.parse(widget_json([component], false), {:symbolize_names => true}).first if component
  end

  def load_widget_dependencies(dependencies)
    dependencies.flatten.uniq.inject("") do |buffer, path|
      path = "public/#{path}"
      buffer << File.read(path) if File.exists?(path)
    end
  end

  ## widget settings

  def load_widget_settings(component, widget_id=0, settings=[])
    Widget.new(get_widget_properties(component, widget_id, settings))
  end

  def find_setting(settings, key)
    settings.detect { |s| s[:name].to_sym == key } if settings
  end

  def widget_setting(name, id, value)
    WidgetSetting.new({:name => name, :id => id, :value => value})
  end

  ## widget properties

  def widget_instance_property_group(component)
    if component.respond_to?(:g5_property_groups)
      group = component.g5_property_groups.detect do |g|
        g = g.format
        g.categories.map(&:to_s).map(&:downcase).include?("instance") if g.respond_to?(:categories)
      end
      group.format if group
    end
  end

  def widget_instance_properties(component)
    prop_group = widget_instance_property_group(component)
    prop_group.try(:g5_properties) if prop_group
  end

  def get_widget_properties(component, widget_id, settings)
    {
      id: widget_id,
      garden_id: component.try(:widget_id),
      settings: load_widget_properties(widget_instance_properties(component), settings)
    }
  end

  def load_widget_properties(properties, settings)
    arr = []
    properties.each do |prop|
      name = prop.format.try(:g5_name).to_s
      setting = find_setting(settings, name.to_sym)
      setting_id = setting ? setting[:id] : 0
      val = setting ? setting[:value] : prop.try(:g5_default_value)
      arr << widget_setting(name, setting_id, val)
    end if properties
    arr
  end

  ## widget packet params

  def get_widget_params
    params[:widgets]
  end

  def find_widget_in_params(widget_id)
    get_widget_params.detect { |s| s[:id] == widget_id } if get_widget_params
  end

  def find_widget_settings_in_params(widget_id)
    widget = find_widget_in_params(widget_id)
    widget[:settings] if widget
  end

  def find_widget_types_in_params(garden_id)
    get_widget_params.select { |s| s[:garden_id] == garden_id } if get_widget_params
  end
end
