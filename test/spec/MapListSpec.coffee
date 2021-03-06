log = (args...)-> console?.log?(args...)
describe "MapList", ->
  beforeEach ->
    @createSpy = jasmine.createSpy
    @createSpyObj = jasmine.createSpyObj
    @data = { #{{{
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
  describe "App", -> #{{{
    beforeEach -> #{{{
      @maplist = new MapList
    #}}}
    describe "::create",-> #{{{
      it "return MapList instance",->
        expect(MapList.create() instanceof MapList).toBeTruthy()
    #}}}
    describe ".start",-> #{{{
      beforeEach ->
        spyOn(@maplist.entries, "reset")
        @result = @maplist.start([])

      it "call @entries.reset",->
        expect(@maplist.entries.reset).toHaveBeenCalled()

      it "return value",->
        expect(@result).toBe(@maplist)
    #}}}
    describe ".build",-> #{{{
      beforeEach ->
        spyOn(@maplist.mapView, "build")
        spyOn(@maplist.listView, "build")
        @maplist.on("beforeBuild", @before = @createSpy(""))
        @maplist.on("afterBuild" , @after  = @createSpy(""))
        @prop = @maplist.getProperties()
        @result = @maplist.build( @entries = "entries" )

      it "call other methods",->
        expect(@maplist.mapView.build).toHaveBeenCalled()
        expect(@maplist.listView.build).toHaveBeenCalled()

      it "fire events",->
        expect(@before).toHaveBeenCalled()
        expect(@before.calls[0].args).toEqual([@entries,@prop])
        expect(@after).toHaveBeenCalled()
        expect(@after.calls[0].args).toEqual([@entries,@prop])

      it "return value",->
        expect(@result).toBe(@maplist)
    #}}}
    describe ".clear",-> #{{{
      beforeEach ->
        spyOn(@maplist.mapView, "clear")
        spyOn(@maplist.listView, "clear")
        @maplist.on("beforeClear", @before = @createSpy(""))
        @maplist.on("afterClear" , @after  = @createSpy(""))
        @result = @maplist.clear()

      it "call other methods",->
        expect(@maplist.mapView.clear).toHaveBeenCalled()
        expect(@maplist.listView.clear).toHaveBeenCalled()

      it "fire events",->
        expect(@before).toHaveBeenCalled()
        expect(@after).toHaveBeenCalled()

      it "return value",->
        expect(@result).toBe(@maplist)
    #}}}
    describe ".openInfo",-> #{{{
      beforeEach ->
        spyOn(@maplist.mapView, "openInfo")
        @maplist.on("openInfo", @before = @createSpy(""))
        @maplist.on("openedInfo", @after = @createSpy(""))
        @entry = { info: "info", marker: "marker" }
        @result = @maplist.openInfo(@entry)

      it "call other methods",->
        expect(@maplist.mapView.openInfo).toHaveBeenCalled()

      it "fire events",->
        expect(@before).toHaveBeenCalled()
        expect(@after).toHaveBeenCalled()

      it "return value",->
        expect(@result).toBe(@maplist)
    #}}}
    describe ".closeInfo",-> #{{{
      beforeEach ->
        spyOn(@maplist.mapView, "closeOpenedInfo")
        @maplist.on("closeInfo", @before = @createSpy(""))
        @maplist.on("closedInfo", @after = @createSpy(""))
        @result = @maplist.closeInfo()

      it "call other methods",->
        expect(@maplist.mapView.closeOpenedInfo).toHaveBeenCalled()

      it "fire events",->
        expect(@before).toHaveBeenCalled()
        expect(@after).toHaveBeenCalled()

      it "return value",->
        expect(@result).toBe(@maplist)
    #}}}
    describe ".changeGenre",-> #{{{
      beforeEach ->
        @maplist.changeGenre("key","init")
        @maplist.changeGenre("foo","bar")
        spyOn(@maplist, "changeProperties")

      it "common",->
        @maplist.changeGenre("key","val")
        expect(@maplist.changeProperties).toHaveBeenCalled()
        expect(@maplist.changeProperties.calls[0].args[0]).toEqual( {key:"val", foo:"bar"} )

      it "fire events",->
        @maplist.on("changeGenre", before = @createSpy(""))
        @maplist.on("changedGenre", after = @createSpy(""))
        @maplist.changeGenre("key","val")
        expect(before).toHaveBeenCalled()
        expect(after).toHaveBeenCalled()

      it "when val is undefined",->
        @maplist.changeGenre("key")
        expect(@maplist.changeProperties.calls[0].args[0]).toEqual( {foo:"bar"} )

      it "when val is '__all__'",->
      it "when val is undefined",->
        @maplist.changeGenre("key","__all__")
        expect(@maplist.changeProperties.calls[0].args[0]).toEqual( {foo:"bar"} )

      it "return value",->
        result = @maplist.changeGenre("key","val")
        expect(result).toBe(@maplist)
    #}}}
    describe ".changeProperties",-> #{{{
      beforeEach ->
        spyOn(@maplist, "rebuild")
        @maplist.on("changeProperties", @before = @createSpy(""))
        @maplist.on("changedProperties", @after = @createSpy(""))
        @result = @maplist.changeProperties(@obj = {})

      it "call other methods",->
        expect(@maplist.rebuild).toHaveBeenCalled()
        expect(@maplist.rebuild.calls[0].args[0]).toBe(@obj)

      it "fire events",->
        expect(@before).toHaveBeenCalled()
        expect(@after).toHaveBeenCalled()

      it "return value",->
        expect(@result).toBe(@maplist)
    #}}}
    describe ".rebuild",-> #{{{
      beforeEach ->
        spyOn(@maplist.entries, "unselect")
        spyOn(@maplist.entries, "select")
        @result = @maplist.rebuild(@prop = {})

      it "call other methods",->
        expect(@maplist.entries.unselect).toHaveBeenCalled()
        expect(@maplist.entries.select).toHaveBeenCalled()
        expect(@maplist.entries.select.calls[0].args[0]).toBe(@prop)

      it "return value",->
        expect(@result).toBe(@maplist)
    #}}}
    describe ".getMap",-> #{{{
      it "common",->
        expect(@maplist.getMap()).toBe(@maplist.mapView.map)
        expect(@maplist.getMap() instanceof google.maps.Map).toBeTruthy()
    #}}}
    describe ".getProperties",-> #{{{
      it "common",->
        expect(@maplist.getProperties()).toBe(@maplist.entries.properties)
    #}}}
  #}}}
  describe "Options", -> #{{{
    beforeEach -> #{{{
      @Options = MapList.Options
    #}}}
    it "without my options", -> #{{{
      options = new @Options
      expect(options.mapSelector).toBe(@Options.defaults().mapSelector)
    #}}}
    it "with my options", -> #{{{
      myOptions = {mapSelector: "#map"}
      options = new @Options(myOptions)
      expect(options.mapSelector).toBe(myOptions.mapSelector)
    #}}}
  #}}}
  describe "AppDelegator", -> #{{{
    beforeEach -> #{{{
      @AppDelegator = MapList.AppDelegator
    #}}}
    it "execute",->
      delegator = new @AppDelegator
      app = new MapList
      app.entries.on =  @createSpy("")
      app.genresView.on =  @createSpy("")
      delegator.execute(app)
      expect(app.entries.on).toHaveBeenCalled()
      expect(app.genresView.on).toHaveBeenCalled()
  #}}}
  describe "Source", -> #{{{
    beforeEach -> #{{{
      @Source = MapList.Source
      @waitFunc = =>
        @result.state() == "resolved"
      @runFunc = =>
        @result.then (data)=>
          expect(data).toEqual(@data.entries.object)
    #}}}
    describe ".get",->
      it "common",->
        source = new @Source([], {})
        result = source.get()
        expect(_.isFunction result.then).toBeTruthy()
        expect(_.isFunction result.done).toBeTruthy()
        expect(_.isFunction result.fail).toBeTruthy()

      it "data is Array",->
        obj = @data.entries.object
        source = new @Source(obj, {})
        @result = source.get()
        waitsFor(@waitFunc , "timeout", 100 )
        runs(@runFunc)

      it "data is URL String :json",->
        source = new @Source("data/entries.json", {})
        @result = source.get()
        waitsFor(@waitFunc , "timeout", 100 )
        runs(@runFunc)

      it "data is URL String :xml",->
        source = new @Source("data/entries.xml", {})
        @result = source.get()
        waitsFor(@waitFunc , "timeout", 100 )
        runs(@runFunc)
  #}}}
  describe "Parser", -> #{{{
    beforeEach -> #{{{
      @Parser = MapList.Parser
    #}}}
    describe "constructor",-> #{{{
      it "common", ->
        options = Object.create(null)
        parser = new @Parser(options)
        expect(parser.options).toBe(options)

    #}}}
    describe ".execute",-> #{{{
      it "return Object",->
        @parser = new @Parser
        result = @parser.execute({})
        expect(result instanceof Object).toBeTruthy()
    #}}}
    describe ".parse",->#{{{
      beforeEach ->#{{{
        @parser = new @Parser
      #}}}
      it "when parser is function",-> #{{{
        func = @createSpy("")
        @parser.parse({}, func)
        expect(func).toHaveBeenCalled()
      #}}}
      it "when parser is object with execute method",->#{{{
        obj = {execute: @createSpy("")}
        @parser.parse({}, obj)
        expect(obj.execute).toHaveBeenCalled()
      #}}}
      it "when other parse",->#{{{
        func = -> @parser.parse({}, null)
        expect(func).toThrow()
      #}}}
    #}}}
    describe ".getParserSequence",->#{{{
      it "common",->
        @parser = new @Parser
        result = @parser.getParserSequence()
        expect(_.isArray(result)).toBeTruthy()
    #}}}
    describe ".getCommonParser",->#{{{
      it "common", ->
        @parser = new @Parser
        result = @parser.getCommonParser()
        expect(result instanceof @Parser.DefaultParser).toBeTruthy()

      it "with options", ->
        obj = {}
        @parser = new @Parser({parser: obj})
        result = @parser.getCommonParser()
        expect(result).toBe(obj)
    #}}}
    describe ".getAfterParser",->#{{{
      it "common", ->
        @parser = new @Parser
        result = @parser.getAfterParser()
        expect(result).toBe(_.identity)

      it "with options", ->
        obj = {}
        @parser = new @Parser({afterParser: obj})
        result = @parser.getAfterParser()
        expect(result).toBe(obj)
    #}}}
  #}}}
  describe "Parser::DefaultParser", -> #{{{
    beforeEach -> #{{{
      @DefaultParser = MapList.Parser.DefaultParser
    #}}}
    describe ".execute",->
      it "xml data",->
        parser = new @DefaultParser({})
        result = parser.execute(@data.entries.xml)
        expect(result).toEqual(@data.entries.object)

      it "object data",->
        parser = new @DefaultParser({})
        result = parser.execute(@data.entries.object)
        expect(result).toEqual(@data.entries.object)

      it "other data", ->
        parser = new @DefaultParser({})
        func = -> parser.execute(null)
        expect(func).toThrow()
  #}}}
  describe "Parser::MapIconDecorator", -> #{{{
    beforeEach -> #{{{
      @MapIconDecorator = MapList.Parser.MapIconDecorator
      @decorator = new @MapIconDecorator
    #}}}

    describe "execute",->
      it "common",->
        @decorator.makeIcon = @createSpy("")
        data = [{icon:true, shadow:true},{icon:true}]
        @decorator.execute(data)
        expect(@decorator.makeIcon).toHaveBeenCalled()
        expect(@decorator.makeIcon.calls.length).toEqual(3)

    describe "makeIcon",->
      it "common",->
        data =
          origin: [1,2]
          anchor: [9,9]
          size: [4,2]
          scaledSize: [5,7]
          other: 42
        result = @decorator.makeIcon(data)
        expect(result).not.toBe(data)
        expect(result.origin instanceof google.maps.Point).toBeTruthy()
        expect(result.anchor instanceof google.maps.Point).toBeTruthy()
        expect(result.size instanceof google.maps.Size).toBeTruthy()
        expect(result.scaledSize instanceof google.maps.Size).toBeTruthy()
        expect(result.other).toEqual(data.other)
  #}}}
  describe "Parser::XMLParser", -> #{{{
    it "execute",->
      parser = new MapList.Parser.XMLParser
      result = parser.execute(@data.entries.xml)
      expect(result).toEqual(@data.entries.object)
  #}}}
  describe "Parser::ObjectParser", -> #{{{
    it "execute",->
      parser = new MapList.Parser.ObjectParser
      result = parser.execute(@data.entries.object)
      expect(result).toEqual(@data.entries.object)
  #}}}
  describe "Entry", -> #{{{
    beforeEach ->
      @Entry = MapList.Entry

    describe ".view",->
      beforeEach ->
        options = new MapList.Options {infoTemplate:"<div>info</div>", listTemplate:"<div>list</div>"}
        @entry = new @Entry {}, options

      it "info",->
        expect(@entry.view('info') instanceof google.maps.InfoWindow).toBeTruthy()

      it "marker",->
        expect(@entry.view('marker') instanceof google.maps.Marker).toBeTruthy()

      it "list",->
        expect(@entry.view('list') instanceof jQuery).toBeTruthy()


    describe ".isExistPoint",->
      beforeEach ->
        class @MyEntry extends @Entry
          makeInfo:->
          makeMarker:->
          makeList:->

      it "true case", ->
        entry = new @MyEntry {lat:35,lng:135}
        expect(entry.isExistPoint()).toBeTruthy()

      it "false case", ->
        entry = new @MyEntry {}
        expect(entry.isExistPoint()).toBeFalsy()
        entry = new @MyEntry {lat:0}
        expect(entry.isExistPoint()).toBeFalsy()
        entry = new @MyEntry {lat:35,lng:NaN}
        expect(entry.isExistPoint()).toBeFalsy()


    describe ".isSelect",->
      MyEntry = undefined
      beforeEach ->
        class MyEntry extends @Entry
          makeInfo:->
          makeMarker:->
          makeList:->

      it "have not lat & lng",->
        entry = new MyEntry
        expect(entry.isSelect({})).toBeFalsy()

      it "properties equal {}", ->
        entry = new MyEntry {lat:35,lng:135}
        expect(entry.isSelect({})).toBeTruthy()

      it "by genreId true", ->
        entry = new MyEntry {lat:35,lng:135,genre:"foo"}
        expect(entry.isSelect({genre:"foo"})).toBeTruthy()

      it "by genreId false", ->
        entry = new MyEntry {lat:35,lng:135,genre:"foo"}
        expect(entry.isSelect({genre:"bar"})).toBeFalsy()

    describe "triger check",->
      entry = undefined
      beforeEach ->
        entry = new Backbone.Model

      it "::openInfo",->
        entry.on "openinfo",(args)-> expect(args).toBe(entry)
        @Entry::openInfo.call(entry)

      it "::closeInfo",->
        entry.on "closeinfo",(args)-> expect(args).toBe(entry)
        @Entry::closeInfo.call(entry)

    describe "constructor",->
      it "instance check views",->
        entry = new @Entry
        expect(entry.views instanceof MapList.EntryViews).toBeTruthy()
  #}}}
  describe "EntryViews",-> #{{{
    beforeEach ->
      @entry = new MapList.Entry {lat: 35, lng: 135, icon: "icon.png", shadow: "shadow.png"}
      @entry.closeInfo = @createSpy('closeInfo')
      @entry.openInfo = @createSpy('openInfo')
      options = new MapList.Options {infoTemplate:"<div>info</div>", listTemplate:"<div>list</div>"}
      @views = new MapList.EntryViews( @entry, options )

    describe ".createInfo", ->
      beforeEach ->
        @info = @views.createInfo()

      it "instanceof InfoWindow",->
        expect(@info instanceof google.maps.InfoWindow).toBeTruthy()

      it "make sure that info has content", ->
        expect(@info.getContent()).toEqual("<div>info</div>")

      it "fires the closeclick event and execute @closeInfo",->
        google.maps.event.trigger(@info,"closeclick")
        expect(@entry.closeInfo).toHaveBeenCalled()

    describe ".createMarker",->
      beforeEach ->
        @marker = @views.createMarker()

      it "instance of Marker",->
        expect(@marker instanceof google.maps.Marker).toBeTruthy()

      it "position instanceof LatLng",->
        expect(@marker.getPosition() instanceof google.maps.LatLng).toBeTruthy()

      it "check lat",->
        expect(@marker.getPosition().lat()).toEqual(35)

      it "check lng",->
        expect(@marker.getPosition().lng()).toEqual(135)

      it "check icon",->
        expect(@marker.getIcon()).toEqual("icon.png")

      it "check shadow",->
        expect(@marker.getShadow()).toEqual("shadow.png")

      it "fires the click event and execute @openInfo",->
        google.maps.event.trigger(@marker,"click")
        expect(@entry.openInfo).toHaveBeenCalled()

    describe ".createList", ->
      beforeEach ->
        @res = @views.createList()

      it "responce itstanceof jQuery",->
        expect(@res instanceof jQuery).toBeTruthy()

      it "class is '__list'",->
        expect(@res.attr("class")).toEqual("__list")

      it "have entry",->
        expect(@res.data("entry")).toBe(@entry)
  #}}}
  describe "Entries", -> #{{{
    beforeEach ->
      options = new MapList.Options
      @entries = new MapList.Entries @data.entries.object, options
      @prop = {genre: "関東"}

    describe ".select",->
      it "return selected List", ->
        res = @entries.select @prop
        ans = _(@data.entries.object).where(@prop)
        expect(_(res).map (entry)->entry.toJSON()).toEqual(ans)

      it "Cache selected list", ->
        res = @entries.select @prop
        expect(@entries.selectedList).toBe(res)

      it "Cache propertirs", ->
        res = @entries.select @prop
        expect(@entries.properties).toBe(@prop)

      it "fires the select event",->
        spy = @createSpy("select")
        @entries.on "select", spy
        @entries.select(@prop)
        expect(spy).toHaveBeenCalled()

      it "fires the select event with arguments:0",->
        spy = @createSpy("select")
        @entries.on "select", spy
        responce = @entries.select(@prop)
        expect(spy.calls[0].args[0]).toBe(responce)

    describe ".unselect",->
      it "fires the unselect event",->
        spy = @createSpy("unselect")
        @entries.on "unselect", spy
        @entries.unselect()
        expect(spy).toHaveBeenCalled()

      it "cache selectedList is clear",->
        @entries.unselect()
        expect(@entries.selectedList).toEqual([])

  #}}}
  describe "HtmlFactory", -> #{{{
    beforeEach ->
      @HtmlFactory = MapList.HtmlFactory

    describe "::create",->
      it "when template is undefined",->
        result = @HtmlFactory.create()
        expect(result instanceof @HtmlFactory.Null).toBeTruthy()

      it "when templateEngine is _.template",->
        result = @HtmlFactory.create(_.template, "")
        expect(result instanceof @HtmlFactory.Underscore).toBeTruthy()

      it "when templateEngine is $.tmpl",->
        result = @HtmlFactory.create($.tmpl, "")
        expect(result instanceof @HtmlFactory.Jquery).toBeTruthy()

      it "when templateEngine is other",->
        result = @HtmlFactory.create(null, "")
        expect(result instanceof @HtmlFactory.Null).toBeTruthy()

    describe "getTemplateEngineName",->
      it "engine is _.template", ->
        result = @HtmlFactory.getTemplateEngineName(_.template)
        expect(result).toEqual("_.template")

      it "engine is _.template", ->
        result = @HtmlFactory.getTemplateEngineName($.tmpl)
        expect(result).toEqual("$.tmpl")

      it "engine is other", ->
        result = @HtmlFactory.getTemplateEngineName(null)
        expect(result).toEqual("other")

  #}}}
  describe "HtmlFactory::Null", -> #{{{
    beforeEach ->
      @factory = new MapList.HtmlFactory.Null

    it ".make", ->
      result = @factory.make()
      expect(result).toBeNull()
  #}}}
  describe "HtmlFactory::Underscore", -> #{{{
    beforeEach ->
      template = "<div><%- name %></div>"
      @factory = new MapList.HtmlFactory.Underscore(template)

    it ".make", ->
      result = @factory.make({name: "Bob"})
      expect(result).toEqual("<div>Bob</div>")
  #}}}
  describe "HtmlFactory::Jquery", -> #{{{
    beforeEach ->
      template = "<div>${name}</div>"
      @factory = new MapList.HtmlFactory.Jquery(template)

    it ".make", ->
      result = @factory.make({name: "Bob"})
      expect(result).toEqual("<div>Bob</div>")
  #}}}
  describe "MapView", -> #{{{
    beforeEach ->
      @options = new MapList.Options {infoTemplate:"<div>info</div>", listTemplate:"<div>list</div>"}
      @mapView = new MapList.MapView(@options)
      @entries = new MapList.Entries(@data.entries.object, @options)

    afterEach ->
      $("#map_canvas").children().remove()

    describe "constructor",->
      it "instance of Backbone.View",->
        expect(@mapView instanceof Backbone.View).toBeTruthy()

      it "google maps create",->
        expect(@mapView.map instanceof google.maps.Map).toBeTruthy()

    describe ".build",->
      beforeEach ->
        @setMap = @createSpy("setMap")
        @entries.each (entry) => entry.view('marker').setMap = @setMap
        @mapView.fitBounds = @createSpy("fitBounds")

      it "execute entry.marker.setMap",->
        @mapView.build(@entries.models)
        expect(@setMap.calls.length).toEqual(@entries.length)

      it "execute entry.marker.setMap with @map",->
        @mapView.build(@entries.models)
        expect(@setMap.calls[0].args[0]).toBe(@mapView.map)

      it "execute @fitBounds if @options.doFit == true",->
        @mapView.build(@entries.models)
        expect(@mapView.fitBounds).toHaveBeenCalled()

      it "execute @fitBounds with entries",->
        @mapView.build(@entries.models)
        expect(@mapView.fitBounds.calls[0].args[0]).toBe(@entries.models)

    describe ".clear",->
      beforeEach ->
        @setMap = @createSpy("setMap")
        @entries.each (entry) => entry.view('marker').setMap = @setMap
        @mapView.closeOpenedInfo = @createSpy("closeOpenedInfo")
        @mapView.clear(@entries.models)

      it "execute @closeOpenedInfo",->
        expect(@mapView.closeOpenedInfo).toHaveBeenCalled()

      it "execute entry.marker.setMap",->
        expect(@setMap.calls.length).toEqual(@entries.length)

      it "execute entry.marker.setMap with null",->
        expect(@setMap.calls[0].args[0]).toBe(null)

    describe ".openInfo",->
      beforeEach ->
        @info = { open: @createSpy("open") }
        @marker = 'marker'
        @entry = {
          view: (type)=>
            switch type
              when "info" then @info
              when "marker" then @marker
        }
        @mapView.openInfo(@entry)

      it "execute info.open", ->
        expect(@info.open).toHaveBeenCalled()

      it "execute info.open with 0:@map", ->
        expect(@info.open.calls[0].args[0]).toBe(@mapView.map)

      it "execute info.open with 1:marker", ->
        expect(@info.open.calls[0].args[1]).toBe(@marker)

      it "chche @openedInfo",->
        expect(@mapView.openedInfoEntry).toBe(@entry)

    describe ".closeOpenedInfo",->
      beforeEach ->
        @close = @createSpy("close")
        @mapView.openedInfoEntry = new MapList.Entry({}, @options)
        @mapView.openedInfoEntry.view('info').close = @close
        @mapView.closeOpenedInfo()

      it "execute openedInfo.close",->
        expect(@close).toHaveBeenCalled()

      it "nonchche openedInfo", ->
        expect(@mapView.openedInfoEntry).toBe(null)
  #}}}
  describe "ListView", -> #{{{
    beforeEach ->
      @options = new MapList.Options
      @ListView = MapList.ListView
      @listView = new @ListView(@options)

    describe "constructor",->
      it "$el is jQuey Object",->
        expect(@listView.$el instanceof jQuery).toBeTruthy()

      it "$el selector",->
        expect(@listView.$el.selector).toEqual(@options.listSelector)

    describe ".build",->
    describe ".clear",->
    describe ".openInfo",->
  #}}}
  describe "GenresView", -> #{{{
    beforeEach ->
      @options = new MapList.Options
      @genreView = new MapList.GenresView(@options)

    describe "constructor",->
      it "check @$el is jQuey object",->
        expect(@genreView.$el instanceof jQuery).toBeTruthy()

      it "check @$el.selector",->
        expect(@genreView.$el.selector).toEqual(@options.genresSelector)

    describe ".selectGenre",->
      describe "custom genre key",->
        beforeEach ->
          wrap = $("<div id='genre'>").data(@options.genreGroup,"group")
          target = $("<div>").data(@options.genreDataName, "foo").appendTo(wrap)
          event = { currentTarget : target[0] }
          @genreView.trigger = @spy = @createSpy("change:genre")
          @genreView.selectGenre(event)

        it "fire change:genre event",->
          expect(@spy).toHaveBeenCalled()

        it "fire change:genre event with 0:eventName",->
          expect(@spy.calls[0].args[0]).toEqual("change:genre")

        it "fire change:genre event with 1:properties",->
          expect(@spy.calls[0].args[1]).toEqual("group")

        it "fire change:genre event with 2:properties",->
          expect(@spy.calls[0].args[2]).toEqual("foo")

      describe "default genre key",->
        beforeEach ->
          wrap = $("<div id='genre'>")
          target = $("<div>").data(@options.genreDataName, "foo").appendTo(wrap)
          event = { currentTarget : target[0] }
          @genreView.trigger = @spy = @createSpy("change:genre")
          @genreView.selectGenre(event)

        it "fire change:genre event",->
          expect(@spy).toHaveBeenCalled()

        it "fire change:genre event with 0:eventName",->
          expect(@spy.calls[0].args[0]).toEqual("change:genre")


        it "fire change:genre event with 1:properties",->
          expect(@spy.calls[0].args[1]).toEqual("genre")

        it "fire change:genre event with 2:properties",->
          expect(@spy.calls[0].args[2]).toEqual("foo")

  #}}}

