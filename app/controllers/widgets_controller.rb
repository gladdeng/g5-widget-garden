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

  private

  def get_garden_ids
    return [params[:garden_id]] if params[:garden_id]
    return params[:garden_ids].split(',').uniq if params[:garden_ids]
    "all"
  end

  def get_widgets(garden_ids=[])
    @widgets = G5ComponentGarden.all.map
    unless garden_ids.blank? || garden_ids.include?('all')
      @widgets = @widgets.select { |w| garden_ids.include?(w.try(:widget_id).to_s) }
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

  def _html(template)
    get_widgets(get_garden_ids)
    html = ""
    @widgets.each do |w|
      path = "public/#{w.try(template).to_s}" if w.respond_to?(template)
      if path && File.exists?(path)
        begin
          content = File.read(path)
          widget = load_widget_settings(w)
          binding.pry
          content = Liquid::Template.parse(content).render("widget" => WidgetDrop.new(widget))
          ##TODO: liquid parsing
          html << content
        rescue Exception => e
          puts "error parsing #{w.try(:g5_uid)} - #{e.message}"
        end
      end
    end
    render :text => html
  end

  def widget_json(widgets=@widgets, root=true)
    json = []
    widgets.each do |w|
      ws = WidgetSerializer.new(w)
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


  def widget_slug(component)
    component.try(:g5_uid)
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

  def widget_from_json(widget)
    JSON.parse(widget_json([widget], false), {:symbolize_names => true}).first if widget
  end

  def load_widget_dependencies(dependencies)
    dependencies.flatten.uniq.inject("") do |buffer, path|
      path = "public/#{path}"
      buffer << File.read(path) if File.exists?(path)
    end
  end

  def load_widget_settings(component, widget_id=0, settings={})
    widget = widget_from_json(component)
    prop_group = widget[:property_groups].detect { |g| g[:categories].map(&:downcase).include?("instance") }
    props = prop_group[:properties].inject({}) do |h, p|
      k = p[:name].to_sym
      val = settings.has_key?(k) ? settings[k] : p[:default]
      h[k] = widget_setting(p[:name], widget_id, val)
      h
    end if prop_group
    ##TODO RESUME HERE
  end

  def widget_setting(name, id, value)
    WidgetSetting.new({name: name, id: id, value: value})
  end
end
