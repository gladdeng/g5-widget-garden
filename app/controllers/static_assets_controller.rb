class StaticAssetsController < ApplicationController
  def index
    @static_assets = StaticAsset.all
  end
  
  def show
    @static_asset = StaticAsset.find(params[:file_name])
  end
end
