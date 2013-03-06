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

      if _(data).isArray()
        dfd.resolve( data )
      else if _(data).isString()
        $.ajax({url:data}).done( (data)=>
          dfd.resolve( @options.parse( data ) )
        ).fail(=>
          dfd.reject()
        )
      else
        dfd.reject()

      dfd.promise()

    parse:(data)->
      data

  window.MapList = MapList
