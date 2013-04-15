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
  }
  matcher:{
    toDeepEqual: (expected)->
      _.isEqual(this.actual, expected)
  }
} #}}}

describe "MapList", ->
  #beforeEach ->
  #  this.addMatchers(data.matcher)

  describe ".Entries", -> #{{{
    Entries = undefined
    ans = undefined

    beforeEach ->
      Entries = MapList.Entries
      ans = data.entries.object

    it "get source ( array )", ->
      source = Entries.getSource(ans)
      source.then (data)->
        expect(data).toEqual(ans)

    it "@getSource ( url:json )", ->
      source = Entries.getSource("data/entries.json")
      waitsFor( =>
        source.state() == "resolved"
      , "timeout", 1000 )
      runs =>
        source.then (data)=>
          expect(data).toEqual(ans)

    it "@getSource ( url:xml )", ->
      source = Entries.getSource("data/entries.xml")
      waitsFor( =>
        source.state() == "resolved"
      , "timeout", 1000 )
      runs =>
        source.then (data)->
          expect(data).toEqual(ans)
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
        expect(Parser.defaultParser(xml)).toEqual(ans)
    #}}}
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


