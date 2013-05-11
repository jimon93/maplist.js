###
MapList JavaScript Library v1.4.11
http://github.com/jimon93/maplist.js

Require Library
  jquery.js
  jquery.tmpl.js
  underscore.js
  backbone.js

MIT License
###
do ($=jQuery,global=this)->
  log = (args...)-> console?.log?(args...)
  class App #{{{
    _.extend( @::, Backbone.Events )
    default:->{ #{{{
      # core
      data : []
      # Map Options
      mapSelector  : '#map_canvas'
      lat          : 35
      lng          : 135
      zoom         : 4
      mapTypeId    : google.maps.MapTypeId.ROADMAP
      canFitBounds : true
      fixedZoom    : false
      maxFitZoom   : 16
      # List Options
      listSelector : "#list"
      listTemplate : null
      openInfoSelector : '.open-info'
      # Info Options
      infoTemplate : null
      # Genres Options
      genresSelector : '#genre'
      genreSelector  : 'a'
      genreGroup     : "target-group"
      genreDataName  : "target-genre"
      firstGenre     : {}
      # general
      templateEngine : $.tmpl || _.template
      # parser
      parser : null
      afterParser : null
      xmlParserOptions: {}
    }

    #}}}
    constructor:(options,initFunc)->
      _.bindAll(@)

      @options    = @makeOptions(options)
      @mapView    = new MapView(@options)
      @listView   = new ListView(@options)
      @genresView = new GenresView(@options)
      @entries    = new Entries(null,@options)
      @properties = {}

      @delegateEvents()
      initFunc?( @ )
      @data(@options.data) if @options.data?

    @new:(options,initFunc)->
      App.create(options,initFunc)

    @create:(options,initFunc)->
      new App( options, initFunc )

    data:( data )->
      Entries
        .getSource(data, @options)
        .then (models)=> @entries.reset(models, @options)
      return @

    makeOptions:(options)->
      @extendOptions @extendDefaultOptions options

    extendDefaultOptions:(options = {})->
      options = _.extend( {}, _(@).result('default'), options )

    extendOptions:(options)->
      center = { center : new google.maps.LatLng( options.lat, options.lng ) }
      templates = {
        infoHtmlFactory : new HtmlFactory(options.templateEngine, options.infoTemplate)
        listHtmlFactory : new HtmlFactory(options.templateEngine, options.listTemplate)
      }
      _.extend( center, options, templates )

    delegateEvents:->
      @entries.on    "select"       , @build
      @entries.on    "unselect"     , @clear
      @entries.on    "openinfo"     , @openInfo
      @entries.on    "closeinfo"    , @closeInfo
      @genresView.on "change:genre" , @changeGenre
      return @

    # 地図とリストを構築する
    build:(entries)->
      prop = @entries.properties
      @trigger('beforeBuild',prop,entries)
      @options.beforeBuild?(prop,enrries) #Obsolete
      @mapView .build(entries)
      @listView.build(entries)
      @trigger('afterBuild',prop,entries)
      @options.afterBuild?(prop, entries) #Obsolete
      return @

    # 地図とリストを初期化する
    clear:->
      entries = @entries.selectedList
      @trigger("beforeClear",entries)
      @options.beforeClear?() #Obsolete
      @mapView .clear(entries)
      @listView.clear(entries)
      @trigger("afterClear",entries)
      @options.afterClear?() #Obsolete
      return @

    openInfo: (entry)->
      @trigger('openInfo',entry)
      @mapView.openInfo(entry.info, entry.marker)
      @trigger('openedInfo', entry)
      return @

    closeInfo: (entry)->
      @trigger('closeInfo',entry)
      @mapView.closeOpenedInfo()
      @trigger('closedInfo',entry)
      return @

    changeGenre: (key, val)->
      properties = {}
      if _.isUndefined val
        properties = _.omit( @properties, key )
      else
        properties[key] = val
        properties = _.extend( @properties, properties )
      @trigger('changeGenre', key, val)
      @changeProperties( properties )
      @trigger('changedGenre', key, val)
      return @

    changeProperties: (@properties)->
      @trigger('changeProperties', @properties)
      @rebuild( @properties )
      @trigger('changedProperties', @properties )
      return @

    # 地図とリストを初期化して，構築する
    rebuild:(prop)->
      @entries.unselect()
      @entries.select(prop)
      return @

    # map objectを取得
    getMap:->
      return @mapView.map

    getProperties:->
      return @properties
  #}}}
  class Parser #{{{
    constructor:( @options = {} )->
      _.bindAll(@)
      @parser = @options.parser || @defaultParser
      @afterParser = @options.afterParser

    execute:(data)->
      result = if _.isFunction(@parser)
        @parser(data)
      else if @parser.execute?
        @parser.execute(data)
      else
        throw "parser is function or on object with the execute method"
      result = @afterParser(result) if _.isFunction(@afterParser)
      result = @finallyParser(result)

    defaultParser:(data)->
      if $.isXMLDoc(data)
        parser = new Parser.XMLParser(@options.xmlParserOptions)
        parser.execute(data)
      else if _.isObject(data)
        parser = new Parser.ObjectParser
        parser.execute(data)
      else
        throw "Illegal Argument Error"

    finallyParser:(entries)->
      for entry in entries
        entry.icon = @makeIcon(entry.icon) if entry.icon?
        entry.shadow = @makeIcon(entry.shadow) if entry.shadow?
      entries

    makeIcon : (data)->
      if _.isObject(data)
        data = _.clone data
        for key, val of data
          switch key
            when "origin", "anchor"
              data[key] = new google.maps.Point(val[0],val[1])
            when "size", "scaledSize"
              data[key] = new google.maps.Size(val[0],val[1])
      return data
  #}}}
  class Parser.XMLParser #{{{
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
  #}}}
  class Parser.ObjectParser #{{{
    execute: (data)->
      data
  #}}}
  class Entry extends Backbone.Model #{{{
    initialize: (attributes, options)->
      _.bindAll(@)
      attributes ||= {}
      options ||= {}
      @isPoint = @getExistPoint()
      @info   = @makeInfo(options.infoHtmlFactory)
      @marker = @makeMarker()
      @list   = @makeList(options.listHtmlFactory)

    openInfo:->
      @trigger('openinfo', @)

    closeInfo:->
      @trigger('closeinfo', @)

    makeInfo:(infoHtmlFactory)->
      content = @get('__infoElement') || infoHtmlFactory.make( @toJSON() )
      if content? and !!content.replace(/\s/g,"")
        info = new google.maps.InfoWindow {content}
        google.maps.event.addListener( info, 'closeclick', @closeInfo )
        return info

    makeMarker:->
      position = new google.maps.LatLng( @get('lat'), @get('lng') )
      marker = new google.maps.Marker { position, icon: @get('icon'), shadow: @get('shadow') }
      google.maps.event.addListener( marker, 'click', @openInfo ) if @info?
      return marker

    makeList:(listHtmlFactory)->
      content = listHtmlFactory.make( @toJSON() )
      if content? and !!content.replace(/\s/g,"")
        $(content).addClass("__list").data("entry",@)

    getExistPoint:->
      latExist = @has('lat') and _.isFinite(parseFloat @get 'lat')
      lngExist = @has('lng') and _.isFinite(parseFloat @get 'lng')
      latExist and lngExist

    isSelect:(properties)->
      @isPoint and ( _.isEmpty(properties) or _([@toJSON()]).findWhere(properties)? ) ? true : false

  #}}}
  class Entries extends Backbone.Collection #{{{
    model: Entry

    initialize:(source, @options)->
      funcs = _(@).chain().functions().without("model").value()
      _(@).bindAll.apply(funcs)
      @selectedList = []
      firstGenre = @options.firstGenre
      @properties = if _.isObject(firstGenre)
        firstGenre
      else if _.isString(firstGenre)
        switch firstGenre
          when "__all__" then {}
          else {genre:firstGenre}
      @on("reset", _.bind( @select, @, null ) )

    select: ( @properties = @properties )->
      iterator = (entry) => entry.isSelect(@properties)
      @selectedList = _(super iterator)
        .tap (entries)=> @trigger("select", entries)

    unselect: ->
      @trigger("unselect")
      @selectedList = []

    # 長くてださい
    @getSource: (data, options)->
      parser = new Parser(options)
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
      if not @template?
        @engine = -> null
      else switch @getTemplateEngineName()
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
      for entry in entries
        entry.marker.setMap(@map)
      @fitBounds(entries) if @options.canFitBounds

    fitBounds:(entries)->
      if entries.length > 0
        bounds = new google.maps.LatLngBounds
        for entry in entries
          bounds.extend( entry.marker.getPosition() )
        if @options.fixedZoom
          @map.setCenter( bounds.getCenter() )
          @map.setZoom( @options.zoom )
        else
          @map.fitBounds( bounds )
          if( @map.getZoom() > @options.maxFitZoom )
            @map.setZoom( @options.maxFitZoom )

    # マーカー, インフォ, リストを消す
    clear:(entries)->
      @closeOpenedInfo()
      for entry in entries
        entry.marker.setMap(null)

    openInfo:(info,marker)->
      @closeOpenedInfo()
      info.open(@map,marker)
      @openedInfo = info

    closeOpenedInfo:->
      if @openedInfo?
        @openedInfo.close()
        @openedInfo = null
  #}}}
  class ListView extends Backbone.View #{{{
    initialize:->
      _.bindAll(@)
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
      @selector = @options.genresSelector
      @$el = $(@selector)
      @$el.on( "click", @options.genreSelector, @selectGenre )

    selectGenre:(e)->
      $target = $(e.currentTarget)
      $group = $target.closest(@selector)
      key = $group.data( @options.genreGroup ) || "genre"
      val = $target.data( @options.genreDataName )
      @trigger("change:genre", key, val)
      return false
  #}}}
  global.MapList = _.extend App, { #{{{
    Parser
    Entry
    Entries
    HtmlFactory
    MapView
    ListView
    GenresView
  } #}}}
