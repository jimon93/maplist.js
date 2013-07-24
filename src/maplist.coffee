###
MapList JavaScript Library v1.5.4
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

    constructor:(options,initFunc)->
      @options    = new Options(options)
      @mapView    = new MapView(@options)
      @listView   = new ListView(@options)
      @genresView = new GenresView(@options)
      @entries    = new Entries(null,@options)
      @properties = {}

      #@delegateEvents()
      delegator = new AppDelegator(@options)
      delegator.execute(@)

      initFunc?(@)
      @start(@options.data) if @options.data?

    @create:(options,initFunc)->
      new App( options, initFunc )

    start:( data )=>
      Entries
        .getSource(data, @options)
        .then (models)=> @entries.reset(models, @options)
      return @

    # Obsolete
    data: @::start

    # 地図とリストを構築する
    build: (entries)=>
      prop = @entries.properties
      @trigger('beforeBuild',entries,prop)
      @mapView .build(entries)
      @listView.build(entries)
      @trigger('afterBuild',entries,prop)
      return @

    # 地図とリストを初期化する
    clear:=>
      entries = @entries.selectedList
      @trigger("beforeClear",entries)
      @mapView .clear(entries)
      @listView.clear(entries)
      @trigger("afterClear",entries)
      return @

    # インフォウィンドウを開く
    openInfo: (entry)=>
      @trigger('openInfo',entry)
      @mapView.openInfo(entry.info, entry.marker)
      @trigger('openedInfo', entry)
      return @

    # インフォウィンドウを閉じる
    closeInfo: (entry)=>
      @trigger('closeInfo',entry)
      @mapView.closeOpenedInfo()
      @trigger('closedInfo',entry)
      return @

    # ジャンルを変更する
    changeGenre: (key, val)=>
      properties = {}
      if _.isUndefined(val) or val == "__all__"
        properties = _.omit( @properties, key )
      else
        properties[key] = val
        properties = _.extend( @properties, properties )
      @trigger('changeGenre', key, val)
      @changeProperties( properties )
      @trigger('changedGenre', key, val)
      return @

    # ジャンルプロパティを変更する
    changeProperties: (@properties)=>
      @trigger('changeProperties', @properties)
      @rebuild( @properties )
      @trigger('changedProperties', @properties )
      return @

    # 地図とリストを初期化して，構築する
    rebuild:(prop)=>
      @entries.unselect()
      @entries.select(prop)
      return @

    # map objectを取得
    getMap:=>
      return @mapView.map

    # entriesにpropertiesが重複している
    getProperties:=>
      return @properties
  #}}}
  class Options #{{{
    constructor: (options)->
      _.extend @, extendOptions extendDefaultOptions options

    defaults = =>{ #
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

    extendDefaultOptions = (options = {})=>
      options = _.extend( {}, defaults(), options )

    extendOptions = (options)=>
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
  class Parser #{{{
    constructor:( @options = {} )->
      @parser = @options.parser || @defaultParser
      @afterParser = @options.afterParser || _.identity

    defaultParser:(data)=>
      if $.isXMLDoc(data)
        parser = new Parser.XMLParser(@options.xmlParserOptions)
        parser.execute(data)
      else if _.isObject(data)
        parser = new Parser.ObjectParser
        parser.execute(data)
      else
        throw "Illegal Argument Error"

    execute:(data)=>
      @finallyParse @afterParser @parse data

    parse:(data)=>
      if _.isFunction(@parser)
        @parser(data)
      else if @parser.execute?
        @parser.execute(data)
      else
        throw "parser is function or on object with the execute method"

    finallyParse:(entries)=>
      for entry in entries
        entry.icon = @makeIcon(entry.icon) if entry.icon?
        entry.shadow = @makeIcon(entry.shadow) if entry.shadow?
      entries

    makeIcon : (data)=>
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
      @properties = if _.isObject(firstGenre)
        firstGenre
      else if _.isString(firstGenre)
        switch firstGenre
          when "__all__" then {}
          else {genre:firstGenre}
      @on("reset", _.bind( @select, @, null ) )

    select: ( @properties = @properties )=>
      iterator = (entry) => entry.isSelect(@properties)
      @selectedList = _(super iterator)
        .tap (entries)=> @trigger("select", entries)

    unselect: =>
      @trigger("unselect")
      @selectedList = []

    # 長くてださい
    @getSource: (data, options)=>
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

    # マーカー, インフォ, リストを消す
    clear:(entries)=>
      @closeOpenedInfo()
      for entry in entries
        entry.marker.setMap(null)

    openInfo:(info,marker)=>
      @closeOpenedInfo()
      info.open(@map,marker)
      @openedInfo = info

    closeOpenedInfo:=>
      if @openedInfo?
        @openedInfo.close()
        @openedInfo = null
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
    Parser
    Entry
    Entries
    HtmlFactory
    MapView
    ListView
    GenresView
  } #}}}
