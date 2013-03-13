do ($=jQuery)->
  log = _.bind( console.log, console )
  class Facade
    default: => {
      center                 : new google.maps.LatLng( 35, 135 )
      zoom                   : 4
      mapTypeId              : google.maps.MapTypeId.ROADMAP
      data                   : []
      mapSelector            : '#map_canvas'
      listSelector           : '#list'
      listTemplate           : null
      infoTemplate           : null
      listToMarkerSelector   : '.open-info'
      genreAlias             : 'genre'
      genreContainerSelector : '#genre'
      genreSelector          : ''
      firstGenre             : '__all__'
    }

    constructor:(options)->
      _.bindAll(@)
      @options = _.extend( {}, _(@).result('default'), options)
      @entries = new Data(_.clone @options)
      @maplist = new MapList(_.clone @options)
      @entries.then =>
        @build( @options.firstGenre )

      # event
      $(@options.genreContainerSelector).on "click", @options.genreSelector, @changeGenre

    changeGenre:(e)->

    build:(genreId)->
      @entries.filterdThen genreId, (@usingEntries)=>
        @maplist.build(@usingEntries)

    clear:->
      #marker.setMap(null)

    rebuild:(genreId)->
      @clear()
      @build(genreId)

    # private
    #--------------------------------------------------
  class Data #{{{
    constructor:(@options)->
      _.bindAll(@)
      parser = new Parser(_.clone @options)
      @options = _.extend( {parse:parser.parse}, @options)
      @entries = @_makeEntries()

    then:(done,fail)->
      @entries.then(done,fail)

    filterdThen:(genreId,done,fail)->
      @entries.then(
        (entries)=>done(@_filterdEntries genreId, entries)
        (e)=>fail(e)
      )

    # private #{{{
    #--------------------------------------------------
    _makeEntries:->
      dfd = new $.Deferred
      data = @options.data
      if _.isArray(data)
        dfd.resolve( data )
      else if _.isString(data)
        $.ajax({url:data}).done( (data)=>
          dfd.resolve( @options.parse( data ) )
        ).fail(=>
          dfd.reject()
        )
      else
        dfd.reject()
      dfd.promise()

    _filterdEntries:(genreId, entries)->
      if genreId == "__all__"
        entries
      else
        alias = @options.genreAlias
        (entry for entry in entries when entry[alias] is genreId)

    #}}}
  #}}}
  class Parser #{{{
    constructor:(@options)->
      _.bindAll(@)

    parse:(data)->
      if $.isXMLDoc(data)
        @_parseForXML( data )
      else if _.isObject(data)
        @_parseForObject( data )
      else
        data

    _parseForXML:(data)->
      $root = $(">*:first", data)
      alias = @options.genreAlias
      $.map $root.find(">#{alias}"), (genre)=>
        $genre = $(genre)
        genre = { "icon" : $genre.attr("icon") }
        genre["#{alias}"] = $genre.attr("id")
        genre["#{alias}Name"] = $genre.attr("name")
        $.map $genre.find(">place"), (place)=>
          $place = $(place)
          res = {} # reduceでやりたい
          $place.children().each (idx,elem)=>
            res[elem.nodeName] = $(elem).text()
          position = { lat: $place.attr('latitude'), lng: $place.attr('longitude') }
          return _.extend( {}, genre, position, res )

    _parseForObject:(data)->
      data
  #}}}
  class MapList
    constructor:(@options)->
      _.bindAll(@)
      mapOptions = _(@options).clone()
      canvas = $(@options.mapSelector).get(0)
      @map = new google.maps.Map( canvas, mapOptions )

    build:(entries)->
      for entry in entries
        [info,marker,listElem] = @getEntryData(entry)
        marker.setMap(@map)
        listElem.appendTo $(@options.listSelector)

    getEntryData:(entry)->
      info     = entry.__info     ? entry.__info     = @makeInfo( entry )
      marker   = entry.__marker   ? entry.__marker   = @makeMarker( entry, info )
      listElem = entry.__listElem ? entry.__listElem = @makeListElem( entry, marker, info )
      return [info,marker,listElem]

    makeInfo:(entry)->
      content = @makeHTML @options.infoTemplate, entry
      if content?
        content = $( content ).html()
        info = new google.maps.InfoWindow {content}
        google.maps.event.addListener info, 'closeclick', =>
          @openInfo = null
        return info
      else
        return null

    makeMarker:(entry,info)->
      position = new google.maps.LatLng( entry.lat, entry.lng )
      marker = new google.maps.Marker { position, icon: entry.icon }
      google.maps.event.addListener( marker, 'click', @openInfoFunc(marker,info) ) if info
      return marker

    makeListElem:(entry,marker,info)->
      content = @makeHTML @options.listTemplate, entry
      if content?
        $content = $(content)
        if @options.listToMarkerSelector?
          $content.on( "click", @options.listToMarkerSelector, @openInfoFunc(marker,info) )
        $content.data @options.genreAlias, entry[@options.genreAlias]
        return $content
      else
        return null

    openInfoFunc:(marker,info)->
      (e)=>
        @openInfo.close() if @openInfo?
        info.open(@map, marker)
        @openInfo = info
        @toMapScroll()

    makeHTML:(template, entry)->
      if template? then $.tmpl( template, entry ) else null

    toMapScroll:->
      top = $(@options.mapSelector).offset().top
      $('html,body').animate({ scrollTop: top }, 'fast');

  window.MapList = Facade
