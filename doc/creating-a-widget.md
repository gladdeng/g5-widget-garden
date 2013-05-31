# Creating a Widget

## Overview

A widget is defined by the contents of a directory located at
`public/static/components/:widget-name` where :widget-name is the name of the
widget, downcased and dashed. More information about the contents of this
directory is below.

## Directory Structure

* public/
    * [javascripts/](#publicjavascripts) - javascript libraries accessible by any widget
        * [:lib-javascript.js](#publicjavascriptslib-javascriptjs) - a javascript library
    * [static/](#publicstatic)
        * [components/](#publicstaticcomponents)
            * [:widget-name/](#publicstaticcomponentswidget-name) - a widget!
              * [index.html](#publicstaticcomponentswidget-nameindexhtml) - required
              * [edit.html](#publicstaticcomponentswidget-nameedithtml) - required
              * [show.html](#publicstaticcomponentswidget-nameshowhtml) - required
              * [images/](#publicstaticcomponentswidget-nameimages) - a widget's images
                  * [thumbnail.png](#publicstaticcomponentswidget-nameimagesthumbnailpng) - required
                  * [:custom.png](#publicstaticcomponentswidget-nameimagescustompng)
              * [javascripts/](#publicstaticcomponentswidget-namejavascripts) - a widget's custom javascripts
                  * [edit.js](#publicstaticcomponentswidget-namejavascriptseditjs) - generated from contents of edit directory
                  * [edit/](#publicstaticcomponentswidget-namejavascriptsedit) - files will be included in alphabetical order
                      * [:custom.js.coffee](#publicstaticcomponentswidget-namejavascriptseditcustomjscoffee)
                  * [show.js](#publicstaticcomponentswidget-namejavascriptsshowjs) - generated from contents of show directory
                  * [show/](#publicstaticcomponentswidget-namejavascriptsshow) - generated from contents of show directory
                      * [:custom.js.coffee](#publicstaticcomponentswidget-namejavascriptsshowcustomjscoffee)
              * [stylesheets/](#publicstaticcomponentswidget-namestylesheets) - a widget's custom stylesheets
                  * [:custom.css](#publicstaticcomponentswidget-namestylesheetscustomcss)

## Documentation

### public/javascripts/

- javascript libraries accessible by any widget
- to include a particular library in a particular widget, hardcode the path in index.html

[top](#directorystructure)

### public/javascripts/:lib-javascript.js

- :lib-javascript is a placeholder for the name of a library
- e.g. twitter, h5validate

[top](#directorystructure)

### public/static/

- this folder is unecessary besides avoid route collision
- static/components/ should be renamed static-components ?

[top](#directorystructure)

### public/static/components/

- all widgets live here

[top](#directorystructure)

### public/static/components/:widget-name/

- :widget-name is a placeholder for the name of the widget
- a particular widget lives here

[top](#directorystructure)

### public/static/components/:widget-name/index.html

- required
- The index file displays in the Widget Garden.

[top](#directorystructure)

### public/static/components/:widget-name/edit.html

- required
- The edit file displays in the Client Hub when configuring a widget.
- Liquid may be used in this file.

[top](#directorystructure)

### public/static/components/:widget-name/show.html

- required
- The show file displays in the Client Hub when previewing widget.
- Liquid may be used in this file.
- No javascript is allowed in this file.
- JSON is allowed in this file.
- No styles are allowed in this file.

[top](#directorystructure)

### public/static/components/:widget-name/images/

- requred
- Every widget should have `thumbnail.png` and any other images used in the
widget show.

[top](#directorystructure)

### public/static/components/:widget-name/images/thumbnail.png

- The thumbnail is displayed in the Client Hub when selecting widgets.

[top](#directorystructure)

### public/static/components/:widget-name/images/:custom.png

- :custom is a placeholder for the name of an image
- A widget may have many other custom images

[top](#directorystructure)

### public/static/components/:widget-name/javascripts/

- javascripts written custom for this widget live here

[top](#directorystructure)

### public/static/components/:widget-name/javascripts/edit.js

- optional
- Do not edit!
- this file is generated with a grunt task that compiles the contents of edit/

[top](#directorystructure)

### public/static/components/:widget-name/javascripts/edit/

- optional
- files will be included in alphabetical order

[top](#directorystructure)

### public/static/components/:widget-name/javascripts/edit/:custom.js.coffee

- optional
- :custom is a placeholder for the name of a js file
- a widget may have many custom javascripts

[top](#directorystructure)

### public/static/components/:widget-name/javascripts/show.js

- optional
- Do not edit!

[top](#directorystructure)

### public/static/components/:widget-name/javascripts/show/

- optional
- files will be included in alphabetical order

[top](#directorystructure)

### public/static/components/:widget-name/javascripts/show/:custom.js.coffee

- optional
- :custom is a placeholder for the name of a js file
- a widget may have many custom javascripts

[top](#directorystructure)

### public/static/components/:widget-name/stylesheets/

- optional
- Stylesheets used in the widget show.
- files will be included in alphabetical order

[top](#directorystructure)

### public/static/components/:widget-name/stylesheets/:custom.css
