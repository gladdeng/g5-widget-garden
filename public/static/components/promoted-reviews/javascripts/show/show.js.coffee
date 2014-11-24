$ ->
  config = JSON.parse($('#promoted-reviews-config').html())
  feedSource = new ReviewFeedSource(config.review_api_url)

  if config.full_review_content
    $(feedSource).bind("feedReady", (event) =>
      new ReviewTemplater(config.branded_name).update(feedSource.feed))
  else 
    targetElement = if config.insert_review_schema == "" then ".contact-info" else config.insert_review_schema
    $(feedSource).bind("feedReady", (event) =>
      new BusinessSchemaUpdater(targetElement, config.review_page_url).update(feedSource.feed))
  
  feedSource.getFeed()

class ReviewFeedSource
  constructor: (@url) ->
    
  getFeed: ->
    if @feedFromStorage()
      $(this).trigger("feedReady")
    else
      @fetch()

  fetch: ->
    $.ajax
      url: @url
      dataType: 'json'
      success: (data, status, xhr) =>
        @feed = data
        @storeFeed()
        $(this).trigger("feedReady")
      error: (xhr, status, error) =>
        alert("Review API URL not configured") if !@url

  feedFromStorage: ->
    try
      @feed = JSON.parse(sessionStorage.getItem(@url))
    catch
      null

  storeFeed: ->
    try
      sessionStorage.setItem(@url, JSON.stringify(@feed))
    catch
      null

class BusinessSchemaUpdater
  # Looks for specifed element (usually .contact-info), and inserts a link to the reviews page
  constructor: (@insert_review_schema, @review_page_url) ->

  update: (feed) ->
    $(@insert_review_schema).append(@schemaTemplate(feed.location))

  schemaTemplate: (location) ->
    """
    <div itemprop="aggregateRating" itemscope itemtype="http://schema.org/AggregateRating" class="rating">
      <span itemprop="ratingValue" class="average-rating">#{location.average_rating} stars</span>
      <a href="#{@review_page_url}" class="total-reviews">
        <span itemprop="reviewCount">(#{location.review_count} reviews)</span>
      </a>
      <span class="gold-stars" style="width:#{Math.round(location.average_rating * 16)}px;"></span>
    </div>
    """

class ReviewTemplater
  # Generates the full review markup
  constructor: (@branded_name) ->

  update: (feed) ->
    $('#promoted-reviews').append(@reviewTemplate(feed.location, review)) for review in feed.reviews

  reviewTemplate: (location, review) ->
    """
    <div itemscope itemtype="http://schema.org/Review" itemprop="review" class="review">
      <div itemprop="reviewBody" class="review-body">#{review.excerpt}</div>
      <div itemprop="itemreviewed">#{@branded_name}</div>
      <div itemprop="author" itemscope itemtype="http://schema.org/Person" class="author">
        Written by: <span itemprop="name">#{review.author}</span> 
        <span class="#{@classifyReputationSiteName(review.reputation_site_name)} via">
          via #{review.reputation_site_name}
        </span>
      </div>
      <div class="date">
        <meta itemprop="datePublished" content="#{review.date}">Date published: #{review.date}
      </div>
      <div itemprop="reviewRating" itemscope itemtype="http://schema.org/Rating" class="rating">
        <meta itemprop="worstRating" content="1"><span itemprop="ratingValue">#{review.rating}</span> / <span itemprop="bestRating">#{location.out_of}</span> stars
        <span class="gold-stars" style="width:#{Math.round(review.rating * 16)}px;"></span>
      </div>
    </div>
    """

  classifyReputationSiteName: (name) ->
    @lowercaseFirstChar(name).replace(/[^0-9a-z]/i, '')

  lowercaseFirstChar: (string) ->
    string.charAt(0).toLowerCase() + string.slice(1);