describe "MapList", ->
  describe ".Parser", ->
    Parser = null

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

