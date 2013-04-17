// Generated by CoffeeScript 1.6.2
/*
MapList JavaScript Library v1.2.15
http://github.com/jimon93/maplist.js

Require Library
  jquery.js
  jquery.tmpl.js
  underscore.js

MIT License
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  (function($, global) {
    var App, Entries, Entry, GenresView, HtmlFactory, ListView, MapView, Parser, log, _ref, _ref1, _ref2, _ref3, _ref4;

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
          templateEngine: $.tmpl || _.template
        };
      };

      function App(options) {
        var func, name, source, _ref,
          _this = this;

        _.bindAll(this);
        _ref = this.eventMethods;
        for (name in _ref) {
          func = _ref[name];
          this.eventMethods[name] = _.bind(func, this);
        }
        this.options = this.makeOptions(options);
        this.mapView = new MapView(this.options);
        this.listView = new ListView(this.options);
        this.genresView = new GenresView(this.options);
        source = Entries.getSource(this.options.data, this.options.parser);
        $.when(this.map, source).then(function(map, models) {
          _this.entries = new Entries(models, _this.options);
          _this.delegateEvents();
          return _this.rebuild(_this.options.firstGenre);
        });
      }

      App.prototype.makeOptions = function(options) {
        return this.extendOptions(this.extendDefaultOptions(options));
      };

      App.prototype.extendDefaultOptions = function(options) {
        if (options == null) {
          options = {};
        }
        return options = _.extend({}, _(this).result('default'), options);
      };

      App.prototype.extendOptions = function(options) {
        var center, templates;

        center = {
          center: new google.maps.LatLng(options.lat, options.lng)
        };
        templates = {
          infoHtmlFactory: new HtmlFactory(options.templateEngine, options.infoTemplate),
          listHtmlFactory: new HtmlFactory(options.templateEngine, options.listTemplate)
        };
        return _.extend(center, options, templates);
      };

      App.prototype.delegateEvents = function() {
        this.entries.on("select", this.eventMethods.entries_select);
        this.entries.on("unselect", this.eventMethods.entries_unselect);
        this.entries.on("openinfo", this.eventMethods.openInfo);
        this.mapView.on("openedInfo", this.eventMethods.openedInfo);
        this.entries.on("closeinfo", this.eventMethods.closeInfo);
        return this.genresView.on("change:genre", this.eventMethods.changeGenre);
      };

      App.prototype.eventMethods = {
        entries_select: function(entries) {
          this.mapView.build(entries);
          return this.listView.build(entries);
        },
        entries_unselect: function(entries) {
          this.mapView.clear(entries);
          return this.listView.clear(entries);
        },
        openInfo: function(entry) {
          return this.mapView.openInfo(entry.info, entry.marker);
        },
        openedInfo: function(info, marker) {},
        closeInfo: function(entry) {
          return this.mapView.closeOpenedInfo();
        },
        changeGenre: function(genreId) {
          return this.rebuild(genreId);
        }
      };

      App.prototype.build = function(genreId) {
        var _base, _base1;

        if (typeof (_base = this.options).beforeBuild === "function") {
          _base.beforeBuild(genreId);
        }
        this.entries.select(genreId);
        return typeof (_base1 = this.options).afterBuild === "function" ? _base1.afterBuild(genreId, this.entries.selected()) : void 0;
      };

      App.prototype.clear = function() {
        var _base, _base1;

        if (typeof (_base = this.options).beforeClear === "function") {
          _base.beforeClear();
        }
        this.entries.unselect();
        return typeof (_base1 = this.options).afterClear === "function" ? _base1.afterClear() : void 0;
      };

      App.prototype.rebuild = function(genreId) {
        this.clear();
        return this.build(genreId);
      };

      App.prototype.getMap = function() {
        return this.mapView.map;
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
        var result;

        result = (function() {
          if (_.isFunction(this.parser)) {
            return this.parser(data);
          } else if (this.parser.execute != null) {
            return this.parser.execute(data);
          } else {
            throw "parser is function or on object with the execute method";
          }
        }).call(this);
        return Parser.finallyParser(result);
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

      Parser.finallyParser = function(data) {
        if (data.icon != null) {
          data.icon = this.makeIcon(data.icon);
        }
        if (data.shadow != null) {
          data.shadow = this.makeIcon(data.shadow);
        }
        return data;
      };

      Parser.makeIcon = function(data) {
        var key, val;

        if (_.isObject(data)) {
          data = _.clone(data);
          for (key in data) {
            val = data[key];
            switch (key) {
              case "origin":
              case "anchor":
                data[key] = (function(func, args, ctor) {
                  ctor.prototype = func.prototype;
                  var child = new ctor, result = func.apply(child, args);
                  return Object(result) === result ? result : child;
                })(google.maps.Point, val, function(){});
                break;
              case "size":
              case "scaledSize":
                data[key] = (function(func, args, ctor) {
                  ctor.prototype = func.prototype;
                  var child = new ctor, result = func.apply(child, args);
                  return Object(result) === result ? result : child;
                })(google.maps.Size, val, function(){});
            }
          }
        }
        return data;
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
            if (obj.id != null) {
              obj.genre = obj.id;
            }
            if (obj.name != null) {
              return obj.genreName = obj.name;
            }
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
        return this.trigger('openinfo', this);
      };

      Entry.prototype.closeInfo = function() {
        return this.trigger('closeinfo', this);
      };

      Entry.prototype.makeInfo = function(infoHtmlFactory) {
        var content, info;

        content = infoHtmlFactory.make(this.toJSON());
        if (content != null) {
          info = new google.maps.InfoWindow({
            content: content
          });
          google.maps.event.addListener(info, 'closeclick', this.closeInfo);
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
        var content;

        content = listHtmlFactory.make(this.toJSON());
        if (content != null) {
          return $(content).addClass("__list").data("entry", this);
        }
      };

      Entry.prototype.isSelect = function(genreId) {
        if (!((this.get('lat') != null) && (this.get('lng') != null))) {
          false;
        }
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

      Entries.prototype.initialize = function(source, options) {
        _.bindAll(this);
        return this.selectedList = [];
      };

      Entries.prototype.select = function(prop) {
        var iterator,
          _this = this;

        iterator = function(entry) {
          return entry.isSelect(prop);
        };
        return this.selectedList = _(Entries.__super__.select.call(this, iterator)).tap(function(entries) {
          return _this.trigger("select", entries);
        });
      };

      Entries.prototype.unselect = function() {
        this.trigger("unselect", this.selected());
        return this.selectedList = [];
      };

      Entries.prototype.selected = function() {
        return this.selectedList;
      };

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
        switch (this.getTemplateEngineName()) {
          case "_.template":
            this.engine = this.templateEngine(this.template);
            break;
          case "$.tmpl":
            this.template = "<wrap>" + this.template + "</wrap>";
            this.engine = _.bind(this.templateEngine, this, this.template);
            break;
          default:
            this.engine = _.bind(this.templateEngine, this, this.template);
        }
      }

      HtmlFactory.prototype.make = function(object) {
        var res;

        if (!((this.templateEngine != null) && (this.template != null))) {
          return null;
        }
        res = this.engine(object);
        if (res.html != null) {
          res = res.html();
        }
        return res;
      };

      HtmlFactory.prototype.getTemplateEngineName = function() {
        if (((typeof _ !== "undefined" && _ !== null ? _.template : void 0) != null) && _.template === this.templateEngine) {
          return "_.template";
        } else if ((($ != null ? $.tmpl : void 0) != null) && $.tmpl === this.templateEngine) {
          return "$.tmpl";
        } else {
          return "other";
        }
      };

      return HtmlFactory;

    })();
    MapView = (function(_super) {
      __extends(MapView, _super);

      function MapView() {
        _ref2 = MapView.__super__.constructor.apply(this, arguments);
        return _ref2;
      }

      MapView.prototype.initialize = function() {
        var canvas;

        _.bindAll(this);
        canvas = $(this.options.mapSelector).get(0);
        return this.map = new google.maps.Map(canvas, this.options);
      };

      MapView.prototype.build = function(entries) {
        var entry, _i, _len;

        for (_i = 0, _len = entries.length; _i < _len; _i++) {
          entry = entries[_i];
          entry.marker.setMap(this.map);
        }
        if (this.options.doFit) {
          return this.fitBounds(entries);
        }
      };

      MapView.prototype.fitBounds = function(entries) {
        var bounds, entry, _i, _len;

        bounds = new google.maps.LatLngBounds;
        for (_i = 0, _len = entries.length; _i < _len; _i++) {
          entry = entries[_i];
          bounds.extend(entry.marker.getPosition());
        }
        if (this.options.fitZoomReset) {
          this.map.setCenter(bounds.getCenter());
          return this.map.setZoom(this.options.zoom);
        } else {
          return this.map.fitBounds(bounds);
        }
      };

      MapView.prototype.clear = function(entries) {
        var entry, _i, _len, _results;

        this.closeOpenedInfo();
        _results = [];
        for (_i = 0, _len = entries.length; _i < _len; _i++) {
          entry = entries[_i];
          _results.push(entry.marker.setMap(null));
        }
        return _results;
      };

      MapView.prototype.openInfo = function(info, marker) {
        this.closeOpenedInfo();
        info.open(this.map, marker);
        this.openedInfo = info;
        return this.trigger('openedInfo', info, marker);
      };

      MapView.prototype.closeOpenedInfo = function() {
        if (this.openedInfo != null) {
          this.openedInfo.close();
          return this.openedInfo = null;
        }
      };

      return MapView;

    })(Backbone.View);
    ListView = (function(_super) {
      __extends(ListView, _super);

      function ListView() {
        _ref3 = ListView.__super__.constructor.apply(this, arguments);
        return _ref3;
      }

      ListView.prototype.initialize = function() {
        _.bindAll(this);
        this.$el = $(this.options.listSelector);
        return this.$el.on("click", this.options.openInfoSelector, this.openInfo);
      };

      ListView.prototype.build = function(entries) {
        var entry, _i, _len, _ref4, _results;

        _results = [];
        for (_i = 0, _len = entries.length; _i < _len; _i++) {
          entry = entries[_i];
          _results.push((_ref4 = entry.list) != null ? _ref4.appendTo(this.$el) : void 0);
        }
        return _results;
      };

      ListView.prototype.clear = function(entries) {
        var entry, _i, _len, _ref4, _results;

        _results = [];
        for (_i = 0, _len = entries.length; _i < _len; _i++) {
          entry = entries[_i];
          _results.push((_ref4 = entry.list) != null ? _ref4.detach() : void 0);
        }
        return _results;
      };

      ListView.prototype.openInfo = function(e) {
        var $target;

        $target = $(e.currentTarget);
        $target.closest(".__list").data("entry").openInfo();
        return false;
      };

      return ListView;

    })(Backbone.View);
    GenresView = (function(_super) {
      __extends(GenresView, _super);

      function GenresView() {
        _ref4 = GenresView.__super__.constructor.apply(this, arguments);
        return _ref4;
      }

      GenresView.prototype.initialize = function() {
        _.bindAll(this);
        this.$el = $(this.options.genresSelector);
        return this.$el.on("click", this.options.genreSelector, this.selectGenre);
      };

      GenresView.prototype.selectGenre = function(e) {
        var $target, genreId;

        $target = $(e.currentTarget);
        genreId = $target.data(this.options.genreDataName);
        this.trigger("change:genre", genreId);
        return false;
      };

      return GenresView;

    })(Backbone.View);
    return global.MapList = _.extend(App, {
      Parser: Parser,
      Entry: Entry,
      Entries: Entries,
      HtmlFactory: HtmlFactory,
      MapView: MapView,
      ListView: ListView,
      GenresView: GenresView
    });
  })(jQuery, this);

}).call(this);
