require 'spec_helper'

describe StaticAsset do
  
  describe "class" do
    let(:assets) { StaticAsset.all }
    
    it "has 3 things" do
      assets.should have(8).things
    end
    
    it "finds the asset" do
      StaticAsset.find("storage-list").name.should eq "storage-list"
    end
  end
  describe "instance" do
    let(:layout) { StaticAsset.find('storage-list') }
    it "should have a layout" do
      layout.name.should eq "storage-list"
    end
    
    it "should have a url" do
      layout.url.should eq "http://localhost:3001/assets/static_assets/storage-list.html"
    end
    
    it "has html" do
      layout.html.should match /Up to 5 x 5/
    end
    
    it "doesn't include stuff outside of widget" do
      layout.html.should_not match /Storage Unit List/
    end
    
    it "has the css" do
      layout.css.should include "http://g5-web-widgets.herokuapp.com/shared/css/styles.css"
    end
    
    
    it "has js" do
      layout.js.should include "http://g5-web-widgets.herokuapp.com/shared/js/script.js"
    end
    
  end
  
end