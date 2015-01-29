class WidgetsController < ApplicationController
	protect_from_forgery except: [:index,:show]

  def index
  	begin
      respond_to do |format|
        format.css { widget_css(params[:garden_ids]) }
        format.js { widget_js(params[:garden_ids]) }
      end
    rescue Exception => e
      puts e.message
    end
  end

  def show
  	begin
      respond_to do |format|
        format.css { widget_css([params[:garden_id]]) }
        format.js { widget_js([params[:garden_id]]) }
      end
    rescue Exception => e
      puts e.message
    end
  end

  private

  def widget_css(garden_ids=nil)
   	scss = ""
   	get_widgets(garden_ids).each do |c|
   		slug = c.try(:name).to_s.downcase.gsub(/\s/, '-') if c.try(:name)
   		path = "public/static/components/#{slug}/stylesheets/#{slug}.css" if slug
   		scss << File.read(path) if path && File.exists?(path)
   	end
    render :text => scss, :content_type => "text/css"
  end

  def widget_js(garden_ids=[])
   	js = ""
   	get_widgets(garden_ids).each do |c|
   		slug = c.try(:name).to_s.downcase.gsub(/\s/, '-') if c.try(:name)
   		path = "public/static/components/#{slug}/javascripts/show.js" if slug
   		js << File.read(path) if path && File.exists?(path)
   	end
    render :text => js, :content_type => "text/javascript"
  end

  def get_widgets(garden_ids=[])
  	components = G5ComponentGarden.all.map
  	unless garden_ids.blank?
  		garden_ids = garden_ids.gsub(/[\[\]']+/, '').split(',').collect! { |n| n }.uniq unless garden_ids.kind_of?(Array)
   		components = components.select { |w| garden_ids.include?(w.try(:widget_id).to_s) }
   	end
   	components
  end
end
