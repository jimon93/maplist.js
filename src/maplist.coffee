###
MapList JavaScript Library v1.5.14
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

    constructor:(options,initializeFunction)->
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
      initializeFunction?(@)
      @start(@options.data) if @options.data?

    @create:(options,initFunc)->
      new App( options, initFunc )

    start:(data)=>
      func = (models) => @entries.reset(models, @options)
      source = new Source(data, @options)
      source.get().then(func)
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
      @trigger('beforeBuild', entries, prop)
      @mapView .build(entries)
      @listView.build(entries)
      @trigger('afterBuild', entries, prop)
      return @

    # 地図とリストを初期化する
    clear:=>
      entries = @getSelectedEntries()
      properties = @getProperties()
      @trigger("beforeClear", entries, properties)
      @mapView .clear(entries)
      @listView.clear(entries)
      @trigger("afterClear", entries, properties)
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
        infoHtmlFactory : HtmlFactory.create(options.templateEngine, options.infoTemplate)
        listHtmlFactory : HtmlFactory.create(options.templateEngine, options.listTemplate)
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
      app.on 'beforeBuild', @options.beforeBuild if @options?.beforeBuild?
      app.on 'afterBuild' , @options.afterBuild  if @options?.afterBuild?
      app.on 'beforeClear', @options.beforeClear if @options?.beforeClear?
      app.on 'afterClear' , @options.afterClear  if @options?.afterClear?

  #}}}
  class Source #{{{
    constructor: (@data, @options)->

    get: =>
      @dfd if @dfd?
      @dfd = new $.Deferred
      @_dfdSetUp()
      @dfd.promise()

    _dfdSetUp: =>
      switch
        when _.isArray(@data) then @dfd.resolve(@data)
        when _.isString(@data) then @_getRemoteData()
        else @dfd.reject()

    _getRemoteData: =>
      parser = new Parser(@options)
      resolve = (data) => @dfd.resolve(parser.execute(data))
      $.ajax(@data).then(resolve, @dfd.reject)
  #}}}
  class Parser #{{{
    constructor:( @options = {} )->

    execute:(data)=>
      _(@getParserSequence()).reduce(@parse, data)

    parse:(data, parser)=>
      switch
        when _.isFunction(parser) then parser(data)
        when parser?.execute?     then parser.execute(data)
        else throw "parser is function or on object with the execute method"

    getParserSequence: =>
      sequence = []
      sequence.push @getCommonParser()
      sequence.push @getAfterParser()
      sequence.push new Parser.MapIconDecorator(@options)
      return sequence

    getCommonParser:=>
      @options.parser ? new Parser.DefaultParser(@options)

    getAfterParser:=>
      @options.afterParser ? _.identity
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
        entry.icon   = @makeIcon(entry.icon)   if entry.icon?
        entry.shadow = @makeIcon(entry.shadow) if entry.shadow?
      return entries

    makeIcon : (data)=>
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
  #}}}
  class Entry extends Backbone.Model #{{{
    initialize: (attributes = {}, options = {})=>
      @views = new EntryViews(@, options)

    openInfo:=>
      @trigger('openinfo', @)

    closeInfo:=>
      @trigger('closeinfo', @)

    view: (type)=>
      @views.get(type)

    isExistPoint:=>
      return @_isExistPoint ?= do=>
        latExist = @has('lat') and _.isFinite(parseFloat @get 'lat')
        lngExist = @has('lng') and _.isFinite(parseFloat @get 'lng')
        latExist and lngExist

    isSelect:(properties)=>
      @isExistPoint() and ( _.isEmpty(properties) or _([@toJSON()]).findWhere(properties)? ) ? true : false

  #}}}
  class EntryViews #{{{
    constructor: (@entry, @options)->
      @data = {}

    get: (type)=>
      unless @data.hasOwnProperty(type)
        @data[type] = switch type
          when "info"   then @createInfo()
          when "marker" then @createMarker()
          when "list"   then @createList()
      @data[type]

    createInfo: =>
      htmlFactory = @options.infoHtmlFactory
      content = @entry.get('__infoElement') || htmlFactory.make( @entry.toJSON() )
      if content? and !!content.replace(/\s/g,"")
        info = new google.maps.InfoWindow {content}
        google.maps.event.addListener( info, 'closeclick', @entry.closeInfo )
        return info

    createMarker: =>
      position = new google.maps.LatLng( @entry.get('lat'), @entry.get('lng') )
      icon = @entry.get('icon')
      shadow = @entry.get('shadow')
      marker = new google.maps.Marker { position, icon, shadow }
      google.maps.event.addListener( marker, 'click', @entry.openInfo )
      return marker

    createList: =>
      htmlFactory = @options.listHtmlFactory
      content = htmlFactory.make( @entry.toJSON() )
      if content? and !!content.replace(/\s/g,"")
        $(content).addClass("__list").data("entry",@entry)
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
    @create: (templateEngine, template)->
      unless template?
        new HtmlFactory.Null
      else switch @getTemplateEngineName(templateEngine)
        when "_.template" then new HtmlFactory.Underscore(template)
        when "$.tmpl"     then new HtmlFactory.Jquery(template)
        else new HtmlFactory.Null

    @getTemplateEngineName: (engine)=>
      switch
        when _?.template? and _.template == engine then "_.template"
        when $?.tmpl?     and $.tmpl == engine     then "$.tmpl"
        else "other"

  class HtmlFactory.Null
    make: =>
      null

  class HtmlFactory.Underscore
    constructor:(template)->
      @make = _.template(template)

  class HtmlFactory.Jquery
    constructor:(template)->
      @engine = _.bind($.tmpl, $, template)

    make: (object)=>
      _(@engine object).map(@_getOuterHtml).join('')

    _getOuterHtml: (dom)=>
      dom.outerHTML
  #}}}
  class MapView extends Backbone.View # info and marker {{{
    initialize: =>
      canvas = $(@options.mapSelector).get(0)
      @map = new google.maps.Map( canvas, @options )

    # 構築
    # マーカー，インフォ，リストを構築
    build:(entries)=>
      for entry in entries
        entry.view('marker').setMap(@map)
      @fitBounds(entries) if @options.canFitBounds

    # マーカー, インフォ, リストを消す
    clear:(entries)=>
      @closeOpenedInfo()
      for entry in entries
        entry.view('marker').setMap(null)

    openInfo:(entry)=>
      @openedInfoEntry?.closeInfo()
      entry.view('info').open(@map,entry.view('marker'))
      @openedInfoEntry = entry

    closeOpenedInfo:=>
      if @openedInfoEntry?
        @openedInfoEntry.view('info').close()
        @openedInfoEntry = null

    fitBounds:(entries)=>
      if entries.length > 0
        bounds = new google.maps.LatLngBounds
        for entry in entries
          bounds.extend( entry.view('marker').getPosition() )
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
        entry.view('list')?.appendTo(@$el)

    clear:(entries)=>
      for entry in entries
        entry.view('list')?.detach()

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
    EntryViews
    Entries
    HtmlFactory
    MapView
    ListView
    GenresView
  } #}}}
