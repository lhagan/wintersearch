wintersearch
============

wintersearch is a simple full-text search engine for [wintersmith](https://github.com/jnordberg/wintersmith), a static website generator written for node.js.

Install
-------

    npm install -g git://github.com/lhagan/wintersearch.git

Usage
------

To start, clone this repo or otherwise download the [example](https://github.com/lhagan/wintersearch/tree/master/example). Then, from within the `example` folder, run

    wintersearch preview
    
...and visit <http://localhost:8000/search.html>. You'll see a modified version of the wintersmith blog template and a functional instant search box.

To use wintersearch on a live webserver, run `wintersearch` from within your project folder to start the search engine (you'll probably want to use some kind of mechanism to ensure that it stays running constantly). In order to access the server from the web, configure a reverse proxy to wintersearch on port 3000. Here's an example for [lighttpd](http://www.lighttpd.net):

    $HTTP["url"] =~ "/search/" {
    	proxy.server = ( "" => ( ( "host" => "127.0.0.1", "port" => 3000 ) ) )
    }
    
The server only indexes content upon startup, so you'll need to restart it after making a change to the site content in order to index the new text.

How it works
------------

`wintersearch preview` launches the wintersmith preview server on port 8080, the wintersearch engine on port 3000, and starts a proxy server on port 8000. This allows you to test your wintersmith site and the wintersearch engine simultaneously. `wintersearch` just starts the wintersearch engine on port 3000.

_Note: at the moment, these port numbers are hard-coded but these will configurable in the future._

wintersearch is made possible by a bunch of great projects:

* [wintersmith](https://github.com/jnordberg/wintersmith): static site generator
* [express.js](http://expressjs.com): web application framework that serves the search engine
* [node-http-proxy](https://github.com/nodejitsu/node-http-proxy): proxies the wintersmith and wintersearch servers onto a single port for testing in preview mode
* [natural](https://github.com/NaturalNode/natural): tokenizes/stems contents and search terms
* [query-engine](https://github.com/bevry/query-engine): the search engine backend
* [underscore](http://underscorejs.org): filters wintersmith articles
