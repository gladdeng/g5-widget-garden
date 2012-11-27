class StaticAsset < File
  attr_accessor :body
  include Rails.application.routes.url_helpers
  REMOTE_ASSETS_URL = "http://g5-web-widgets.herokuapp.com/"
  class << self
    def all
      Dir.glob('public/assets/static_assets/*.html').collect {|file| open(file)}
    end
    
    def find(name)
      all.find {|asset| asset.name == name}
    end
  end
  
  def initialize(*args)
    super(*args)
    @body = self.read
  end
  
  def name
    path.split("/").last.gsub(".html", "")
  end
  
  def url
    root_url + asset_path
  end
  
  def asset_path
    path.gsub("public/", "")
  end
  
  def html
    Nokogiri::HTML(body).at_css(".widget").to_html
  end
  
  def js
    links = Nokogiri::HTML(body).css('script')
    
    links.map do |link|
      if link['src'] && link['src'].match(/googleapis/)
        link['src']
      else
        REMOTE_ASSETS_URL + link['src'].gsub('../', "") if link['src']
      end
    end.compact
  end
  
  
  def css
    links = Nokogiri::HTML(body).css('link[rel="stylesheet"]')
    links.map do |link|
      REMOTE_ASSETS_URL + link['href'].gsub('../', "")
    end
  end
end