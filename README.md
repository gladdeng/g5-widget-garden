# G5 Widget Garden

A garden of widgets that can be used in client location sites. Uses the [g5_component_garden](https://github.com/g5search/g5_component_garden) to generate components from `public/static/components` and provide routes.


## Setup

1. Install all the required gems
```bash
bundle
```

2. Install all the required node dependencies.
```bash
npm install
```

## Grunt Task

You will need to run the Gruntfile tasks in order to compile and concat the widget javascripts.

It can be ran one-off via
```bash
grunt
```

or you can watch the directory for changes (changes, additions and deletions) via
```bash
grunt watch
```

The Gruntfile is watching *.js & *.js.coffee files under public/static/components/*/javascripts/{show, edit}/. When being ran one-off or watched, the Gruntfile will:

1. Run a coffee task - compile the *.js.coffee files from public/static/components/*/javascripts/{show, edit}/ into *.compiled.js in the same directory
1. Run a concat task - concat *.js and *.compiled.js files into public/static/components/*/javascripts/ as either show.js or edit.js (depending on which folder it's coming from)
1. Run a clean task - remove *.compiled.js files from public/static/components/*/javascripts/{show, edit}/

## Authors

  * Jessica Lynn Suttles / [@jlsuttles](https://github.com/jlsuttles)
  * Bookis Smuin / [@bookis](https://github.com/bookis)
  * Jessica Dillon / [@jessicard](https://github.com/jessicard)
  * Chad Crissman / [@crissmancd](https://github.com/crissmancd)

## Contributing

1. Fork it
1. Get it running
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Write your code and **specs**
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/g5search/g5-widget-garden/issues).

## Specs

```bash
guard
```
