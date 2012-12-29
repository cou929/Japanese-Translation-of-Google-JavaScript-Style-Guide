# Unoficial Japanese translation of Google JavaScript Style Guilde

Unoficial Japanese translation of [Google JavaScript Style Guilde](http://google-styleguide.googlecode.com/svn/trunk/javascriptguide.xml).

[The translation](http://cou929.nu/data/google_javascript_style_guide/)

## Build document

    $ sh tools/doc_builder.sh

## Tools

- tools/doc_builder.sh
  - Build document and put html to www dir. Support `__badcode__` anotation.
- tools/monitor.sample.sh
  - Sample one liner to monitor changes of original Google JavaScript Style Guide Document. You can set this up to crontab.
- tools/notation_checker.py
  - Check and notify notation difference (such as `ください` and `下さい`).

## Dependencies

- [Sphinx](http://sphinxsearch.com/)
- [MeCab](http://mecab.googlecode.com/svn/trunk/mecab/doc/index.html)
