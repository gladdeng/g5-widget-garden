G5WidgetGarden::Application.routes.draw do
  get 'widgets/index'

  get 'widgets/show'

  get "components"       => "components#index", as: :components
  get "components/:slug" => "components#show",  as: :component

  get "widgets"									=> "widgets#index", 	as: :widgets
  get "widgets/:garden_id"			=> "widgets#show", 		as: :widget

  root to: "components#index"
end
