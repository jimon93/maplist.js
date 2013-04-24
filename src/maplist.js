// Generated by CoffeeScript 1.6.2
/*
MapList JavaScript Library v1.4.1
http://github.com/jimon93/maplist.js

Require Library
  jquery.js
  jquery.tmpl.js
  underscore.js
  backbone.js

MIT License
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  (function($, global) {
    var App, Entries, Entry, GenresView, HtmlFactory, ListView, MapView, Parser, log, _ref, _ref1, _ref2, _ref3, _ref4;

    log = _.bind(console.log, console);
    App = (function() {
      _.extend(App.prototype, Backbone.Events);

      App.prototype["default"] = function() {
        return {
          data: [],
          mapSelector: '#map_canvas',
          lat: 35,
          lng: 135,
          zoom: 4,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          canFitBounds: true,
          fixedZoom: false,
          listSelector: "#list",
          listTemplate: null,
          openInfoSelector: '.open-info',
          infoTemplate: null,
          genresSelector: '#genre',
          genreSelector: 'a',
          genreGroup: "target-group",
          genreDataName: "target-genre",
          firstGenre: {},
          templateEngine: $.tmpl || _.template,
          parser: null,
          afterParser: null
        };
      };

      function App(options, initFunc) {
        _.bindAll(this);
        this.options = this.makeOptions(options);
        this.mapView = new MapView(this.options);
        this.listView = new ListView(this.options);
        this.genresView = new GenresView(this.options);
        this.entries = new Entries(null, this.options);
        this.delegateEvents();
        if (typeof initFunc === "function") {
          initFunc(this);
        }
        if (this.options.data != null) {
          this.data(this.options.data);
        }
      }

      App["new"] = function(options, initFunc) {
        return new this(options, initFunc);
      };

      App.prototype.data = function(data) {
        var _this = this;

        Entries.getSource(data, this.options.parser, this.options.afterParser).then(function(models) {
          return _this.entries.reset(models, _this.options);
        });
        return this;
      };

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
        this.entries.on("select", this.build);
        this.entries.on("unselect", this.clear);
        this.entries.on("openinfo", this.openInfo);
        this.entries.on("closeinfo", this.closeInfo);
        this.genresView.on("change:genre", this.changeGenre);
        return this;
      };

      App.prototype.build = function(entries) {
        var prop, _base, _base1;

        prop = this.entries.properties;
        this.trigger('beforeBuild', prop, entries);
        if (typeof (_base = this.options).beforeBuild === "function") {
          _base.beforeBuild(prop, enrries);
        }
        this.mapView.build(entries);
        this.listView.build(entries);
        this.trigger('afterBuild', prop, entries);
        if (typeof (_base1 = this.options).afterBuild === "function") {
          _base1.afterBuild(prop, entries);
        }
        return this;
      };

      App.prototype.clear = function() {
        var entries, _base, _base1;

        entries = this.entries.selectedList;
        this.trigger("beforeClear", entries);
        if (typeof (_base = this.options).beforeClear === "function") {
          _base.beforeClear();
        }
        this.mapView.clear(entries);
        this.listView.clear(entries);
        this.trigger("afterClear", entries);
        if (typeof (_base1 = this.options).afterClear === "function") {
          _base1.afterClear();
        }
        return this;
      };

      App.prototype.openInfo = function(entry) {
        this.trigger('openInfo', entry);
        this.mapView.openInfo(entry.info, entry.marker);
        this.trigger('openedInfo', entry);
        return this;
      };

      App.prototype.closeInfo = function(entry) {
        this.trigger('closeInfo', entry);
        this.mapView.closeOpenedInfo();
        this.trigger('closedInfo', entry);
        return this;
      };

      App.prototype.changeGenre = function(prop) {
        this.trigger('changeGenre', prop);
        this.rebuild(prop);
        this.trigger('changedGenre', prop);
        return this;
      };

      App.prototype.rebuild = function(prop) {
        this.entries.unselect();
        this.entries.select(prop);
        return this;
      };

      App.prototype.getMap = function() {
        return this.mapView.map;
      };

      return App;

    })();
    Parser = (function() {
      function Parser(parser, afterParser) {
        this.parser = parser;
        this.afterParser = afterParser;
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
        if (_.isFunction(this.afterParser)) {
          result = this.afterParser(result);
        }
        return result = Parser.finallyParser(result);
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

      Entry.prototype.isSelect = function(properties) {
        if (!((this.get('lat') != null) && (this.get('lng') != null))) {
          return false;
        }
        if (_.isEmpty(properties)) {
          return true;
        }
        return _([this.toJSON()]).findWhere(properties) != null;
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
        var firstGenre;

        this.options = options;
        _.bindAll(this);
        this.selectedList = [];
        firstGenre = this.options.firstGenre;
        this.properties = (function() {
          if (_.isObject(firstGenre)) {
            return firstGenre;
          } else if (_.isString(firstGenre)) {
            switch (firstGenre) {
              case "__all__":
                return {};
              default:
                return {
                  genre: firstGenre
                };
            }
          }
        })();
        return this.on("reset", _.bind(this.select, this, null));
      };

      Entries.prototype.select = function(properties) {
        var iterator,
          _this = this;

        this.properties = properties != null ? properties : this.properties;
        iterator = function(entry) {
          return entry.isSelect(_this.properties);
        };
        return this.selectedList = _(Entries.__super__.select.call(this, iterator)).tap(function(entries) {
          return _this.trigger("select", entries);
        });
      };

      Entries.prototype.unselect = function() {
        this.trigger("unselect");
        return this.selectedList = [];
      };

      Entries.getSource = function(data, parser, afterParser) {
        var dfd,
          _this = this;

        parser = new Parser(parser, afterParser);
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
        if (this.template == null) {
          this.engine = function() {
            return null;
          };
        } else {
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
        if (this.options.canFitBounds) {
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
        if (this.options.fixedZoom) {
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
        return this.openedInfo = info;
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
        this.selector = this.options.genresSelector;
        this.$el = $(this.selector);
        this.$el.on("click", this.selector, this.selectGenre);
        return this.properties = {};
      };

      GenresView.prototype.selectGenre = function(e) {
        var $group, $target, key, val;

        $target = $(e.currentTarget);
        $group = $target.closest(this.selector);
        key = $group.data(this.options.genreGroup) || "genre";
        val = $target.data(this.options.genreDataName);
        this.properties[key] = val;
        this.trigger("change:genre", this.properties);
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
