# Creating a Widget

## Overview

A widget is a directory located at `public/static/components/:widget-name`
where :widget-name is the name of the widget, downcased and dashed. More
information about the contents of this directory is below.

    public/
      javascripts/
        javascript-library.js
      static/
        components/
          :widget-name/
            index.html
            edit.html
            show.html
            images/
              thumbnail.png
            javascripts/
              edit/
                custom-javascript.js.coffee
              show/
                custom-javascript.js.coffee
            stylesheets/
              custom-stylesheet.css.scss

## HTML Files

### index.html - required

- The index file displays in the Widget Garden.

### edit.html - optional

- The edit file displays in the Client Hub when configuring a widget.
- Liquid may be used in this file.

### show.html - required

- The show file displays in the Client Hub when previewing widget.
- Liquid may be used in this file.
- No javascript is allowed in this file.
- JSON is allowed in this file.
- No styles are allowed in this file.

## images/ - requred

Every widget should have `thumbnail.png` and any other images used in the
widget show.

## stylesheets/ - optional

Stylesheets used in the widget show.

## Javascripts


### /public/lib/javascripts - optional

### javascripts/edit.js - optional

Do not edit!

### javascripts/edit/ - optional

### javascripts/show.js - optional

Do not edit!

### javascripts/show/ - optional
