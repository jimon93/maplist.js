describe "MapList", ->
	describe ".Parser", ->
		describe ".ObjectParser", ->
			it "execute",->
				parser = new MapList.Parser.ObjectParser
				data = {ans:42, foo:"FOO"}
				expect(parser.execute(data)).toBe(data)
