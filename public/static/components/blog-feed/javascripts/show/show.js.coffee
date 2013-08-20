$ ->
  blogVars = JSON.parse($('#blog-feed-config:first').html())
  blogConfig = new window.BlogConfig(blogVars)

  new window.BlogInterface($("#blog-feed-container ul"), blogConfig)

class window.BlogConfig
  constructor: (config) ->
    {@feedUrl, @feedTitle, @showAuthor, @showEntrySummary, @showDate, @entriesToShow} = config

class BlogFetcher
  constructor: (@url) ->

  fetch: ->
    $.ajax
      url: 'http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=3&callback=?&q=' + encodeURIComponent(@url)
      dataType: 'json'
      success: (data) =>
        @feed = data.responseData.feed
        $(this).trigger("feedReady")

class window.BlogInterface
  constructor: (@list, @config) ->
    fetcher = new BlogFetcher(@config.feedUrl)
    $(fetcher).bind("feedReady", (event) => @updateDom(event))
    fetcher.fetch()

   updateDom: (event) ->
     feed = event.currentTarget.feed
     @list.before("<h2 class=\"title\">#{@config.feedTitle}</h2>") if @config.feedTitle?
     for entry in feed.entries
       jli = $('<li class="h-entry">')
       innerText = "<a class='p-name p-url' href=\"#{entry.link}\" target=\"_blank\">#{entry.title}</a><br />"
       innerText += "<span class=\"dt-published date\">#{@formatDate(entry.publishedDate)}</span>" if @config.showDate
       innerText += "<div class='p-summary'>#{entry.contentSnippet}</div>" if @config.showEntrySummary
       innerText += "<div class='p-author'>Posted By: #{entry.author}</div>" if @config.showAuthor
       jli.append(innerText)
       @list.append(jli)

  formatDate: (postDate) ->
    date = new Date(Date.parse(postDate))
    day = date.getDate()
    month = date.getMonth()
    year = date.getFullYear()
    "#{day}/#{month}/#{year}"