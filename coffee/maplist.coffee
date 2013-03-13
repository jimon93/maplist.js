do ($=jQuery)->
  log = _.bind( console.log, console )
  class MapList
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
      @makeMap()
      @entries = new Data(_.clone @options)
      @entries.then =>
        @build( @options.firstGenre )

    build:(genreId)->
      @entries.filterdThen genreId, (@usingEntries)=>
        for entry in @usingEntries
          [info,marker,listElem] = @getEntryData(entry)
          marker.setMap(@map)

    clear:->
      #marker.setMap(null)

    rebuild:(genreId)->
      @clear()
      @build(genreId)

    # private
    #--------------------------------------------------
    makeMap:->
      mapOptions = _(@options).clone()
      canvas = $(@options.mapSelector).get(0)
      @map = new google.maps.Map( canvas, mapOptions )

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
        $content.appendTo $(@options.listSelector)

    openInfoFunc:(marker,info)->
      (e)=>
        log "openInfo",@,@openInfo
        @openInfo.close() if @openInfo?
        info.open(@map, marker)
        @openInfo = info
        @toMapScroll()

    makeHTML:(template, entry)->
      if template? then $.tmpl( template, entry ) else null

    toMapScroll:->
      top = $(@options.mapSelector).offset().top
      $('html,body').animate({ scrollTop: top }, 'fast');

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
  window.MapList = MapList
