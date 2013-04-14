// Generated by CoffeeScript 1.6.2
/*
MapList JavaScript Library v1.2.1
http://github.com/jimon93/maplist.js

Require Library
  jquery.js
  jquery.tmpl.js
  underscore.js

MIT License
*/


(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  (function($, global) {
    var App, Entries, Entry, Genres, HtmlFactory, List, Map, Parser, log, _ref, _ref1;

    log = _.bind(console.log, console);
    App = (function() {
      App.prototype["default"] = function() {
        return {
          lat: 35,
          lng: 135,
          zoom: 4,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          data: [],
          mapSelector: '#map_canvas',
          listSelector: '#list',
          listTemplate: null,
          infoTemplate: null,
          openInfoSelector: '.open-info',
          genreAlias: 'genre',
          genresSelector: '#genre',
          genreSelector: 'a',
          genreDataName: "target-genre",
          firstGenre: '__all__',
          infoOpened: null,
          beforeBuild: null,
          afterBuild: null,
          beforeClear: null,
          afterClear: null,
          doFit: true,
          fitZoomReset: false,
          toMapScroll: true,
          templateEngine: $.tmpl || _.template
        };
      };

      App.prototype.usingEntries = [];

      function App(options) {
        this["default"] = __bind(this["default"], this);
        var source,
          _this = this;

        _.bindAll(this);
        this.options = this.makeOptions(options);
        this.map = new Map(this.options);
        source = Entries.getSource(this.options.data, this.options.parser);
        $.when(this.map, source).then(function(map, models) {
          return _this.entries = new Entries(models, _this.options);
        });
      }

      App.prototype.makeOptions = function(options) {
        var center, templates;

        center = {
          center: new google.maps.LatLng(options.lat, options.lng)
        };
        options = _.extend({}, _(this).result('default'), center, _.clone(options));
        templates = {
          infoHtmlFactory: new HtmlFactory(options.templateEngine, options.infoTemplate),
          listHtmlFactory: new HtmlFactory(options.templateEngine, options.listTemplate)
        };
        return _.extend(options, templates);
      };

      App.prototype.build = function(genreId) {
        var _base, _base1,
          _this = this;

        if (typeof (_base = this.options).beforeBuild === "function") {
          _base.beforeBuild(genreId);
        }
        this.usingEntries = _(this.entries.list).filter(function(entry) {
          return entry.isSelect(genreId);
        });
        this.map.build(this.usingEntries);
        this.list.build(this.usingEntries);
        return typeof (_base1 = this.options).afterBuild === "function" ? _base1.afterBuild(genreId, this.usingEntries) : void 0;
      };

      App.prototype.clear = function() {
        var _base, _base1;

        if (typeof (_base = this.options).beforeClear === "function") {
          _base.beforeClear();
        }
        this.map.clear(this.usingEntries);
        this.list.clear(this.usingEntries);
        return typeof (_base1 = this.options).afterClear === "function" ? _base1.afterClear() : void 0;
      };

      App.prototype.rebuild = function(genreId) {
        this.clear();
        return this.build(genreId);
      };

      App.prototype.getMap = function() {
        return this.maplist.map;
      };

      return App;

    })();
    Parser = (function() {
      function Parser(parser) {
        this.parser = parser;
        _.bindAll(this);
        if (this.parser == null) {
          this.parser = Parser.defaultParser;
        }
      }

      Parser.prototype.execute = function(data) {
        if (_.isFunction(this.parser)) {
          return this.parser(data);
        } else if (this.parser.execute != null) {
          return this.parser.execute(data);
        } else {
          throw "parser is function or on object with the execute method";
        }
      };

      Parser.defaultParser = function(data) {
        var parser;

        if ($.isXMLDoc(data)) {
          parser = new Parser.XMLParser;
          return parser.execute(data);
        } else if (_.isObject(data)) {
          parser = new Parser.ObjectParser;
          return parser.execute(data);
        } else {
          throw "Illegal Argument Error";
        }
      };

      return Parser;

    })();
    Parser.XMLParser = (function() {
      XMLParser.prototype["default"] = function() {
        return {
          place: "place",
          genre: "genre"
        };
      };

      function XMLParser(options) {
        _.bindAll(this);
        this.options = _.extend({}, _(this).result('default'), options);
      }

      XMLParser.prototype.execute = function(data) {
        var $root, place, _i, _len, _ref, _results;

        $root = $(">*", data).eq(0);
        _ref = $root.find(this.options.place).get();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          place = _ref[_i];
          _results.push(this.makePlace($(place)));
        }
        return _results;
      };

      XMLParser.prototype.makePlace = function($place) {
        return _({}).chain().extend(this.getGenre($place), this.getContent($place), this.getAttribute($place)).tap(function(obj) {
          if ((obj.lat == null) && (obj.latitude != null)) {
            obj.lat = obj.latitude;
          }
          if ((obj.lng == null) && (obj.longitude != null)) {
            return obj.lng = obj.longitude;
          }
        }).omit("latitude", "longitude").value();
      };

      XMLParser.prototype.getGenre = function($place) {
        var $genre;

        $genre = $place.closest(this.options.genre);
        if ($genre.size() === 1) {
          return _(this.getAttribute($genre)).chain().tap(function(obj) {
            obj.genre = obj.id;
            return obj.genreName = obj.name;
          }).omit("id", "name").value();
        } else {
          return {};
        }
      };

      XMLParser.prototype.getContent = function($place) {
        var elem, res, _i, _len, _ref;

        res = {};
        _ref = $place.children().get();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          elem = _ref[_i];
          res[elem.nodeName.toLowerCase()] = $(elem).text();
        }
        return res;
      };

      XMLParser.prototype.getAttribute = function($place) {
        var attr, res, _i, _len, _ref;

        res = {};
        _ref = $place.get(0).attributes;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          attr = _ref[_i];
          if (attr !== "id" && attr !== "name") {
            res[attr.name] = attr.value;
          }
        }
        return res;
      };

      return XMLParser;

    })();
    Parser.ObjectParser = (function() {
      function ObjectParser() {}

      ObjectParser.prototype.execute = function(data) {
        return data;
      };

      return ObjectParser;

    })();
    Entry = (function(_super) {
      __extends(Entry, _super);

      function Entry() {
        _ref = Entry.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Entry.prototype.initialize = function(attributes, options) {
        _.bindAll(this);
        this.info = this.makeInfo(options.infoHtmlFactory);
        this.marker = this.makeMarker();
        return this.list = this.makeList(options.listHtmlFactory);
      };

      Entry.prototype.openInfo = function() {
        return this.trigger('oepnInfo');
      };

      Entry.prototype.makeInfo = function(infoHtmlFactory) {
        var content, info;

        content = infoHtmlFactory.make(this.toJSON());
        if (content != null) {
          info = new google.maps.InfoWindow({
            content: content
          });
          google.maps.event.addListener(info, 'closeclick', this.openInfo);
          return info;
        }
      };

      Entry.prototype.makeMarker = function() {
        var marker, position;

        position = new google.maps.LatLng(this.get('lat'), this.get('lng'));
        marker = new google.maps.Marker({
          position: position,
          icon: this.get('icon'),
          shadow: this.get('shadow')
        });
        if (this.info != null) {
          google.maps.event.addListener(marker, 'click', this.openInfo);
        }
        return marker;
      };

      Entry.prototype.makeList = function(listHtmlFactory) {
        var $content, content;

        content = listHtmlFactory.make(this.toJSON());
        if (content != null) {
          $content = $(content).addClass(".__entryElem");
          $content.find(".open-info").data("entry", this);
          return $content;
        }
      };

      Entry.prototype.isSelect = function(genreId) {
        switch (genreId) {
          case "__all__":
            return true;
          default:
            return genreId === this.attributes.genre;
        }
      };

      return Entry;

    })(Backbone.Model);
    Entries = (function(_super) {
      __extends(Entries, _super);

      function Entries() {
        _ref1 = Entries.__super__.constructor.apply(this, arguments);
        return _ref1;
      }

      Entries.prototype.model = Entry;

      Entries.getSource = function(data, parser) {
        var dfd,
          _this = this;

        parser = new Parser(parser);
        dfd = new $.Deferred;
        if (_.isArray(data)) {
          dfd.resolve(data);
        } else if (_.isString(data)) {
          $.ajax({
            url: data
          }).then(function(data) {
            return dfd.resolve(parser.execute(data));
          }, function() {
            return dfd.reject();
          });
        } else {
          dfd.reject();
        }
        return dfd.promise();
      };

      return Entries;

    })(Backbone.Collection);
    HtmlFactory = (function() {
      function HtmlFactory(templateEngine, template) {
        this.templateEngine = templateEngine;
        this.template = template;
      }

      HtmlFactory.prototype.make = function(object) {
        var res;

        if (!((this.templateEngine != null) || (this.template != null))) {
          return null;
        }
        res = this.templateEngine(this.template, object);
        if (res.html != null) {
          res = res.html();
        }
        return res;
      };

      return HtmlFactory;

    })();
    Map = (function() {
      function Map(options) {
        var canvas;

        this.options = options;
        _.bindAll(this);
        canvas = $(this.options.mapSelector).get(0);
        this.map = new google.maps.Map(canvas, this.options);
      }

      Map.prototype.build = function(entries) {
        var bounds, entry, _i, _len;

        if (this.options.doFit) {
          bounds = new google.maps.LatLngBounds;
        }
        for (_i = 0, _len = entries.length; _i < _len; _i++) {
          entry = entries[_i];
          entry.marker.setMap(this.map);
          if (this.options.doFit) {
            bounds.extend(entry.marker.getPosition());
          }
        }
        if (this.options.doFit) {
          if (!this.options.fitZoomReset) {
            return this.map.fitBounds(bounds);
          } else {
            this.map.setCenter(bounds.getCenter());
            return this.map.setZoom(this.options.zoom);
          }
        }
      };

      Map.prototype.clear = function(entries) {
        var entry, _i, _len, _results;

        _results = [];
        for (_i = 0, _len = entries.length; _i < _len; _i++) {
          entry = entries[_i];
          this.closeOpenedInfo();
          _results.push(entry.marker.setMap(null));
        }
        return _results;
      };

      Map.prototype.openInfo = function(info, marker) {
        var _base;

        this.closeOpenedInfo();
        info.open(this.map, marker);
        this.openedInfo = info;
        return typeof (_base = this.options).infoOpened === "function" ? _base.infoOpened(marker, info) : void 0;
      };

      Map.prototype.closeOpenedInfo = function() {
        if (this.openedInfo != null) {
          this.openedInfo.close();
          return this.openedInfo = null;
        }
      };

      return Map;

    })();
    List = (function() {
      function List(options) {
        this.options = options;
        this.$el = $(this.options.listSelector);
        this.$el.on("click", this.options.openInfoSelector, this.openInfo);
      }

      List.prototype.build = function(entries) {
        var entry, _i, _len, _ref2, _results;

        _results = [];
        for (_i = 0, _len = entries.length; _i < _len; _i++) {
          entry = entries[_i];
          _results.push((_ref2 = entry.list) != null ? _ref2.appendTo(this.$el) : void 0);
        }
        return _results;
      };

      List.prototype.clear = function(entries) {
        var entry, _i, _len, _ref2, _results;

        _results = [];
        for (_i = 0, _len = entries.length; _i < _len; _i++) {
          entry = entries[_i];
          _results.push((_ref2 = entry.list) != null ? _ref2.detach() : void 0);
        }
        return _results;
      };

      List.prototype.openInfo = function(e) {
        var $target;

        $target = $(e.currentTarget);
        $target.data("entry").openInfo();
        return false;
      };

      return List;

    })();
    Genres = (function() {
      function Genres(options, app) {
        this.app = app;
        this.$el = $(options.genresSelector);
        this.$el.on("click", options.genreSelector, this.selectGenre);
      }

      Genres.prototype.selectGenre = function(e, genreId) {
        var $target;

        if (genreId == null) {
          $target = $(e.currentTarget);
          genreId = $target.data(this.options.genreDataName);
        }
        this.app.rebuild(genreId);
        return false;
      };

      return Genres;

    })();
    global.MapList = App;
    App.Entries = Entries;
    return App.Parser = Parser;
  })(jQuery, this);

}).call(this);
