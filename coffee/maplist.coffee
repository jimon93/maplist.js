do ($=jQuery)->
  log = _.bind( console.log, console )
  class MapList
    default: => {
      center                 : new google.maps.LatLng( 35, 135 )
      zoom                   : 4
      mapTypeId              : google.maps.MapTypeId.ROADMAP
      data                   : []
      mapSelector            : '#map_canvas'
      listSelector           : ''
      listTemplate           : ''
      infoTemplate           : ''
      listToMarkerSelector   : ''
      genreAlias             : 'genre'
      genreContainerSelector : ''
      genreSelector          : ''
      firstGenre             : '__all__'
      parse                  : @parse
    }

    constructor:(options)->
      _.bindAll(@)
      @options = _.extend( {}, _(@).result('default'), options )
      @makeMap()
      @entries = @getEntries()
      @entries.then =>
        @build( @options.firstGenre )

    build:(genreId)->
      @entries.then (entries)=>
        @usingEntries = @filterdEntries(genreId,entries)
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

    getEntries:->
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

    filterdEntries:(genreId, entries)->
      entries

    getEntryData:(entry)->
      info     = entry.__info     ? entry.__info     = @makeInfo( entry )
      marker   = entry.__marker   ? entry.__marker   = @makeMarker( entry, info )
      listElem = entry.__listElem ? entry.__listElem = @makeListElem( entry, info, marker )
      return [info,marker,listElem]



    makeInfo:->
      null

    makeMarker:(entry, info)->
      log "makeMarker"
      position = new google.maps.LatLng( entry.lat, entry.lng )
      marker = new google.maps.Marker { position, icon: entry.icon }

    makeListElem:->

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

  window.MapList = MapList
