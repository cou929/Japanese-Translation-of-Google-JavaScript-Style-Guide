Unoficial Japanese translation of Google JavaScript Style Guilde
=====================================================================

This is unoficial Japanese translation of [Google JavaScript Style Guilde](http://google-styleguide.googlecode.com/svn/trunk/javascriptguide.xml).

Using sphinx to build rst to html. 

And [document is here](http://cou929.nu/data/google_javascript_style_guide/)

How To Setup
---------------------------------------------------------------------

<pre>
$ sudo git clone git://github.com/cou929/Japanese-Translation-of-Google-JavaScript-Style-Guide.git /usr/local/share/google_javascript_style_guide
$ sudo chmod -R <user name> /usr/local/share/google_javascript_style_guide
$ cd monitor
$ svn checkout http://google-styleguide.googlecode.com/svn/trunk/ google-styleguide-read-only
$ crontab -e
   
     0 0 * * * /usr/local/share/google_javascript_style_guide/monitor/repo_monitor.sh 2>> /usr/local/share/google_javascript_style_guide/monitor/error.log
 
$ nohup node /usr/local/share/google_javascript_style_guide/synchonizer/post_receive_server.js &
</pre>

And set below url on github's Post-Receive URLs form:

>
> http://cou929.nu:1232/github/postreceive/
>

Files
---------------------------------------------------------------------

<pre>
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
</pre>

Dependencies
---------------------------------------------------------------------

- [Node.js 0.4+](http://nodejs.org/)
- [express](http://expressjs.com/)
- [Sphinx](http://sphinxsearch.com/)

Author
---------------------------------------------------------------------

Kosei Moriyama \<[cou929@gmail.com](mailto:cou929@gmail.com)\>
