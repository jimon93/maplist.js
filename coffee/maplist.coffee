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
      @options = _.extend( _(@).result('default'), options )
      @makeMap()
      @entries = @getEntries()

      @entries.then (data)=>
        log data

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

    parse:(data)->
      if $.isXMLDoc(data)
        @parseForXML( data )
      else if _.isObject(data)
        @parseForObject( data )
      else
        data

    parseForXML:(data)->
      $root = $(">*:first", data)
      $.map $root.find(">genre"), (genre)=>
        $genre = $(genre)
        genre = {
          genre     : $genre.attr("id")
          genreName : $genre.attr("name")
          icon      : $genre.attr("icon")
        }
        $.map $genre.find(">place"), (place)=>
          $place = $(place)
          res = {} # reduceでやりたい
          $place.children().each (idx,elem)=>
            res[elem.nodeName] = $(elem).text()
          return _.extend( res, genre )

    parseForObject:(data)->
      data

  window.MapList = MapList
