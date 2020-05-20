# Unoficial Japanese translation of Google JavaScript Style Guilde

[![Build Status](https://travis-ci.org/cou929/Japanese-Translation-of-Google-JavaScript-Style-Guide.svg?branch=master)](https://travis-ci.org/cou929/Japanese-Translation-of-Google-JavaScript-Style-Guide)

Unoficial Japanese translation of [Google JavaScript Style Guilde](http://google-styleguide.googlecode.com/svn/trunk/javascriptguide.xml).

[The translation](http://cou929.nu/data/google_javascript_style_guide/)

## Build document

    $ make html

## Tools

- tools/monitor.sample.sh
  - Sample one liner to monitor changes of original Google JavaScript Style Guide Document. You can set this up to crontab.
- tools/notation_checker.py
  - Check and notify notation difference (such as `ください` and `下さい`).

## Dependencies

- [Sphinx](http://sphinxsearch.com/)
- [MeCab](http://mecab.googlecode.com/svn/trunk/mecab/doc/index.html)

## Deploy

Keys are inactivated currently.
You must sync _build/html manually.
See .travis.yml
