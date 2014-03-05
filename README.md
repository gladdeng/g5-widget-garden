# G5 Widget Garden

[![Build Status](https://travis-ci.org/G5/g5-widget-garden.png?branch=master)](https://travis-ci.org/G5/g5-widget-garden)
[![Code Climate](https://codeclimate.com/repos/530e8e8ce30ba005cb00272e/badges/5d8d2116d20f27e82639/gpa.png)](https://codeclimate.com/repos/530e8e8ce30ba005cb00272e/feed)

A garden of widgets that can be used in client location sites.


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
[file an issue](https://github.com/G5/g5-widget-garden/issues).

## Specs

```bash
bundle exec rspec
```

## License

Copyright (c) 2013 G5

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
