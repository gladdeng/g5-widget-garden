$ ->
  # Get walkscore config options
  walkFeedVars = JSON.parse($("#walkscore-config:first").html())

  # Walkscore Setup
  if walkFeedVars.walkscore_client.length > 1
    walkscoreFeed = new walkscoreInitializer(walkFeedVars)

# WALKSCORE UTILITIES
# *******************
class walkscoreInitializer
  constructor: (walkFeedVars) ->
    return getpage walkFeedVars
    
  getpage = (walkFeedVars) ->
    $.ajax
      #url: "//g5-social-feed-service.herokuapp.com/walkscore-feed/#{walkFeedVars.walkscore_client}/#{walkFeedVars.walkscore_location}"
      url: "http://localhost:3008/walkscore-feed/#{walkFeedVars.walkscore_client}/#{walkFeedVars.walkscore_location}"
      dataType: 'json'
      success: (data) =>
        #console.log(JSON.stringify(data))
        #walkscoreBadgeBuilder(walkFeedVars, data) if data.length > 0
        walkscoreBadgeBuilder(data)


walkscoreBadgeBuilder = (dataFeed) ->
  walkscoreBlock = """<a href="#{dataFeed.ws_link}" target="_blank">
                       <img src="#{dataFeed.logo_url}" alt="Walkscore Logo"/>
                         <span>#{dataFeed.walkscore}</span>
                      </a>
                  """
  $('.walkscore-listing').append(walkscoreBlock)