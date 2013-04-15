describe "MapList", ->
  describe ".Entries", ->
    Entries = undefined
    ans = undefined
    beforeEach ->
      Entries = MapList.Entries
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

    it "@getSource ( array )", ->
      source = Entries.getSource([1..100])
      source.then (data)->
        expect(data).toEqual([1..100])

    it "@getSource ( url:json )", ->
      source = Entries.getSource("entries.json")
      waitsFor( =>
        source.state() == "resolved"
      , "timeout", 1000 )
      runs =>
        source.then (data)=>
          expect(data).toEqual(ans)

    it "@getSource ( url:xml )", ->
      source = Entries.getSource("entries.xml")
      waitsFor( =>
        source.state() == "resolved"
      , "timeout", 1000 )
      runs =>
        source.then (data)->
          expect(data).toEqual(ans)

  describe ".Parser", ->
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

    describe ".defaultParser", ->

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

    describe ".XMLParser", ->
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

    describe ".ObjectParser", ->
      parser = undefined
      beforeEach ->
        parser = new Parser.ObjectParser

      it ".execute", ->
        data = [0..10]
        expect(parser.execute(data)).toBe(data)



