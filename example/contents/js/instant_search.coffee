# based on Instant Search, part of the Habari project
# http://habariproject.org/en/
# Apache Licensed <http://www.apache.org/licenses/LICENSE-2.0>

InstantSearch =
  running: false
  request: null
  url: "/search/"
  old_search_term: ""
  init: ->
    # hook our ajax event when a key is released
    $("input#q").keyup ->
      InstantSearch.search $(this).val()
      
      # prevent the browser from doing anything
      false
    
    # also hook our ajax event when the instant search form is submitted (via button or 'enter')
    $("form#instant_search").submit (event) ->
      InstantSearch.search $("input#q").val()
      
      # prevent the browser from doing anything
      event.preventDefault()

  search: (search_term) ->
    # cancel any previous requests
    if InstantSearch.running
      InstantSearch.request.abort()
      InstantSearch.running = false
      
    # if the search is blank, there is no point in making a request, display the blank results
    if search_term is ""
      InstantSearch.show_results "", ""
      @old_search_term = search_term
    else
      # make sure the query actually changed and too short
      if search_term isnt @old_search_term and search_term.length >= 3
        @old_search_term = search_term
        @request = $.getJSON(@url,
          q: search_term
        , (data) ->
          InstantSearch.show_results data, search_term
        )

  show_results: (data, search_term) ->
    # the request has finished
    InstantSearch.running = false
    data_length = data.length
    
    # clear previous results
    $("#results").empty()
      
    if data_length > 0
      # build the html for this post
      list = $("<ul></ul>")
      $.each data, (i, item) ->
        list.append "<li><a href=\"" + item.url + "?q=" + search_term + "\">" + item.title + "</li>"

      $("#results").append list

$(document).ready ->
  InstantSearch.init()
  if window.location.search
    $('article').highlight(term) for term in $.url(window.location.search).param('q').split(' ')
  