wintersmith = require 'wintersmith'
_ = require('underscore')._
natural = require 'natural'

get_articles = (callback) ->
    wintersmith.loadContents "./contents", (error, contents) ->
        natural.PorterStemmer.attach()
        articles = []
        scan = (item) ->
            _.chain(item._.directories).each (subitem) ->
                node = subitem.index
                if node and node.title
                    console.log node.url
                    articles.push
                        title: node.title
                        title_token: node.title.tokenizeAndStem().join(" ")
                        url: node.url
                        body: node._content.tokenizeAndStem().join(" ")
                scan subitem if item

        directories = _.chain(contents._.directories)
        pages = directories.each((item) ->
            scan item
        )
        
        callback(articles)

module.exports = get_articles
