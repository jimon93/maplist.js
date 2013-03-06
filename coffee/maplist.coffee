do ($=jQuery)->
  class MapList
    default: => {
      center                 : new google.maps.LatLng( 135, 35 )
      zoom                   : 8
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

    parse:->

  window.MapList = MapList
