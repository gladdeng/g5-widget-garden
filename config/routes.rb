G5WidgetGarden::Application.routes.draw do
  get 'widgets/index'

  get 'widgets/show'

  get "components"       => "components#index", as: :components
  get "components/:slug" => "components#show",  as: :component

  get "widgets"									=> "widgets#index", 	as: :widgets
  get "widgets/:garden_id"			=> "widgets#show", 		as: :widget

  post "widgets/:garden_id/edit"			=> "widgets#edit_html", as: :edit_widget
  post "widgets/:garden_id/show"			=> "widgets#show_html", as: :show_widget
  post "widgets/show"									=> "widgets#show_html", as: :show_widgets

  root to: "components#index"
end
