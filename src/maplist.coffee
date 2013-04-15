###
MapList JavaScript Library v1.2.9
http://github.com/jimon93/maplist.js

Require Library
  jquery.js
  jquery.tmpl.js
  underscore.js

MIT License
###
do ($=jQuery,global=this)->
  log = _.bind( console.log, console )
  class App #{{{
    default: => { #{{{
      lat              : 35
      lng              : 135
      #center          : null #new google.maps.LatLng( 35, 135 )
      zoom             : 4
      mapTypeId        : google.maps.MapTypeId.ROADMAP
      data             : []
      mapSelector      : '#map_canvas'
      listSelector     : '#list'
      listTemplate     : null
      infoTemplate     : null
      openInfoSelector : '.open-info'
      #genreAlias       : 'genre'
      genresSelector   : '#genre'
      genreSelector    : 'a'
      genreDataName    : "target-genre"
      firstGenre       : '__all__'
      infoOpened       : null
      beforeBuild      : null
      afterBuild       : null
      beforeClear      : null
      afterClear       : null
      doFit            : true
      fitZoomReset     : false
      templateEngine   : $.tmpl || _.template
    }
    #}}}
    constructor:(options)->
      _.bindAll(@)
      @options = @makeOptions(options)
      @mapView = new MapView(@options)
      @listView = new ListView(@options)
      @genresView = new GenresView(@options)
      source = Entries.getSource(@options.data, @options.parser)
      $.when( @map, source ).then (map,models)=>
        @entries = new Entries(models, @options)
        @delegateEvents()
        @rebuild( @options.firstGenre )

    makeOptions:(options)->
      options = _.extend( {}, _(@).result('default'), options )
      center = {
        center : new google.maps.LatLng( options.lat, options.lng )
      }
      templates = {
        infoHtmlFactory : new HtmlFactory(options.templateEngine, options.infoTemplate)
        listHtmlFactory : new HtmlFactory(options.templateEngine, options.listTemplate)
      }
      _.extend( center, options, templates )

    delegateEvents:->
      @entries.on "select", (entries)=>
        @mapView .build(entries)
        @listView.build(entries)

      @entries.on "unselect", (entries)=>
        @mapView .clear(entries)
        @listView.clear(entries)

      @entries.on "openinfo", (entry)=>
        @mapView.openInfo(entry.info, entry.marker)

      @genresView.on "change:genre", (genreId)=>
        @rebuild(genreId)

    # 地図とリストを構築する
    build:(genreId)->
      @options.beforeBuild?(genreId)
      @entries.select(genreId)
      @options.afterBuild?(genreId, @entries.selected())

    # 地図とリストを初期化する
    clear:->
      @options.beforeClear?()
      @entries.unselect()
      @options.afterClear?()

    # 地図とリストを初期化して，構築する
    rebuild:(genreId)->
      @clear()
      @build(genreId)

    # map objectを取得
    getMap:->
      return @mapView.map
  #}}}
  class Parser #{{{
    constructor:( @parser )->
      _.bindAll(@)
      @parser = Parser.defaultParser unless @parser?

    execute:(data)->
      if _.isFunction(@parser)
        @parser(data)
      else if @parser.execute?
        @parser.execute(data)
      else
        throw "parser is function or on object with the execute method"

    @defaultParser:(data)->
      if $.isXMLDoc(data)
        parser = new Parser.XMLParser
        parser.execute(data)
      else if _.isObject(data)
        parser = new Parser.ObjectParser
        parser.execute(data)
      else
        throw "Illegal Argument Error"

  class Parser.XMLParser
    default: ->{
      place: "place"
      genre: "genre"
    }

    constructor: (options)->
      _.bindAll(@)
      @options = _.extend( {}, _(@).result('default'), options)

    execute: (data)->
      $root = $(">*", data).eq(0)
      ( @makePlace( $(place) ) for place in $root.find(@options.place).get() )

    makePlace:($place)->
      _({}).chain()
        .extend( @getGenre($place), @getContent($place), @getAttribute($place) )
        .tap( (obj)->
          obj.lat = obj.latitude  if not obj.lat? and obj.latitude?
          obj.lng = obj.longitude if not obj.lng? and obj.longitude?
        ).omit("latitude","longitude").value()

    getGenre:($place)->
      $genre = $place.closest(@options.genre)
      if $genre.size() == 1
        _(@getAttribute($genre)).chain().tap((obj)->
          obj.genre     = obj.id   if obj.id?
          obj.genreName = obj.name if obj.name?
        ).omit("id","name").value()
      else
        {}

    getContent:($place)->
      res = {}
      for elem in $place.children().get()
        res[elem.nodeName.toLowerCase()] = $(elem).text()
      return res

    getAttribute:($place)->
      res = {}
      for attr in $place.get(0).attributes when attr != "id" and attr != "name"
        res[attr.name] = attr.value
      return res

  class Parser.ObjectParser
    execute: (data)->
      data
  #}}}
  class Entry extends Backbone.Model #{{{
    initialize: (attributes, options)->
      _.bindAll(@)
      @info   = @makeInfo(options.infoHtmlFactory)
      @marker = @makeMarker()
      @list   = @makeList(options.listHtmlFactory)

    openInfo:->
      @trigger('openinfo', @)

    makeInfo:(infoHtmlFactory)->
      content = infoHtmlFactory.make( @toJSON() )
      if content?
        info = new google.maps.InfoWindow {content}
        google.maps.event.addListener( info, 'closeclick', @openInfo )
        return info

    makeMarker:->
      position = new google.maps.LatLng( @get('lat'), @get('lng') )
      marker = new google.maps.Marker { position, icon: @get('icon'), shadow: @get('shadow') }
      google.maps.event.addListener( marker, 'click', @openInfo ) if @info?
      return marker

    makeList:(listHtmlFactory)->
      content = listHtmlFactory.make( @toJSON() )
      if content?
        $(content).addClass("__list").data("entry",@)

    isSelect:(genreId)->
      false unless @get('lat')? and @get('lng')?
      switch genreId
        when "__all__" then true
        else genreId == @attributes.genre
  #}}}
  class Entries extends Backbone.Collection #{{{
    model: Entry

    initialize:(source, options)->
      _.bindAll(@)
      @selectedList = []

    select: ( prop )->
      iterator = (entry) => entry.isSelect(prop)
      @selectedList = _(super iterator).tap (entries)=>
        @trigger("select", entries)

    unselect: ->
      @trigger("unselect", @selected())
      @filterdList = []

    selected: ->
      @selectedList

    # 長くてださい
    @getSource: (data, parser)->
      parser = new Parser(parser)
      dfd = new $.Deferred
      if _.isArray(data)
        dfd.resolve(data)
      else if _.isString(data)
        $.ajax({url:data}).then(
         (data)=> dfd.resolve( parser.execute(data) )
         ()=> dfd.reject()
        )
      else
        dfd.reject()
      dfd.promise()
  #}}}
  class HtmlFactory #{{{
    constructor:(@templateEngine, @template)->
      switch @getTemplateEngineName()
        when "_.template"
          @engine = @templateEngine(@template)
        when "$.tmpl"
          @template = "<wrap>#{@template}</wrap>"
          @engine = _.bind( @templateEngine, @, @template )
        else
          @engine = _.bind( @templateEngine, @, @template )

    make:(object)->
      return null unless @templateEngine? and @template?
      res = @engine(object)
      res = res.html() if res.html?
      return res

    getTemplateEngineName:->
      if _?.template? and _.template == @templateEngine
        "_.template"
      else if $?.tmpl? and $.tmpl == @templateEngine
        "$.tmpl"
      else
        "other"
  #}}}
  class MapView extends Backbone.View # info and marker {{{
    initialize: ->
      _.bindAll(@)
      canvas = $(@options.mapSelector).get(0)
      @map = new google.maps.Map( canvas, @options )

    # 構築
    # マーカー，インフォ，リストを構築
    build:(entries)->
      bounds = new google.maps.LatLngBounds if @options.doFit
      for entry in entries
        entry.marker.setMap(@map)
        bounds.extend( entry.marker.getPosition() ) if @options.doFit
      if @options.doFit
        unless @options.fitZoomReset
          @map.fitBounds( bounds )
        else
          @map.setCenter( bounds.getCenter() )
          @map.setZoom( @options.zoom )

    # マーカー, インフォ, リストを消す
    clear:(entries)->
      @closeOpenedInfo()
      for entry in entries
        entry.marker.setMap(null)

    openInfo:(info,marker)->
      @closeOpenedInfo()
      info.open(@map,marker)
      @openedInfo = info
      @options.infoOpened?(marker,info)

    closeOpenedInfo:->
      if @openedInfo?
        @openedInfo.close()
        @openedInfo = null
  #}}}
  class ListView extends Backbone.View #{{{
    initialize:->
      @$el = $(@options.listSelector)
      @$el.on( "click", @options.openInfoSelector, @openInfo )

    build:(entries)->
      for entry in entries
        entry.list?.appendTo(@$el)

    clear:(entries)->
      for entry in entries
        entry.list?.detach()

    openInfo:(e)->
      $target = $(e.currentTarget)
      $target.closest(".__list").data("entry").openInfo()
      return false
  #}}}
  class GenresView extends Backbone.View #{{{
    initialize:->
      # event
      _.bindAll(@)
      @$el = $(@options.genresSelector)
      @$el.on( "click", @options.genreSelector, @selectGenre )

    selectGenre:(e, genreId)->
      unless genreId?
        $target = $(e.currentTarget)
        genreId = $target.data( @options.genreDataName )
      @trigger("change:genre",genreId)
      return false
  #}}}

  global.MapList = _.extend App, {
    Parser
    Entry
    Entries
    HtmlFactory
    MapView
    ListView
    GenresView
  }
