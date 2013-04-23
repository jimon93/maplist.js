log = -> console.log(arguments...)
describe "MapList", ->
  data = createSpy = createSpyObj = undefined
  beforeEach ->
    createSpy = jasmine.createSpy
    createSpyObj = jasmine.createSpyObj
    data = { #{{{
      entries : {
        object: [
          {"states":"北海道","capitals":"札幌市","lat":"43.0646147","lng":"141.3468074","genre":"北海道"}
          {"states":"青森県","capitals":"青森市","lat":"41.8243077","lng":"140.7399984","genre":"東北"}
          {"states":"岩手県","capitals":"盛岡市","lat":"39.7036194","lng":"141.1526839","genre":"東北"}
          {"states":"宮城県","capitals":"仙台市","lat":"38.2688373","lng":"140.8721000","genre":"東北"}
          {"states":"秋田県","capitals":"秋田市","lat":"39.7186135","lng":"140.1023643","genre":"東北"}
          {"states":"山形県","capitals":"山形市","lat":"38.2404355","lng":"140.3636333","genre":"東北"}
          {"states":"福島県","capitals":"福島市","lat":"37.7502986","lng":"140.4675514","genre":"東北"}
          {"states":"茨城県","capitals":"水戸市","lat":"36.3418112","lng":"140.4467935","genre":"関東"}
          {"states":"栃木県","capitals":"宇都宮市","lat":"36.5657250","lng":"139.8835651","genre":"関東"}
          {"states":"群馬県","capitals":"前橋市","lat":"36.3906675","lng":"139.0604061","genre":"関東"}
          {"states":"埼玉県","capitals":"さいたま市","lat":"35.8569991","lng":"139.6488487","genre":"関東"}
          {"states":"千葉県","capitals":"千葉市","lat":"35.6050574","lng":"140.1233063","genre":"関東"}
          {"states":"東京都","capitals":"新宿区","lat":"35.6894875","lng":"139.6917064","genre":"関東"}
          {"states":"神奈川県","capitals":"横浜市","lat":"35.4475073","lng":"139.6423446","genre":"関東"}
          {"states":"山梨県","capitals":"甲府市","lat":"35.6641575","lng":"138.5684486","genre":"関東"}
          {"states":"新潟県","capitals":"新潟市","lat":"37.9025518","lng":"139.0230946","genre":"信越"}
          {"states":"長野県","capitals":"長野市","lat":"36.6512986","lng":"138.1809557","genre":"信越"}
          {"states":"富山県","capitals":"富山市","lat":"36.6952907","lng":"137.2113383","genre":"北陸"}
          {"states":"石川県","capitals":"金沢市","lat":"36.5946816","lng":"136.6255726","genre":"北陸"}
          {"states":"福井県","capitals":"福井市","lat":"36.0651779","lng":"136.2215269","genre":"北陸"}
          {"states":"岐阜県","capitals":"岐阜市","lat":"35.3912272","lng":"136.7222906","genre":"東海"}
          {"states":"静岡県","capitals":"静岡市","lat":"34.9771201","lng":"138.3830845","genre":"東海"}
          {"states":"愛知県","capitals":"名古屋市","lat":"35.1801883","lng":"136.9065647","genre":"東海"}
          {"states":"三重県","capitals":"津市","lat":"34.7302829","lng":"136.5085883","genre":"東海"}
          {"states":"滋賀県","capitals":"大津市","lat":"35.0045306","lng":"135.8685899","genre":"近畿"}
          {"states":"京都府","capitals":"京都市","lat":"35.0212466","lng":"135.7555968","genre":"近畿"}
          {"states":"大阪府","capitals":"大阪市","lat":"34.6862971","lng":"135.5196609","genre":"近畿"}
          {"states":"兵庫県","capitals":"神戸市","lat":"34.6912688","lng":"135.1830706","genre":"近畿"}
          {"states":"奈良県","capitals":"奈良市","lat":"34.6853345","lng":"135.8327421","genre":"近畿"}
          {"states":"和歌山県","capitals":"和歌山市","lat":"34.2259867","lng":"135.1675086","genre":"近畿"}
          {"states":"鳥取県","capitals":"鳥取市","lat":"35.5038906","lng":"134.2377356","genre":"中国"}
          {"states":"島根県","capitals":"松江市","lat":"35.4722952","lng":"133.0504997","genre":"中国"}
          {"states":"岡山県","capitals":"岡山市","lat":"34.6617511","lng":"133.9344057","genre":"中国"}
          {"states":"広島県","capitals":"広島市","lat":"34.3965603","lng":"132.4596225","genre":"中国"}
          {"states":"山口県","capitals":"山口市","lat":"34.1859563","lng":"131.4706493","genre":"中国"}
          {"states":"徳島県","capitals":"徳島市","lat":"34.0657179","lng":"134.5593601","genre":"四国"}
          {"states":"香川県","capitals":"高松市","lat":"34.3401491","lng":"134.0434436","genre":"四国"}
          {"states":"愛媛県","capitals":"松山市","lat":"33.8416238","lng":"132.7656808","genre":"四国"}
          {"states":"高知県","capitals":"高知市","lat":"33.5597062","lng":"133.5310786","genre":"四国"}
          {"states":"福岡県","capitals":"福岡市","lat":"33.6065756","lng":"130.4182970","genre":"九州"}
          {"states":"佐賀県","capitals":"佐賀市","lat":"33.2494416","lng":"130.2997942","genre":"九州"}
          {"states":"長崎県","capitals":"長崎市","lat":"32.7448388","lng":"129.8737562","genre":"九州"}
          {"states":"熊本県","capitals":"熊本市","lat":"32.7898270","lng":"130.7416672","genre":"九州"}
          {"states":"大分県","capitals":"大分市","lat":"33.2381718","lng":"131.6126189","genre":"九州"}
          {"states":"宮崎県","capitals":"宮崎市","lat":"31.9110956","lng":"131.4238934","genre":"九州"}
          {"states":"鹿児島県","capitals":"鹿児島市","lat":"31.5610825","lng":"130.5577279","genre":"九州"}
          {"states":"沖縄県","capitals":"那覇市","lat":"26.2124013","lng":"127.6809317","genre":"沖縄"}
        ]
        xml: $.parseXML """<?xml version='1.0' encoding='UTF-8'?>
          <places>
          <genre id='北海道'><place latitude='43.0646147' longitude='141.3468074'><states>北海道</states><capitals>札幌市</capitals></place></genre>
          <genre id='東北'><place latitude='41.8243077' longitude='140.7399984'><states>青森県</states><capitals>青森市</capitals></place><place latitude='39.7036194' longitude='141.1526839'><states>岩手県</states><capitals>盛岡市</capitals></place><place latitude='38.2688373' longitude='140.8721000'><states>宮城県</states><capitals>仙台市</capitals></place><place latitude='39.7186135' longitude='140.1023643'><states>秋田県</states><capitals>秋田市</capitals></place><place latitude='38.2404355' longitude='140.3636333'><states>山形県</states><capitals>山形市</capitals></place><place latitude='37.7502986' longitude='140.4675514'><states>福島県</states><capitals>福島市</capitals></place></genre>
          <genre id='関東'><place latitude='36.3418112' longitude='140.4467935'><states>茨城県</states><capitals>水戸市</capitals></place><place latitude='36.5657250' longitude='139.8835651'><states>栃木県</states><capitals>宇都宮市</capitals></place><place latitude='36.3906675' longitude='139.0604061'><states>群馬県</states><capitals>前橋市</capitals></place><place latitude='35.8569991' longitude='139.6488487'><states>埼玉県</states><capitals>さいたま市</capitals></place><place latitude='35.6050574' longitude='140.1233063'><states>千葉県</states><capitals>千葉市</capitals></place><place latitude='35.6894875' longitude='139.6917064'><states>東京都</states><capitals>新宿区</capitals></place><place latitude='35.4475073' longitude='139.6423446'><states>神奈川県</states><capitals>横浜市</capitals></place><place latitude='35.6641575' longitude='138.5684486'><states>山梨県</states><capitals>甲府市</capitals></place></genre>
          <genre id='信越'><place latitude='37.9025518' longitude='139.0230946'><states>新潟県</states><capitals>新潟市</capitals></place><place latitude='36.6512986' longitude='138.1809557'><states>長野県</states><capitals>長野市</capitals></place></genre>
          <genre id='北陸'><place latitude='36.6952907' longitude='137.2113383'><states>富山県</states><capitals>富山市</capitals></place><place latitude='36.5946816' longitude='136.6255726'><states>石川県</states><capitals>金沢市</capitals></place><place latitude='36.0651779' longitude='136.2215269'><states>福井県</states><capitals>福井市</capitals></place></genre>
          <genre id='東海'><place latitude='35.3912272' longitude='136.7222906'><states>岐阜県</states><capitals>岐阜市</capitals></place><place latitude='34.9771201' longitude='138.3830845'><states>静岡県</states><capitals>静岡市</capitals></place><place latitude='35.1801883' longitude='136.9065647'><states>愛知県</states><capitals>名古屋市</capitals></place><place latitude='34.7302829' longitude='136.5085883'><states>三重県</states><capitals>津市</capitals></place></genre>
          <genre id='近畿'><place latitude='35.0045306' longitude='135.8685899'><states>滋賀県</states><capitals>大津市</capitals></place><place latitude='35.0212466' longitude='135.7555968'><states>京都府</states><capitals>京都市</capitals></place><place latitude='34.6862971' longitude='135.5196609'><states>大阪府</states><capitals>大阪市</capitals></place><place latitude='34.6912688' longitude='135.1830706'><states>兵庫県</states><capitals>神戸市</capitals></place><place latitude='34.6853345' longitude='135.8327421'><states>奈良県</states><capitals>奈良市</capitals></place><place latitude='34.2259867' longitude='135.1675086'><states>和歌山県</states><capitals>和歌山市</capitals></place></genre>
          <genre id='中国'><place latitude='35.5038906' longitude='134.2377356'><states>鳥取県</states><capitals>鳥取市</capitals></place><place latitude='35.4722952' longitude='133.0504997'><states>島根県</states><capitals>松江市</capitals></place><place latitude='34.6617511' longitude='133.9344057'><states>岡山県</states><capitals>岡山市</capitals></place><place latitude='34.3965603' longitude='132.4596225'><states>広島県</states><capitals>広島市</capitals></place><place latitude='34.1859563' longitude='131.4706493'><states>山口県</states><capitals>山口市</capitals></place></genre>
          <genre id='四国'><place latitude='34.0657179' longitude='134.5593601'><states>徳島県</states><capitals>徳島市</capitals></place><place latitude='34.3401491' longitude='134.0434436'><states>香川県</states><capitals>高松市</capitals></place><place latitude='33.8416238' longitude='132.7656808'><states>愛媛県</states><capitals>松山市</capitals></place><place latitude='33.5597062' longitude='133.5310786'><states>高知県</states><capitals>高知市</capitals></place></genre>
          <genre id='九州'><place latitude='33.6065756' longitude='130.4182970'><states>福岡県</states><capitals>福岡市</capitals></place><place latitude='33.2494416' longitude='130.2997942'><states>佐賀県</states><capitals>佐賀市</capitals></place><place latitude='32.7448388' longitude='129.8737562'><states>長崎県</states><capitals>長崎市</capitals></place><place latitude='32.7898270' longitude='130.7416672'><states>熊本県</states><capitals>熊本市</capitals></place><place latitude='33.2381718' longitude='131.6126189'><states>大分県</states><capitals>大分市</capitals></place><place latitude='31.9110956' longitude='131.4238934'><states>宮崎県</states><capitals>宮崎市</capitals></place><place latitude='31.5610825' longitude='130.5577279'><states>鹿児島県</states><capitals>鹿児島市</capitals></place></genre>
          <genre id='沖縄'><place latitude='26.2124013' longitude='127.6809317'><states>沖縄県</states><capitals>那覇市</capitals></place></genre>
          </places>"""
      }
      matcher:{
        toDeepEqual: (expected)->
          _.isEqual(this.actual, expected)
      }
    } #}}}

  describe "= APP",->
    app = maplistArgs = undefined
    beforeEach ->
      maplistArgs = { data: data.entries.object }

    describe "constructor",-> #{{{
      options = delegateEvents = dataFunc = undefined
      beforeEach ->
        options = MapList::makeOptions()
        delegateEvents = createSpy("delegateEvents")
        dataFunc = createSpy("data")
        class MyMapList extends MapList
          makeOptions: createSpy("makeOptions").andReturn(options)
          delegateEvents : delegateEvents
          data : dataFunc
          #rebuild: rebuild
        app = new MyMapList { data: data.entries.object }

      it "check options",->
        expect(app.options).toBe(options)

      it "check mapView",->
        expect(app.mapView instanceof MapList.MapView).toBeTruthy()

      it "check listView", ->
        expect(app.listView instanceof MapList.ListView).toBeTruthy()

      it "check genresView", ->
        expect(app.genresView instanceof MapList.GenresView).toBeTruthy()

      it "check entries", ->
        expect(app.entries instanceof MapList.Entries).toBeTruthy()

      it "called delegateEvents",->
        expect(delegateEvents).toHaveBeenCalled()

      it "called data",->
        expect(dataFunc).toHaveBeenCalled()
    #}}}
    describe ".new",-> #{{{
      beforeEach ->
        app = MapList.new()

      it "create instance",->
        expect(app instanceof MapList).toBeTruthy()
    #}}}
    describe "::data",-> #{{{
      beforeEach ->
        app = new MapList

      it "none data",->
        expect(app.entries.toJSON()).not.toEqual(data.entries.object)

      it "data set",->
        app.data(data.entries.object)
        expect(app.entries.toJSON()).toEqual(data.entries.object)
    #}}}
    describe "::makeOptions",-> #{{{
      beforeEach ->
        app = new MapList maplistArgs
        spyOn(app,"extendDefaultOptions").andCallThrough()
        app.extendOptions = createSpy("extendOptions")

      it "call @extendDefaultOptions",->
        app.makeOptions({})
        expect(app.extendDefaultOptions).toHaveBeenCalled()

      it "call @extendOptions",->
        app.makeOptions({})
        expect(app.extendOptions).toHaveBeenCalled()

      it "compose extendDefaultOptions and extendOptions",->
        obj = app.extendDefaultOptions()
        app.extendDefaultOptions = createSpy("extendDefaultOptions").andReturn(obj)
        app.makeOptions({})
        expect(app.extendOptions.calls[0].args[0]).toBe(obj)
    #}}}
    describe "::extendDefaultOptions",-> #{{{
      defaultData = undefined
      beforeEach ->
        defaultData = _(app).result('default')

      it "return default value without arguments",->
        expect(app.extendDefaultOptions()).toEqual(defaultData)

      it "return default value with {}",->
        expect(app.extendDefaultOptions({})).toEqual(defaultData)

      it "return value is not default",->
        expect(app.extendDefaultOptions()).not.toBe(defaultData)

      it "return value default + options",->
        options = { lat: 0, lng: 0 }
        answer = _.extend {}, defaultData, options
        expect(app.extendDefaultOptions(options)).toEqual(answer)
    #}}}
    describe "::extendOptions",-> #{{{
      options = res = undefined
      beforeEach ->
        options = {
          lat: 35
          lng: 135
          templateEngine: _.template
          infoTemplate: "infoTemplate"
          listTemplate: "listTemplate"
        }
        res = MapList::extendOptions(options)


      it "return value is not options",->
        expect(res).not.toEqual(options)

      it "has center object",->
        expect(res.center instanceof google.maps.LatLng).toBeTruthy()

      it "check lat",->
        expect(res.center.lat()).toBe(options.lat)

      it "check lng",->
        expect(res.center.lng()).toBe(options.lng)

      it "has infoHtmlFactory object",->
        expect(res.infoHtmlFactory instanceof MapList.HtmlFactory).toBeTruthy()

      it "check infoHtmlFactory.templateEngine",->
        expect(res.infoHtmlFactory.templateEngine).toBe(options.templateEngine)

      it "check infoHtmlFactory.template",->
        expect(res.infoHtmlFactory.template).toBe(options.infoTemplate)

      it "has listHtmlFactory object",->
        expect(res.listHtmlFactory instanceof MapList.HtmlFactory).toBeTruthy()

      it "check listHtmlFactory.templateEngine",->
        expect(res.listHtmlFactory.templateEngine).toBe(options.templateEngine)

      it "check listHtmlFactory.template",->
        expect(res.listHtmlFactory.template).toBe(options.listTemplate)
    #}}}
    describe "::delegateEvents",-> #{{{
      method = obj = obj2 = undefined
      beforeEach ->
        app = new MapList maplistArgs
        app.entries.off()
        app.mapView.off()
        app.genresView.off()
        _.extend app, {
          build       : createSpy("build")
          clear       : createSpy("clear")
          openInfo    : createSpy("openInfo")
          closeInfo   : createSpy("closeInfo")
          changeGenre : createSpy("changeGenre")
        }
        app.delegateEvents()

      describe "on select event",->
        beforeEach ->
          method = app.build
          obj = []
          app.entries.trigger( "select", obj )

        it "called",->
          expect(method).toHaveBeenCalled()

        it "catch args",->
          expect(method.calls[0].args[0]).toBe(obj)

      describe "on unselect event",->
        beforeEach ->
          method = app.clear
          obj = []
          app.entries.trigger "unselect", obj

        it "called",->
          expect(method).toHaveBeenCalled()

        it "catch args",->
          expect(method.calls[0].args[0]).toBe(obj)

      describe "on openinfo event",->
        beforeEach ->
          method = app.openInfo
          obj = []
          app.entries.trigger "openinfo", obj

        it "called",->
          expect(method).toHaveBeenCalled()

        it "catch args",->
          expect(method.calls[0].args[0]).toBe(obj)

      describe "on closeinfo event",->
        beforeEach ->
          method = app.closeInfo
          obj = []
          app.entries.trigger "closeinfo", obj

        it "called",->
          expect(method).toHaveBeenCalled()

        it "catch args",->
          expect(method.calls[0].args[0]).toBe(obj)

      describe "on change:genre event",->
        beforeEach ->
          method = app.changeGenre
          obj = []
          app.genresView.trigger "change:genre", obj

        it "called",->
          expect(method).toHaveBeenCalled()

        it "catch args",->
          expect(method.calls[0].args[0]).toBe(obj)
    #}}}
    describe "::build",-> #{{{
      entries = prop = spy1 = spy2 = beforeBuild = afterBuild = undefined
      beforeEach ->
        app = new MapList maplistArgs
        prop = app.entries.properties
        app.mapView  = { build : spy1 = createSpy("mapView:build") }
        app.listView = { build : spy2 = createSpy("listView:build") }
        app.on("beforeBuild",beforeBuild = createSpy("beforeBuild"))
        app.on("afterBuild" ,afterBuild  = createSpy("afterBuild"))
        app.build(entries = {})

      it "call mapView.build",->
        expect(spy1).toHaveBeenCalled()

      it "call mapView.build with entries",->
        expect(spy1.calls[0].args[0]).toBe(entries)

      it "call mapView.build",->
        expect(spy2).toHaveBeenCalled()

      it "call mapView.build with entries",->
        expect(spy2.calls[0].args[0]).toBe(entries)

      it "fire beforeBuild event",->
        expect(beforeBuild).toHaveBeenCalled()

      it "fire beforeBuild event with arguments:0",->
        expect(beforeBuild.calls[0].args[0]).toBe(prop)

      it "fire beforeBuild event with arguments:1",->
        expect(beforeBuild.calls[0].args[1]).toBe(entries)

      it "fire afterBuild event",->
        expect(afterBuild).toHaveBeenCalled()

      it "fire afterBuild event with arguments:0",->
        expect(afterBuild.calls[0].args[0]).toBe(prop)

      it "fire afterBuild event with arguments:1",->
        expect(afterBuild.calls[0].args[1]).toBe(entries)
    #}}}
    describe "::clear",-> #{{{
      entries = spy1 = spy2 = beforeClear = afterClear = undefined
      beforeEach ->
        app = new MapList maplistArgs
        entries = app.entries.selectedList
        app.mapView  = { clear : spy1 = createSpy("mapView:clear") }
        app.listView = { clear : spy2 = createSpy("listView:clear") }
        app.on("beforeClear",beforeClear = createSpy("beforeClear"))
        app.on("afterClear" ,afterClear  = createSpy("afterClear"))
        app.clear()

      it "call mapView.clear",->
        expect(spy1).toHaveBeenCalled()

      it "call mapView.clear",->
        expect(spy2).toHaveBeenCalled()

      it "fire beforeClear event",->
        expect(beforeClear).toHaveBeenCalled()

      it "fire beforeClear event with arguments",->
        expect(beforeClear.calls[0].args[0]).toBe(entries)

      it "fire afterClear event",->
        expect(afterClear).toHaveBeenCalled()

      it "fire afterClear event with arguments",->
        expect(afterClear.calls[0].args[0]).toBe(entries)
    #}}}
    describe "::openInfo",-> #{{{
      spy1 = entry = openInfo = openedInfo = undefined
      beforeEach ->
        app = new MapList maplistArgs
        app.mapView  = { openInfo : spy1 = createSpy("mapView:openInfo") }
        entry = { info : "info", marker: "marker" }
        app.on("openInfo", openInfo = createSpy("openInfo"))
        app.on("openedInfo", openedInfo = createSpy("openedInfo"))
        app.openInfo(entry)

      it "call mapView.build",->
        expect(spy1).toHaveBeenCalled()

      it "call mapView.build with args1",->
        expect(spy1.calls[0].args[0]).toBe(entry.info)

      it "call mapView.build with args2",->
        expect(spy1.calls[0].args[1]).toBe(entry.marker)

      it "fire openInfo event",->
        expect(openInfo).toHaveBeenCalled()

      it "fire openInfo event with argument",->
        expect(openInfo.calls[0].args[0]).toBe(entry)

      it "fire openedInfo event",->
        expect(openedInfo).toHaveBeenCalled()

      it "fire openedInfo event with argument",->
        expect(openedInfo.calls[0].args[0]).toBe(entry)
    #}}}
    describe "::closeInfo",-> #{{{
      spy1 = entry = closeInfo = closedInfo = undefined
      beforeEach ->
        app = new MapList maplistArgs
        app.mapView  = { closeOpenedInfo : spy1 = createSpy("mapView:closeInfo") }
        app.on("closeInfo" , closeInfo  = createSpy("closeInfo"))
        app.on("closedInfo", closedInfo = createSpy("closedInfo"))
        entry = {}
        app.closeInfo(entry)

      it "call mapView.closeOpenedInfo",->
        expect(spy1).toHaveBeenCalled()

      it "fire closeInfo event",->
        expect(closeInfo).toHaveBeenCalled()

      it "fire closeInfo event with argument",->
        expect(closeInfo.calls[0].args[0]).toBe(entry)

      it "fire closeedInfo event",->
        expect(closedInfo).toHaveBeenCalled()

      it "fire closeedInfo event with argument",->
        expect(closedInfo.calls[0].args[0]).toBe(entry)
    #}}}
    describe "::changeGenre",-> #{{{
      spy1 = prop = changeGenre = changedGenre = undefined
      beforeEach ->
        app = new MapList maplistArgs
        app.rebuild = spy1 = createSpy("mapView:openInfo")
        app.on("changeGenre",changeGenre = createSpy("changeGenre"))
        app.on("changedGenre",changedGenre = createSpy("changedGenre"))
        prop = "foo"
        app.changeGenre(prop)

      it "call mapView.build",->
        expect(spy1).toHaveBeenCalled()

      it "call mapView.build with entries",->
        expect(spy1.calls[0].args[0]).toBe(prop)

      it "fire changeGenre event",->
        expect(changeGenre).toHaveBeenCalled()

      it "fire changeGenre event with argument",->
        expect(changeGenre.calls[0].args[0]).toBe(prop)

      it "fire changedGenre event",->
        expect(changedGenre).toHaveBeenCalled()

      it "fire changedGenre event with argument",->
        expect(changedGenre.calls[0].args[0]).toBe(prop)
    #}}}
    describe "::rebuild",-> #{{{
      genreId = undefined
      beforeEach ->
        app = new MapList maplistArgs
        app.entries = {
          unselect: createSpy("unselect")
          select: createSpy("select")
        }
        genreId = "__all__"
        app.rebuild(genreId)

      it "call unselect",->
        expect(app.entries.unselect).toHaveBeenCalled()

      it "call select",->
        expect(app.entries.select).toHaveBeenCalled()

      it "call select with genreId",->
        expect(app.entries.select.calls[0].args[0]).toBe(genreId)
    #}}}
    describe "getMap",-> #{{{
      beforeEach ->
        app = new MapList maplistArgs

      it "return map",->
        expect(app.getMap()).toBe(app.mapView.map)
    #}}}
  describe ".Parser", -> #{{{
    Parser = undefined

    beforeEach ->
      Parser = MapList.Parser

    it "第1引数(parser)を渡すと，@parserにその値が格納される", ->
      obj = {}
      parser = new Parser(obj)
      expect(parser.parser).toBe(obj)

    it "parserがない場合，デフォルトのものを使う", ->
      parser = new Parser
      expect(parser.parser).toBe(Parser.defaultParser)

    describe ".execute", ->
      it "parserに関数を渡した場合，executeでその関数を使う", ->
        identity = (val) -> _(val).map (v)->v-1
        parser = new Parser(identity)
        data = [1..10]
        expect(parser.execute(data)).toEqual([0..9])

      it "parserにObjectを渡した場合，Objectのexecuteメソッドを使う", ->
        myPerser = {
          execute : (val) -> _(val).map (v)->v-1
        }
        parser = new Parser(myPerser)
        data = [1..10]
        expect(parser.execute(data)).toEqual([0..9])

      it "上記2つ以外のparserの場合, Errorを投げる",->
        myPerser = { }
        parser = new Parser(myPerser)
        data = [1..10]
        expect(-> parser.execute(data))
          .toThrow("parser is function or on object with the execute method")

    describe ".defaultParser", -> #{{{

      it "arguments is array", ->
        data = [1..100]
        expect(Parser.defaultParser(data)).toEqual(data)

      it "arguments is xml", ->
        expect(Parser.defaultParser(data.entries.xml)).toEqual(data.entries.object)
    #}}}
    describe ".makeIcon", ->
      it "with object", ->
        src = {
          url: "foo.png"
          anchor:[10,20]
          origin:[44,42]
          size:[55,55]
          scaledSize:[1,1]
        }
        dst = {
          url: "foo.png"
          anchor: new google.maps.Point(10,20)
          origin: new google.maps.Point(44,42)
          size: new google.maps.Size(55,55)
          scaledSize: new google.maps.Size(1,1)
        }

        expect(Parser.makeIcon(src)).toEqual(dst)

      it "with string", ->
        src = "foo.png"
        dst = "foo.png"
        expect(Parser.makeIcon(src)).toEqual(dst)

    describe "finallyParser", ->
      it "with icon data", ->
        src = {
          name : "hoge"
          icon :{
            url: "foo.png"
            anchor:[10,20]
            origin:[44,42]
            size:[55,55]
            scaledSize:[1,1]
          }
          shadow :{
            url: "foo.png"
            anchor:[10,20]
            origin:[44,42]
            size:[55,55]
            scaledSize:[1,1]
          }
        }
        dst = {
          name : "hoge"
          icon :{
            url: "foo.png"
            anchor: new google.maps.Point(10,20)
            origin: new google.maps.Point(44,42)
            size: new google.maps.Size(55,55)
            scaledSize: new google.maps.Size(1,1)
          }
          shadow :{
            url: "foo.png"
            anchor: new google.maps.Point(10,20)
            origin: new google.maps.Point(44,42)
            size: new google.maps.Size(55,55)
            scaledSize: new google.maps.Size(1,1)
          }
        }
        expect(Parser.finallyParser(src)).toEqual(dst)

      it "no icon data", ->
        src = {
          name : "hoge"
        }
        dst = {
          name : "hoge"
        }
        expect(Parser.finallyParser(src)).toEqual(dst)

    describe ".XMLParser", -> #{{{
      parser = undefined
      xml = undefined
      beforeEach ->
        parser = new Parser.XMLParser
        xml = $.parseXML """
        <?xml version="1.0" encoding="UTF-8"?>
        <places>
          <genre id="fruits" name="フルーツ" icon="/fruits.png">
            <place latitude="123" longitude="321" icon="/apple.png">
              <name>A</name>
              <longName>Apple</longName>
            </place>
            <place latitude="111" longitude="222">
              <name>B</name>
              <longName>Banana</longName>
            </place>
          </genre>
        </places>
        """

      it ".getAttribute", ->
        $place = $("place",xml).eq(0)
        ans = {latitude: "123", longitude: "321", icon: "/apple.png"}
        expect(parser.getAttribute($place)).toEqual(ans)

      it ".getContent", ->
        $place = $("place",xml).eq(0)
        ans = {name: "A", longname: "Apple"}
        expect(parser.getContent($place)).toEqual(ans)

      it ".getGenre", ->
        $place = $("place",xml).eq(0)
        ans = {genre: "fruits", genreName: "フルーツ", icon: "/fruits.png"}
        expect(parser.getGenre($place)).toEqual(ans)

      it ".makePlace", ->
        $place = $("place",xml).eq(0)
        ans = {
          genre: "fruits"
          genreName: "フルーツ"
          name: "A"
          longname: "Apple"
          lat: "123"
          lng: "321"
          icon: "/apple.png"
        }
        expect(parser.makePlace($place)).toEqual(ans)

      it ".execute", ->
        ans = [
          {
            genre: "fruits"
            genreName: "フルーツ"
            name: "A"
            longname: "Apple"
            lat: "123"
            lng: "321"
            icon: "/apple.png"
          }
          {
            genre: "fruits"
            genreName: "フルーツ"
            name: "B"
            longname: "Banana"
            lat: "111"
            lng: "222"
            icon: "/fruits.png"
          }
        ]
        expect(parser.execute(xml)).toEqual(ans)
    #}}}
    describe ".ObjectParser", -> #{{{
      parser = undefined
      beforeEach ->
        parser = new Parser.ObjectParser

      it ".execute", ->
        data = [0..10]
        expect(parser.execute(data)).toBe(data)
    #}}}
  #}}}
  describe ".Entry", -> #{{{
    Entry = undefined
    beforeEach ->
      Entry = MapList.Entry

    describe "::makeInfo", ->
      entry = factory = info = undefined
      beforeEach ->
        entry = new Backbone.Model({title:"FooBar"})
        entry.closeInfo = createSpy("closeInfo")
        factory = new MapList.HtmlFactory(_.template,"<%- title %>")
        info = Entry::makeInfo.call(entry,factory)

      it "instanceof InfoWindow",->
        expect(info instanceof google.maps.InfoWindow).toBeTruthy()

      it "make sure that info has content", ->
        expect(info.getContent()).toEqual("FooBar")

      it "fires the closeclick event and execute @closeInfo",->
        google.maps.event.trigger(info,"closeclick")
        expect(entry.closeInfo).toHaveBeenCalled()

    describe "::makeMarker",->
      entry = marker = undefined
      beforeEach ->
        entry = new Backbone.Model({lat:35,lng:135,icon:"icon.png",shadow:"shadow.png"})
        entry.openInfo = createSpy("openInfo")
        entry.info = true
        marker = Entry::makeMarker.call(entry)

      it "instance of Marker",->
        expect(marker instanceof google.maps.Marker).toBeTruthy()

      it "position instanceof LatLng",->
        expect(marker.getPosition() instanceof google.maps.LatLng).toBeTruthy()

      it "check lat",->
        expect(marker.getPosition().lat()).toEqual(35)

      it "check lng",->
        expect(marker.getPosition().lng()).toEqual(135)

      it "check icon",->
        expect(marker.getIcon()).toEqual("icon.png")

      it "check shadow",->
        expect(marker.getShadow()).toEqual("shadow.png")

      it "fires the click event and execute @openInfo",->
        google.maps.event.trigger(marker,"click")
        expect(entry.openInfo).toHaveBeenCalled()

    describe "::makeList", ->
      entry = factory = res = undefined
      beforeEach ->
        entry = new Backbone.Model({title:"FooBar"})
        factory = new MapList.HtmlFactory(_.template,"<div><%- title %></div>")
        res = Entry::makeList.call(entry,factory)

      it "responce itstanceof jQuery",->
        expect(res instanceof jQuery).toBeTruthy()

      it "class is '__list'",->
        expect(res.attr("class")).toEqual("__list")

      it "have entry",->
        expect(res.data("entry")).toBe(entry)

    describe "::isSelect",->
      # 普通にentry作っちゃってよかったな...
      it "have not lat & lng",->
        entry = new Backbone.Model
        expect(Entry::isSelect.call(entry,"foo")).toBeFalsy()

      it "properties equal {}", ->
        entry = new Backbone.Model {lat:35,lng:135}
        expect(Entry::isSelect.call(entry,{})).toBeTruthy()

      it "by genreId true", ->
        entry = new Backbone.Model {lat:35,lng:135,genre:"foo"}
        expect(Entry::isSelect.call(entry,{genre:"foo"})).toBeTruthy()

      it "by genreId false", ->
        entry = new Backbone.Model {lat:35,lng:135,genre:"foo"}
        expect(Entry::isSelect.call(entry,{genre:"bar"})).toBeFalsy()

    describe "triger check",->
      entry = undefined
      beforeEach ->
        entry = new Backbone.Model

      it "::openInfo",->
        entry.on "openinfo",(args)-> expect(args).toBe(entry)
        Entry::openInfo.call(entry)

      it "::closeInfo",->
        entry.on "closeinfo",(args)-> expect(args).toBe(entry)
        Entry::closeInfo.call(entry)

    describe "constructor",->
      attributes = options = entry = undefined
      beforeEach ->
        attributes = {}

      describe "yes template",->
        beforeEach ->
          options = MapList::makeOptions {infoTemplate:"bar", listTemplate:"bar"}
          entry = new Entry(attributes,options)

        it "instance check info",->
          expect(entry.info instanceof google.maps.InfoWindow).toBeTruthy()

        it "instance check marker",->
          expect(entry.marker instanceof google.maps.Marker).toBeTruthy()

        it "instance check list",->
          expect(entry.list instanceof jQuery).toBeTruthy()

  #}}}
  describe ".Entries", -> #{{{
    Entries = undefined
    obj = options = entries = prop = undefined

    beforeEach ->
      Entries = MapList.Entries
      obj = data.entries.object
      options = MapList::makeOptions {}
      entries = new Entries( obj, options )
      prop = {genre:"関東"}

    describe "constructor", ->

      it "is instanceof Backbone.Collection", ->
        expect(entries instanceof Backbone.Collection).toBeTruthy()

      it "attributes check",->
        expect(entries.toJSON()).toEqual(obj)

      it "make sure that selectedList is empty",->
        expect(entries.selectedList).toEqual([])

    describe "::select",->

      it "return selected List",->
        responce = entries.select(prop)
        answer = _(obj).where(prop)
        expect(_(responce).map (entry)->entry.toJSON()).toEqual(answer)

      it "chche selected List",->
        responce = entries.select(prop)
        expect(entries.selectedList).toBe(responce)

      it "fires the select event",->
        spy = createSpy("select")
        entries.on "select", spy
        responce = entries.select(prop)
        expect(spy).toHaveBeenCalled()

      it "fires the select event with arguments:0",->
        spy = createSpy("select")
        entries.on "select", spy
        responce = entries.select(prop)
        expect(spy.calls[0].args[0]).toBe(responce)

    describe "::unselect",->
      it "return empty array",->
        expect(entries.unselect()).toEqual([])

      it "chche selected List to empty",->
        entries.select(prop) # make non empty chche
        expect(entries.unselect()).toBe(entries.selectedList)

      it "fires the unselect event",->
        spy = createSpy('unselect')
        entries.on "unselect", spy
        responce = entries.unselect()
        expect(spy).toHaveBeenCalled()

    ###
    describe "::selected",->
      it "return cached selectedList",->
        responce = entries.select(prop)
        expect(entries.selected()).toBe(responce)
    ###

    describe ".getSource", ->
      it "array", ->
        source = Entries.getSource(obj)
        source.then (data)->
          expect(data).toEqual(obj)

      it "url:json", ->
        source = Entries.getSource("data/entries.json")
        waitsFor( =>
          source.state() == "resolved"
        , "timeout", 1000 )
        runs =>
          source.then (data)=>
            expect(data).toEqual(obj)

      it "url:xml", ->
        source = Entries.getSource("data/entries.xml")
        waitsFor( =>
          source.state() == "resolved"
        , "timeout", 1000 )
        runs =>
          source.then (data)->
            expect(data).toEqual(obj)
  #}}}
  describe ".HtmlFactory", -> #{{{
    obj = template = factory = HtmlFactory = undefined
    beforeEach ->
      HtmlFactory = MapList.HtmlFactory
      obj = { title: "FooBar" }

    describe "by _.template;",->
      beforeEach ->
        template = "<p><%- title %></p>"
        factory = new HtmlFactory(_.template,template)

      it "template unchange",->
        expect(factory.template).toEqual(template)

      it "getTemplateEngineName", ->
        expect(factory.getTemplateEngineName()).toEqual("_.template")

      it "template chche",->
        backup = _.template
        spyOn(_,'template').andCallThrough()
        factory = new HtmlFactory(_.template,template)
        factory.make(obj)
        factory.make(obj)
        expect(_.template.calls.length).toEqual(1)
        _.template = backup

      it "make", ->
        answer = "<p>FooBar</p>"
        expect(factory.make(obj)).toEqual(answer)

    describe "by $.tmpl;", ->
      beforeEach ->
        template = "<p>${title}</p>"
        factory = new HtmlFactory($.tmpl,template)

      it "template wrap",->
        answer = "<wrap>#{template}</wrap>"
        expect(factory.template).toEqual(answer)

      it "getTemplateEngineName", ->
        expect(factory.getTemplateEngineName()).toEqual("$.tmpl")

      #it "template nochche",->
      #  backup = $.tmpl
      #  spyOn($,'tmpl').andCallThrough()
      #  factory = new HtmlFactory($.tmpl,template)
      #  factory.make(obj)
      #  factory.make(obj)
      #  expect($.tmpl.calls.length).toEqual(2)
      #  $.tmpl = backup

      it "make", ->
        answer = "<p>FooBar</p>"
        expect(factory.make(obj)).toEqual(answer)
  #}}}
  describe ".MapView",-> #{{{
    options = mapView = entries = undefined
    beforeEach ->
      options = MapList::makeOptions {}
      mapView = new MapList.MapView(options)
      entries = new MapList.Entries(data.entries.object,options)

    afterEach ->
      $("#map_canvas").children().remove()

    describe "constructor",->
      it "instance of Backbone.View",->
        expect(mapView instanceof Backbone.View).toBeTruthy()

      it "google maps create",->
        expect(mapView.map instanceof google.maps.Map).toBeTruthy()

    describe "::build",->
      setMap = undefined
      beforeEach ->
        setMap = createSpy("setMap")
        entries.each (entry) -> entry.marker.setMap = setMap
        mapView.fitBounds = createSpy("fitBounds")

      it "execute entry.marker.setMap",->
        mapView.build(entries.models)
        expect(setMap.calls.length).toEqual(entries.length)

      it "execute entry.marker.setMap with @map",->
        mapView.build(entries.models)
        expect(setMap.calls[0].args[0]).toBe(mapView.map)

      it "execute @fitBounds if @options.doFit == true",->
        mapView.build(entries.models)
        expect(mapView.fitBounds).toHaveBeenCalled()

      it "execute @fitBounds with entries",->
        mapView.build(entries.models)
        expect(mapView.fitBounds.calls[0].args[0]).toBe(entries.models)

    describe "::fitBounds",->
      # あとで実装

    describe "::clear",->
      setMap = undefined
      beforeEach ->
        setMap = createSpy("setMap")
        entries.each (entry) -> entry.marker.setMap = setMap
        mapView.closeOpenedInfo = createSpy("closeOpenedInfo")
        mapView.clear(entries.models)

      it "execute @closeOpenedInfo",->
        expect(mapView.closeOpenedInfo).toHaveBeenCalled()

      it "execute entry.marker.setMap",->
        expect(setMap.calls.length).toEqual(entries.length)

      it "execute entry.marker.setMap with null",->
        expect(setMap.calls[0].args[0]).toBe(null)

    describe "::openInfo",->
      info = marker = eventSpy = undefined
      beforeEach ->
        mapView.closeOpenedInfo = createSpy("closeOpenedInfo")
        info = { open: createSpy("open") }
        marker = 'marker'
        mapView.openInfo(info,marker)

      it "execute @closeOpenedInfo",->
        expect(mapView.closeOpenedInfo).toHaveBeenCalled()

      it "execute info.open", ->
        expect(info.open).toHaveBeenCalled()

      it "execute info.open with 0:@map", ->
        expect(info.open.calls[0].args[0]).toBe(mapView.map)

      it "execute info.open with 1:marker", ->
        expect(info.open.calls[0].args[1]).toBe(marker)

      it "chche @openedInfo",->
        expect(mapView.openedInfo).toBe(info)

    describe "closeOpenedInfo",->
      close = undefined
      beforeEach ->
        close = createSpy("close")
        mapView.openedInfo = { close }
        mapView.closeOpenedInfo()

      it "execute openedInfo.close",->
        expect(close).toHaveBeenCalled()

      it "nonchche openedInfo", ->
        expect(mapView.openedInfo).toBe(null)
  #}}}
  describe ".ListView",-> #{{{
    listView = options = undefined
    beforeEach ->
      options = MapList::makeOptions {listTemplate:"bar"}
      listView = new MapList.ListView(options)

    describe "constructor",->
      it "is instanceof Backbone.View",->
        expect(listView instanceof Backbone.View).toBeTruthy()

      it "check @$el is jQuey object",->
        expect(listView.$el instanceof jQuery).toBeTruthy()

      it "check @$el.selector",->
        expect(listView.$el.selector).toEqual(options.listSelector)

    describe "build",->
      entries = appendTo = undefined
      beforeEach ->
        entries = new MapList.Entries(data.entries.object,options)
        appendTo = createSpy("appendTo")
        entries.each (entry)-> entry.list.appendTo = appendTo
        listView.build(entries.models)

      it "execute entry.list.appendTo",->
        expect(appendTo).toHaveBeenCalled()

      it "execute entry.list.appendTo width @$el",->
        expect(appendTo.calls[0].args[0]).toBe(listView.$el)

    describe "clear",->
      entries = detach = undefined
      beforeEach ->
        entries = new MapList.Entries(data.entries.object,options)
        detach = createSpy("detach")
        entries.each (entry)-> entry.list.appendTo = detach
        listView.build(entries.models)

      it "execute entry.list.appendTo",->
        expect(detach).toHaveBeenCalled()

    describe "openInfo",->
      $elem = spy = undefined
      beforeEach ->
        selector = options.openInfoSelector
        spy = createSpy("openInfo")
        e = { currentTarget : $("<div>").data(options.genreDataName, "foo")[0] }
        $elem = $("<div class='__list'><a class='#{selector[1..-1]}'></a></div>")
          .on("click",selector, listView.openInfo)
          .data("entry",{ openInfo: spy })
          .find(selector)
          .trigger("click")

      it "execute openInfo of entry",->
        expect(spy).toHaveBeenCalled()
  #}}}
  describe ".GenreView",-> #{{{
    genreView = options = undefined
    beforeEach ->
      options = MapList::makeOptions {}
      genreView = new MapList.GenresView(options)

    describe "constructor",->
      it "is instanceof Backbone.View",->
        expect(genreView instanceof Backbone.View).toBeTruthy()

      it "check @$el is jQuey object",->
        expect(genreView.$el instanceof jQuery).toBeTruthy()

      it "check @$el.selector",->
        expect(genreView.$el.selector).toEqual(options.genresSelector)

    describe "::selectGenre",->
      $elem = spy = undefined
      beforeEach ->
        wrap = $("<div id='genre'>").data(options.genreGroup,"group")
        target = $("<div>").data(options.genreDataName, "foo").appendTo(wrap)
        e = { currentTarget : target[0] }
        genreView.trigger = spy = createSpy("change:genre")
        genreView.selectGenre(e)

      it "fire change:genre event",->
        expect(spy).toHaveBeenCalled()

      it "fire change:genre event with 0:eventName",->
        expect(spy.calls[0].args[0]).toEqual("change:genre")

      it "fire change:genre event with 1:properties",->
        expect(spy.calls[0].args[1]).toEqual({group:"foo"})

      it "fire change:genre event with 1:properties default key",->
        genreView = new MapList.GenresView(options)
        wrap = $("<div id='genre'>")
        target = $("<div>").data(options.genreDataName, "foo").appendTo(wrap)
        e = { currentTarget : target[0] }
        genreView.trigger = spy = createSpy("change:genre")
        genreView.selectGenre(e)
        expect(spy.calls[0].args[1]).toEqual({genre:"foo"})

  #}}}
