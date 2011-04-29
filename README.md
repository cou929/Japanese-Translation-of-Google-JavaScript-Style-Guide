Unoficial Japanese translation of Google JavaScript Style Guilde
=====================================================================

This is unoficial Japanese translation of [Google JavaScript Style Guilde](http://google-styleguide.googlecode.com/svn/trunk/javascriptguide.xml).

Using sphinx to build rst to html. 

And [document is here](http://cou929.nu/data/google_javascript_style_guide/)

Files
---------------------------------------------------------------------

.
|-- doc                          : contains translated document
|   `-- index.rst                : main file of translation
|
|-- monitor                      : contains scrirpt which monitors original document
|   |-- repo_monitor.sh          : script which monitors original document and notifies if there was change
|
`-- synchronizer
    |-- post_recieve_server.js   : Small server script which listen "Post-Receiveb Hook" from github and then invoke doc_builder.sh
    `-- doc_builder.sh           : pull document from github, build it with sphinx and deploy the document.

Dependencies
---------------------------------------------------------------------

- [Node.js 0.4+](http://nodejs.org/)
- [express](http://expressjs.com/)
- [Sphinx](http://sphinxsearch.com/)

Author
---------------------------------------------------------------------

Kosei Moriyama <cou929@gmail.com>