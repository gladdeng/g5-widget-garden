class WidgetsController < ApplicationController
	protect_from_forgery except: [:index,:show]

  def index
  	begin
      get_widgets(get_garden_ids)
      respond_to do |format|
        format.json { widget_json }
        format.css  { widget_css }
        format.js   { widget_js }
      end
    rescue Exception => e
      puts e.message
    end
  end

  def show
  	begin
      get_widgets(get_garden_ids)
      respond_to do |format|
        format.html { widget_html }
        format.json { widget_json }
        format.css  { widget_css }
        format.js   { widget_js }
      end
    rescue Exception => e
      puts e.message
    end
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

  def widget_html
    ##TODO: add HTML Liquid parsing here
  end

  def widget_json
    json = {widgets: []}
    @widgets.each do |c|
      ws = WidgetSerializer.new(c)
      json[:widgets] << ws.as_json(root: false)
    end
    render :json => json.to_json
  end

  def widget_css
   	scss = ""
    dependencies = []
   	@widgets.each do |c|
      dependencies << widget_dependencies(c, 'css')
   		path = "public/#{c.g5_stylesheet}" if c.respond_to?(:g5_stylesheet)
   		scss << File.read(path) if path && File.exists?(path)
   	end
    scss.prepend(load_widget_dependencies(dependencies))
    render :text => scss, :content_type => "text/css"
  end

  def widget_js
   	js = ""
    dependencies = []
   	@widgets.each do |c|
      dependencies << widget_dependencies(c, 'js')
      path = "public/#{c.g5_show_javascript}" if c.respond_to?(:g5_show_javascript)
   		js << File.read(path) if path && File.exists?(path)
   	end
    js.prepend(load_widget_dependencies(dependencies))
    render :text => js, :content_type => "text/javascript"
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

  def load_widget_dependencies(dependencies)
    dependencies.flatten.uniq.inject("") do |buffer, path|
      path = "public/#{path}"
      buffer << File.read(path) if File.exists?(path)
    end
  end
end
