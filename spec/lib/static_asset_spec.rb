require 'spec_helper'

describe StaticAsset do
  
  describe "class" do
    let(:static_assets) { StaticAsset.all }
    
    it "has 3 things" do
      static_assets.should have(8).things
    end
    
    it "finds the asset" do
      StaticAsset.find("storage-list").name.should eq "storage-list"
    end
  end
  describe "instance" do
    let(:static_asset) { StaticAsset.find('storage-list') }
    it "should have a static_asset" do
      static_asset.name.should eq "storage-list"
    end
    
    it "should have a url" do
      static_asset.url.should eq "http://localhost:3001/assets/static_assets/storage-list.html"
    end
    
    it "has html" do
      static_asset.html.should match /Up to 5 x 5/
    end
    
    it "doesn't include stuff outside of widget" do
      static_asset.html.should_not match /Storage Unit List/
    end
    
    it "has the css" do
      static_asset.css.should include "http://g5-web-widgets.herokuapp.com/shared/css/styles.css"
    end
    
    
    it "has js" do
      static_asset.js.should include "http://g5-web-widgets.herokuapp.com/shared/js/script.js"
    end
    
  end
  
end
