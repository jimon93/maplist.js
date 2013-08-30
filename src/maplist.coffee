###
MapList JavaScript Library v1.5.10
http://github.com/jimon93/maplist.js

Require Library
  jquery.js
  underscore.js
  backbone.js

Options Library
  jquery.tmpl.js

MIT License
###
do ($=jQuery,global=this)->
  log = (args...)-> console?.log?(args...)
  class App #{{{
    _.extend( @::, Backbone.Events )

    constructor:(options,initFunc)->
      # Field initialize
      @options    = new Options(options)
      @mapView    = new MapView(@options)
      @listView   = new ListView(@options)
      @genresView = new GenresView(@options)
      @entries    = new Entries(null,@options)

      # Event Delegate
      delegator = new AppDelegator(@options)
      delegator.execute(@)

      # start
      initFunc?(@)
      @start(@options.data) if @options.data?

    @create:(options,initFunc)->
      new App( options, initFunc )

    start:( data )=>
      Source
        .get(data, @options)
        .then (models)=> @entries.reset(models, @options)
      return @

    # Obsolete
    data: @::start

    # Getter methods
    # map objectを取得
    getMap:=>
      return @mapView.map

    getSelectedEntries:=>
      return @entries.selectedList

    getProperties:=>
      return @entries.properties

    # common methods
    # 地図とリストを構築する
    build: (entries)=>
      prop = @getProperties()
      @trigger('beforeBuild',entries,prop)
      @mapView .build(entries)
      @listView.build(entries)
      @trigger('afterBuild',entries,prop)
      return @

    # 地図とリストを初期化する
    clear:=>
      entries = @getSelectedEntries()
      properties = @getProperties()
      @trigger("beforeClear",entries, properties)
      @mapView .clear(entries)
      @listView.clear(entries)
      @trigger("afterClear",entries, properties)
      return @

    # インフォウィンドウを開く
    openInfo: (entry)=>
      @trigger('openInfo',entry)
      @mapView.openInfo(entry)
      @trigger('openedInfo', entry)
      return @

    # インフォウィンドウを閉じる
    closeInfo: =>
      entry = @mapView.openedInfoEntry
      @trigger('closeInfo',entry)
      @mapView.closeOpenedInfo()
      @trigger('closedInfo',entry)
      return @

    # ジャンルを変更する
    changeGenre: (key, val)=>
      prev = _.extend({}, @getProperties())
      properties =
        if _.isUndefined(val) or val == "__all__"
        then _.omit(prev, key)
        else _(prev).tap( (obj)->obj[key] = val )
      @trigger('changeGenre', key, val)
      @changeProperties(properties)
      @trigger('changedGenre', key, val)
      return @

    # ジャンルプロパティを変更する
    changeProperties: (properties)=>
      @trigger('changeProperties', properties)
      @rebuild( properties )
      @trigger('changedProperties', properties )
      return @

    # 地図とリストを初期化して，構築する
    rebuild:(prop)=>
      @entries.unselect()
      @entries.select(prop)
      return @
  #}}}
  class Options #{{{
    constructor: (options)->
      _.extend @, Options.extendOptions Options.extendDefaultOptions options

    @defaults = =>{
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
      templateEngine : $.tmpl ? _.template
      # parser
      parser : null
      afterParser : null
      xmlParserOptions: {}
    }

    @extendDefaultOptions = (options = {})=>
      options = _.extend( {}, Options.defaults(), options )

    @extendOptions = (options)=>
      center = { center : new google.maps.LatLng( options.lat, options.lng ) }
      templates = {
        infoHtmlFactory : new HtmlFactory(options.templateEngine, options.infoTemplate)
        listHtmlFactory : new HtmlFactory(options.templateEngine, options.listTemplate)
      }
      _.extend( center, options, templates )
  #}}}
  class AppDelegator #{{{
    constructor: (@options)->

    execute: (app)->
      app.entries.on    "select"       , app.build
      app.entries.on    "unselect"     , app.clear
      app.entries.on    "openinfo"     , app.openInfo
      app.entries.on    "closeinfo"    , app.closeInfo
      app.genresView.on "change:genre" , app.changeGenre
      @obsoleteDelegateEvents(app)

    obsoleteDelegateEvents: (app)->
      app.on 'beforeBuild', @options.beforeBuild if @options.beforeBuild?
      app.on 'afterBuild' , @options.afterBuild  if @options.afterBuild?
      app.on 'beforeClear', @options.beforeClear if @options.beforeClear?
      app.on 'afterClear' , @options.afterClear  if @options.afterClear?

  #}}}
  class Source #{{{
    @get: (data, options)=>
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
  class Parser #{{{
    constructor:( @options = {} )->

    execute:(data)=>
      sequence = []
      sequence.push @options.parser ? new Parser.DefaultParser(@options)
      sequence.push @options.afterParser ? _.identity
      sequence.push new Parser.MapIconDecorator(@options)
      _(sequence).reduce(@_parse, data)

    _parse:(data, parser)=>
      switch
        when _.isFunction(parser) then parser(data)
        when parser?.execute?     then parser.execute(data)
        else throw "parser is function or on object with the execute method"
  #}}}
  class Parser.DefaultParser #{{{
    constructor: (@options)->

    execute: (data)=>
      switch
        when $.isXMLDoc(data)
          parser = new Parser.XMLParser(@options.xmlParserOptions)
          parser.execute(data)
        when _.isObject(data)
          parser = new Parser.ObjectParser
          parser.execute(data)
        else throw "Illegal Argument Error"
  #}}}
  class Parser.MapIconDecorator #{{{
    execute:(entries)=>
      for entry in entries
        entry.icon   = @_makeIcon(entry.icon)   if entry.icon?
        entry.shadow = @_makeIcon(entry.shadow) if entry.shadow?
      return entries

    _makeIcon : (data)=>
      result = _.clone data
      for key, val of data
        result[key] = switch key
          when "origin", "anchor" then new google.maps.Point(val[0],val[1])
          when "size", "scaledSize" then new google.maps.Size(val[0],val[1])
          else val
      return result
  #}}}
  class Parser.XMLParser #{{{
    defaults: =>{
      place: "place"
      genre: "genre"
    }

    constructor: (options)->
      @options = _.extend( {}, _(@).result('defaults'), options)

    execute: (data)=>
      $root = $(">*", data).eq(0)
      ( @makePlace( $(place) ) for place in $root.find(@options.place).get() )

    makePlace:($place)=>
      _({}).chain()
        .extend( @getGenre($place), @getContent($place), @getAttribute($place) )
        .tap( (obj)->
          obj.lat = obj.latitude  if not obj.lat? and obj.latitude?
          obj.lng = obj.longitude if not obj.lng? and obj.longitude?
        ).omit("latitude","longitude").value()

    getGenre:($place)=>
      $genre = $place.closest(@options.genre)
      if $genre.size() == 1
        _(@getAttribute($genre)).chain().tap((obj)->
          obj.genre     = obj.id   if obj.id?
          obj.genreName = obj.name if obj.name?
        ).omit("id","name").value()
      else
        {}

    getContent:($place)=>
      res = {}
      for elem in $place.children().get()
        res[elem.nodeName.toLowerCase()] = $(elem).text()
      return res

    getAttribute:($place)=>
      res = {}
      for attr in $place.get(0).attributes when attr != "id" and attr != "name"
        res[attr.name] = attr.value
      return res
  #}}}
  class Parser.ObjectParser #{{{
    execute: (data)=>
      data
  #}}}
  class Entry extends Backbone.Model #{{{
    initialize: (attributes, options)=>
      attributes ||= {}
      options ||= {}
      @isPoint = @getExistPoint()
      @info   = @makeInfo(options.infoHtmlFactory)
      @marker = @makeMarker()
      @list   = @makeList(options.listHtmlFactory)

    openInfo:=>
      @trigger('openinfo', @)

    closeInfo:=>
      @trigger('closeinfo', @)

    makeInfo:(infoHtmlFactory)=>
      content = @get('__infoElement') || infoHtmlFactory.make( @toJSON() )
      if content? and !!content.replace(/\s/g,"")
        info = new google.maps.InfoWindow {content}
        google.maps.event.addListener( info, 'closeclick', @closeInfo )
        return info

    makeMarker:=>
      position = new google.maps.LatLng( @get('lat'), @get('lng') )
      marker = new google.maps.Marker { position, icon: @get('icon'), shadow: @get('shadow') }
      google.maps.event.addListener( marker, 'click', @openInfo ) if @info?
      return marker

    makeList:(listHtmlFactory)=>
      content = listHtmlFactory.make( @toJSON() )
      if content? and !!content.replace(/\s/g,"")
        $(content).addClass("__list").data("entry",@)

    getExistPoint:=>
      latExist = @has('lat') and _.isFinite(parseFloat @get 'lat')
      lngExist = @has('lng') and _.isFinite(parseFloat @get 'lng')
      latExist and lngExist

    isSelect:(properties)=>
      @isPoint and ( _.isEmpty(properties) or _([@toJSON()]).findWhere(properties)? ) ? true : false

  #}}}
  class Entries extends Backbone.Collection #{{{
    model: Entry

    initialize:(source, @options)=>
      @selectedList = []
      firstGenre = @options.firstGenre
      @properties =
        if _.isObject(firstGenre)
          firstGenre
        else if _.isString(firstGenre)
          switch firstGenre
            when "__all__" then {}
            else {genre:firstGenre}
      @on("reset", _.bind( @select, @, null ) )

    select: (@properties = @properties)=>
      iterator = (entry) => entry.isSelect(@properties)
      @selectedList = _(super iterator)
        .tap (entries)=> @trigger("select", entries)

    unselect: =>
      @trigger("unselect")
      @selectedList = []
  #}}}
  class HtmlFactory #{{{
    constructor:(@templateEngine, @template)->
      if not @template?
        @engine = -> null
      else switch @getTemplateEngineName()
        when "_.template"
          @engine = @templateEngine(@template)
        when "$.tmpl"
          @engine = _.bind( @templateEngine, $, @template )
        else
          @engine = _.bind( @templateEngine, @, @template )

    make:(object)=>
      return null unless @templateEngine? and @template?
      res = @engine(object)
      if @getTemplateEngineName() == "$.tmpl"
        res = _(res).map( (dom) -> dom.outerHTML ).join('')
      return res

    getTemplateEngineName:=>
      if _?.template? and _.template == @templateEngine
        "_.template"
      else if $?.tmpl? and $.tmpl == @templateEngine
        "$.tmpl"
      else
        "other"
  #}}}
  class MapView extends Backbone.View # info and marker {{{
    initialize: =>
      canvas = $(@options.mapSelector).get(0)
      @map = new google.maps.Map( canvas, @options )

    # 構築
    # マーカー，インフォ，リストを構築
    build:(entries)=>
      for entry in entries
        entry.marker.setMap(@map)
      @fitBounds(entries) if @options.canFitBounds

    # マーカー, インフォ, リストを消す
    clear:(entries)=>
      @closeOpenedInfo()
      for entry in entries
        entry.marker.setMap(null)

    openInfo:(entry)=>
      @openedInfoEntry?.closeInfo()
      entry.info.open(@map,entry.marker)
      @openedInfoEntry = entry

    closeOpenedInfo:=>
      if @openedInfoEntry?
        @openedInfoEntry.info.close()
        @openedInfoEntry = null

    fitBounds:(entries)=>
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
  #}}}
  class ListView extends Backbone.View #{{{
    initialize:=>
      @$el = $(@options.listSelector)
      @$el.on( "click", @options.openInfoSelector, @openInfo )

    build:(entries)=>
      for entry in entries
        entry.list?.appendTo(@$el)

    clear:(entries)=>
      for entry in entries
        entry.list?.detach()

    openInfo:(e)=>
      $target = $(e.currentTarget)
      $target.closest(".__list").data("entry").openInfo()
      return false
  #}}}
  class GenresView extends Backbone.View #{{{
    initialize:=>
      # event
      @selector = @options.genresSelector
      @$el = $(@selector)
      @$el.on( "click", @options.genreSelector, @selectGenre )

    selectGenre:(e)=>
      $target = $(e.currentTarget)
      $group = $target.closest(@selector)
      key = $group.data( @options.genreGroup ) || "genre"
      val = $target.data( @options.genreDataName )
      @trigger("change:genre", key, val)
      return false
  #}}}
  global.MapList = _.extend App, { #{{{
    Options
    AppDelegator
    Source
    Parser
    Entry
    Entries
    HtmlFactory
    MapView
    ListView
    GenresView
  } #}}}
