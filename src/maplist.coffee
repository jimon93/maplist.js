###
MapList JavaScript Library v1.2.0
http://github.com/jimon93/maplist.js

Require Library
  jquery.js
  jquery.tmpl.js
  underscore.js

MIT License
###
do ($=jQuery,global=this)->
  log = _.bind( console.log, console )
  class App
    default: => {
      # 緯度
      lat                    : 35
      # 経度
      lng                    : 135
      # 緯度経度
      # 上の属性より優先される
      #center                 : null #new google.maps.LatLng( 35, 135 )
      # デフォルトのZoom
      zoom                   : 4
      # デフォルトのマップタイプ
      mapTypeId              : google.maps.MapTypeId.ROADMAP
      # entry data
      data                   : []
      # 地図を表示するDOM要素のセレクター
      mapSelector            : '#map_canvas'
      # リストを表示するDOM要素のセレクター
      listSelector           : '#list'
      # リストを構築する為のテンプレート
      listTemplate           : null
      # InfoWindowを構築する為のテンプレート
      infoTemplate           : null
      # リストからマーカーを開くDOM要素のセレクター
      openInfoSelector       : '.open-info'
      # genreの別名
      genreAlias             : 'genre'
      # genreを保持するDOMのテンプレート
      genresSelector         : '#genre'
      genreSelector          : 'a'
      genreDataName          : "target-genre"
      # デフォルトで表示するgenre
      firstGenre             : '__all__'
      # 以下コールバック
      infoOpened             : null
      beforeBuild            : null
      afterBuild             : null
      beforeClear            : null
      afterClear             : null
      # 構築後,表示しているマーカーが全て映るように地図を動かす
      doFit                  : true
      # FitするときZoomも変更する
      fitZoomReset           : false
      # infoを開いた時, 地図の全てが映るように動かす
      toMapScroll            : true
      # 使用するテンプレートエンジン
      # デフォルトでは_.templateを
      # jquery.tmplがある場合,そちらを利用する
      templateEngine         : $.tmpl || _.template
    }
    # 表示中のentryを保持する
    usingEntries : []

    constructor:(options)->
      _.bindAll(@)
      @options = @makeOptions(options)
      @map = new Map(@options)
      source = Entries.getSource(@options.data, @options.parser)
      $.when( @map, source ).then (@map,source)=>
        @entries = new Entries(source, @map, @options)
        @list = new List(@options)
      #   @maplist = new MapList()
        @rebuild( @options.firstGenre, @entries )

    makeOptions:(options)->
      options = _.extend( {}, _(@).result('default'), _.clone options)
      unless options.center?
        options.center = new google.maps.LatLng( options.lat, options.lng )
      return options

    # 地図とリストを構築する
    build:(genreId)->
      @options.beforeBuild?(genreId)
      @usingEntries = _(@entries.list).filter( (entry)=> entry.isSelect(genreId) )
      @map.build(@usingEntries)
      @list.build(@usingEntries)
      @options.afterBuild?(genreId, @usingEntries)

    # 地図とリストを初期化する
    clear:->
      @options.beforeClear?()
      @map.clear(@usingEntries)
      @list.clear(@usingEntries)
      @options.afterClear?()

    # 地図とリストを初期化して，構築する
    rebuild:(genreId)->
      @clear()
      @build(genreId)

    # map objectを取得
    getMap:->
      return @maplist.map

  class Parser
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
          obj.genre = obj.id
          obj.genreName = obj.name
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

  class Entries
    constructor:(source, @maplist, @options)->
      _.bindAll(@)
      options = {
        infoHtmlFactory : new HtmlFactory(@options.templateEngine, @options.infoTemplate)
        listHtmlFactory : new HtmlFactory(@options.templateEngine, @options.listTemplate)
      }
      @list = ( new Entry(entryFactor, @maplist, options) for entryFactor in source )

    gets:->
      @list

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

  class Entry
    constructor:(@attributes, @maplist, options)->
      _.bindAll(@)
      @info   = @makeInfo(options.infoHtmlFactory)
      @marker = @makeMarker()
      @list   = @makeList(options.listHtmlFactory)

    openInfo:->
      @maplist.openInfo(@info, @marker)

    makeInfo:(infoHtmlFactory)->
      content = infoHtmlFactory.make( @attributes )
      if content?
        info = new google.maps.InfoWindow {content}
        google.maps.event.addListener( info, 'closeclick', @openInfo )
        return info

    makeMarker:->
      position = new google.maps.LatLng( @attributes.lat, @attributes.lng )
      marker = new google.maps.Marker { position, icon: @attributes.icon, shadow: @attributes.shadow }
      google.maps.event.addListener( marker, 'click', @openInfo ) if @info?
      return marker

    makeList:(listHtmlFactory)->
      content = listHtmlFactory.make( @attributes )
      if content?
        $content = $(content).addClass(".__entryElem")
        $content.find(".open-info").data("entry",@)
        return $content

    isSelect:(genreId)->
      switch genreId
        when "__all__" then true
        else genreId == @attributes.genre

  class HtmlFactory
    constructor:(@templateEngine, @template)->

    make:(object)->
      return null unless @templateEngine? or @template?
      res = @templateEngine( @template, object )
      res = res.html() if res.html?
      return res

  class Map # info and marker
    constructor:(@options)->
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
      for entry in entries
        @closeOpenedInfo()
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

  class List
    constructor:(@options)->
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
      #$list = $target.closest(".__entryElem")
      #log $list.data("entry")
      #$list.data("entry").openInfo()
      $target.data("entry").openInfo()
      return false

  class Genres
    constructor:(options, @app)->
      # event
      @$el = $(options.genresSelector)
      @$el.on( "click", options.genreSelector, @selectGenre )

    # ジャンルをクリックされた時のためのコールバック関数
    selectGenre:(e, genreId)->
      unless genreId?
        $target = $(e.currentTarget)
        genreId = $target.data( @options.genreDataName )
      @app.rebuild(genreId)
      return false

  global.MapList = App
  App.Entries = Entries
  App.Parser = Parser
