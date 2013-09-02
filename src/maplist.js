// Generated by CoffeeScript 1.6.3
/*
MapList JavaScript Library v1.6.0
http://github.com/jimon93/maplist.js

Require Library
  jquery.js
  underscore.js
  backbone.js

Options Library
  jquery.tmpl.js

MIT License
*/


(function() {
  var __slice = [].slice,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  (function($, global) {
    var App, AppDelegator, Entries, Entry, EntryInfo, EntryListItem, EntryMarker, EntryViews, EntryViewsCollection, Events, GenresView, HtmlFactory, ListView, MainViews, MapView, Options, Parser, Source, log, _ref, _ref1, _ref2, _ref3, _ref4;
    log = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return typeof console !== "undefined" && console !== null ? typeof console.log === "function" ? console.log.apply(console, args) : void 0 : void 0;
    };
    Events = (function() {
      function Events() {}

      _.extend(Events.prototype, Backbone.Events);

      return Events;

    })();
    App = (function(_super) {
      __extends(App, _super);

      function App(options, initFunc) {
        this.rebuild = __bind(this.rebuild, this);
        this.changeProperties = __bind(this.changeProperties, this);
        this.changeGenre = __bind(this.changeGenre, this);
        this.closeInfo = __bind(this.closeInfo, this);
        this.openInfo = __bind(this.openInfo, this);
        this.clear = __bind(this.clear, this);
        this.build = __bind(this.build, this);
        this.getProperties = __bind(this.getProperties, this);
        this.getSelectedEntries = __bind(this.getSelectedEntries, this);
        this.getMap = __bind(this.getMap, this);
        this.start = __bind(this.start, this);
        var delegator;
        this.options = new Options(options);
        this.mainViews = new MainViews(this.options);
        this.entries = new Entries(null, this.options);
        delegator = new AppDelegator(this.options);
        delegator.execute(this);
        if (typeof initFunc === "function") {
          initFunc(this);
        }
        if (this.options.data != null) {
          this.start(this.options.data);
        }
      }

      App.create = function(options, initFunc) {
        return new App(options, initFunc);
      };

      App.prototype.start = function(data) {
        var func, source,
          _this = this;
        func = function(models) {
          return _this.entries.reset(models, _this.options);
        };
        source = new Source(data, this.options);
        source.get().then(func);
        return this;
      };

      App.prototype.data = App.prototype.start;

      App.prototype.getMap = function() {
        return this.mainViews.getMap();
      };

      App.prototype.getSelectedEntries = function() {
        return this.entries.selectedList;
      };

      App.prototype.getProperties = function() {
        return this.entries.properties;
      };

      App.prototype.build = function(entries) {
        var prop;
        prop = this.getProperties();
        this.trigger('beforeBuild', entries, prop);
        this.mainViews.build(entries);
        this.trigger('afterBuild', entries, prop);
        return this;
      };

      App.prototype.clear = function() {
        var entries, properties;
        entries = this.getSelectedEntries();
        properties = this.getProperties();
        this.trigger("beforeClear", entries, properties);
        this.mainViews.clear(entries);
        this.trigger("afterClear", entries, properties);
        return this;
      };

      App.prototype.openInfo = function(entry) {
        this.trigger('openInfo', entry);
        this.mainViews.openInfo(entry);
        this.trigger('openedInfo', entry);
        return this;
      };

      App.prototype.closeInfo = function() {
        var entry;
        entry = this.mainViews.mapView.openedInfoEntry;
        this.trigger('closeInfo', entry);
        this.mainViews.closeInfo();
        this.trigger('closedInfo', entry);
        return this;
      };

      App.prototype.changeGenre = function(key, val) {
        var prev, properties;
        prev = _.extend({}, this.getProperties());
        properties = _.isUndefined(val) || val === "__all__" ? _.omit(prev, key) : _(prev).tap(function(obj) {
          return obj[key] = val;
        });
        this.trigger('changeGenre', key, val);
        this.changeProperties(properties);
        this.trigger('changedGenre', key, val);
        return this;
      };

      App.prototype.changeProperties = function(properties) {
        this.trigger('changeProperties', properties);
        this.rebuild(properties);
        this.trigger('changedProperties', properties);
        return this;
      };

      App.prototype.rebuild = function(prop) {
        this.entries.unselect();
        this.entries.select(prop);
        return this;
      };

      return App;

    })(Events);
    Options = (function() {
      var _this = this;

      function Options(options) {
        if (options == null) {
          options = {};
        }
        _.extend(this, Options.extendOptions(Options.extendDefaultOptions(options)));
      }

      Options.defaults = function() {
        var _ref;
        return {
          data: [],
          mapSelector: '#map_canvas',
          lat: 35,
          lng: 135,
          zoom: 4,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          canFitBounds: true,
          fixedZoom: false,
          maxFitZoom: 16,
          listSelector: "#list",
          listTemplate: null,
          openInfoSelector: '.open-info',
          infoTemplate: null,
          genresSelector: '#genre',
          genreSelector: 'a',
          genreGroup: "target-group",
          genreDataName: "target-genre",
          firstGenre: {},
          templateEngine: (_ref = $.tmpl) != null ? _ref : _.template,
          parser: null,
          afterParser: null,
          xmlParserOptions: {}
        };
      };

      Options.extendDefaultOptions = function(options) {
        if (options == null) {
          options = {};
        }
        return options = _.extend({}, Options.defaults(), options);
      };

      Options.extendOptions = function(options) {
        var center, templates;
        center = {
          center: new google.maps.LatLng(options.lat, options.lng)
        };
        templates = {
          infoHtmlFactory: HtmlFactory.create(options.templateEngine, options.infoTemplate),
          listHtmlFactory: HtmlFactory.create(options.templateEngine, options.listTemplate)
        };
        return _.extend(center, options, templates);
      };

      return Options;

    }).call(this);
    AppDelegator = (function() {
      function AppDelegator(options) {
        this.options = options;
      }

      AppDelegator.prototype.execute = function(app) {
        app.entries.on("select", app.build);
        app.entries.on("unselect", app.clear);
        app.entries.on("openinfo", app.openInfo);
        app.entries.on("closeinfo", app.closeInfo);
        app.mainViews.genresView.on("change:genre", app.changeGenre);
        return this.obsoleteDelegateEvents(app);
      };

      AppDelegator.prototype.obsoleteDelegateEvents = function(app) {
        var _ref, _ref1, _ref2, _ref3;
        if (((_ref = this.options) != null ? _ref.beforeBuild : void 0) != null) {
          app.on('beforeBuild', this.options.beforeBuild);
        }
        if (((_ref1 = this.options) != null ? _ref1.afterBuild : void 0) != null) {
          app.on('afterBuild', this.options.afterBuild);
        }
        if (((_ref2 = this.options) != null ? _ref2.beforeClear : void 0) != null) {
          app.on('beforeClear', this.options.beforeClear);
        }
        if (((_ref3 = this.options) != null ? _ref3.afterClear : void 0) != null) {
          return app.on('afterClear', this.options.afterClear);
        }
      };

      return AppDelegator;

    })();
    Source = (function() {
      function Source(data, options) {
        this.data = data;
        this.options = options;
        this._getRemoteData = __bind(this._getRemoteData, this);
        this._dfdSetUp = __bind(this._dfdSetUp, this);
        this.get = __bind(this.get, this);
      }

      Source.prototype.get = function() {
        if (this.dfd != null) {
          this.dfd;
        }
        this.dfd = new $.Deferred;
        this._dfdSetUp();
        return this.dfd.promise();
      };

      Source.prototype._dfdSetUp = function() {
        switch (false) {
          case !_.isArray(this.data):
            return this.dfd.resolve(this.data);
          case !_.isString(this.data):
            return this._getRemoteData();
          default:
            return this.dfd.reject();
        }
      };

      Source.prototype._getRemoteData = function() {
        var parser, resolve,
          _this = this;
        parser = new Parser(this.options);
        resolve = function(data) {
          return _this.dfd.resolve(parser.execute(data));
        };
        return $.ajax(this.data).then(resolve, this.dfd.reject);
      };

      return Source;

    })();
    Parser = (function() {
      function Parser(options) {
        this.options = options != null ? options : {};
        this.getAfterParser = __bind(this.getAfterParser, this);
        this.getCommonParser = __bind(this.getCommonParser, this);
        this.getParserSequence = __bind(this.getParserSequence, this);
        this.parse = __bind(this.parse, this);
        this.execute = __bind(this.execute, this);
      }

      Parser.prototype.execute = function(data) {
        return _(this.getParserSequence()).reduce(this.parse, data);
      };

      Parser.prototype.parse = function(data, parser) {
        switch (false) {
          case !_.isFunction(parser):
            return parser(data);
          case (parser != null ? parser.execute : void 0) == null:
            return parser.execute(data);
          default:
            throw "parser is function or on object with the execute method";
        }
      };

      Parser.prototype.getParserSequence = function() {
        var sequence;
        sequence = [];
        sequence.push(this.getCommonParser());
        sequence.push(this.getAfterParser());
        sequence.push(new Parser.MapIconDecorator(this.options));
        return sequence;
      };

      Parser.prototype.getCommonParser = function() {
        var _ref;
        return (_ref = this.options.parser) != null ? _ref : new Parser.DefaultParser(this.options);
      };

      Parser.prototype.getAfterParser = function() {
        var _ref;
        return (_ref = this.options.afterParser) != null ? _ref : _.identity;
      };

      return Parser;

    })();
    Parser.DefaultParser = (function() {
      function DefaultParser(options) {
        this.options = options;
        this.execute = __bind(this.execute, this);
      }

      DefaultParser.prototype.execute = function(data) {
        var parser;
        switch (false) {
          case !$.isXMLDoc(data):
            parser = new Parser.XMLParser(this.options.xmlParserOptions);
            return parser.execute(data);
          case !_.isObject(data):
            parser = new Parser.ObjectParser;
            return parser.execute(data);
          default:
            throw "Illegal Argument Error";
        }
      };

      return DefaultParser;

    })();
    Parser.MapIconDecorator = (function() {
      function MapIconDecorator() {
        this.makeIcon = __bind(this.makeIcon, this);
        this.execute = __bind(this.execute, this);
      }

      MapIconDecorator.prototype.execute = function(entries) {
        var entry, _i, _len;
        for (_i = 0, _len = entries.length; _i < _len; _i++) {
          entry = entries[_i];
          if (entry.icon != null) {
            entry.icon = this.makeIcon(entry.icon);
          }
          if (entry.shadow != null) {
            entry.shadow = this.makeIcon(entry.shadow);
          }
        }
        return entries;
      };

      MapIconDecorator.prototype.makeIcon = function(data) {
        var key, result, val;
        result = _.clone(data);
        for (key in data) {
          val = data[key];
          result[key] = (function() {
            switch (key) {
              case "origin":
              case "anchor":
                return new google.maps.Point(val[0], val[1]);
              case "size":
              case "scaledSize":
                return new google.maps.Size(val[0], val[1]);
              default:
                return val;
            }
          })();
        }
        return result;
      };

      return MapIconDecorator;

    })();
    Parser.XMLParser = (function() {
      XMLParser.prototype.defaults = function() {
        return {
          place: "place",
          genre: "genre"
        };
      };

      function XMLParser(options) {
        this.getAttribute = __bind(this.getAttribute, this);
        this.getContent = __bind(this.getContent, this);
        this.getGenre = __bind(this.getGenre, this);
        this.makePlace = __bind(this.makePlace, this);
        this.execute = __bind(this.execute, this);
        this.defaults = __bind(this.defaults, this);
        this.options = _.extend({}, _(this).result('defaults'), options);
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
      function ObjectParser() {
        this.execute = __bind(this.execute, this);
      }

      ObjectParser.prototype.execute = function(data) {
        return data;
      };

      return ObjectParser;

    })();
    Entry = (function(_super) {
      __extends(Entry, _super);

      function Entry() {
        this.isSelect = __bind(this.isSelect, this);
        this.isExistPoint = __bind(this.isExistPoint, this);
        this.makeList = __bind(this.makeList, this);
        this.makeMarker = __bind(this.makeMarker, this);
        this.makeInfo = __bind(this.makeInfo, this);
        this.closeInfo = __bind(this.closeInfo, this);
        this.openInfo = __bind(this.openInfo, this);
        this.initialize = __bind(this.initialize, this);
        _ref = Entry.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Entry.prototype.initialize = function(attributes, options) {
        attributes || (attributes = {});
        options || (options = {});
        this.isPoint = this.isExistPoint();
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
        content = this.get('__infoElement') || infoHtmlFactory.make(this.toJSON());
        if ((content != null) && !!content.replace(/\s/g, "")) {
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
        if ((content != null) && !!content.replace(/\s/g, "")) {
          return $(content).addClass("__list").data("entry", this);
        }
      };

      Entry.prototype.isExistPoint = function() {
        var latExist, lngExist;
        latExist = this.has('lat') && _.isFinite(parseFloat(this.get('lat')));
        lngExist = this.has('lng') && _.isFinite(parseFloat(this.get('lng')));
        return latExist && lngExist;
      };

      Entry.prototype.isSelect = function(properties) {
        var _ref1;
        return (_ref1 = this.isPoint && (_.isEmpty(properties) || (_([this.toJSON()]).findWhere(properties) != null))) != null ? _ref1 : {
          "true": false
        };
      };

      return Entry;

    })(Backbone.Model);
    Entries = (function(_super) {
      __extends(Entries, _super);

      function Entries() {
        this.unselect = __bind(this.unselect, this);
        this.select = __bind(this.select, this);
        this.initialize = __bind(this.initialize, this);
        _ref1 = Entries.__super__.constructor.apply(this, arguments);
        return _ref1;
      }

      Entries.prototype.model = Entry;

      Entries.prototype.initialize = function(source, options) {
        var firstGenre;
        this.options = options;
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

      return Entries;

    })(Backbone.Collection);
    HtmlFactory = (function() {
      function HtmlFactory() {}

      HtmlFactory.create = function(templateEngine, template) {
        if (template == null) {
          return new HtmlFactory.Null;
        } else {
          switch (this.getTemplateEngineName(templateEngine)) {
            case "_.template":
              return new HtmlFactory.Underscore(template);
            case "$.tmpl":
              return new HtmlFactory.Jquery(template);
            default:
              return new HtmlFactory.Null;
          }
        }
      };

      HtmlFactory.getTemplateEngineName = function(engine) {
        switch (false) {
          case !(((typeof _ !== "undefined" && _ !== null ? _.template : void 0) != null) && _.template === engine):
            return "_.template";
          case !((($ != null ? $.tmpl : void 0) != null) && $.tmpl === engine):
            return "$.tmpl";
          default:
            return "other";
        }
      };

      return HtmlFactory;

    }).call(this);
    HtmlFactory.Null = (function() {
      function Null() {
        this.make = __bind(this.make, this);
      }

      Null.prototype.make = function() {
        return null;
      };

      return Null;

    })();
    HtmlFactory.Underscore = (function() {
      function Underscore(template) {
        this.make = _.template(template);
      }

      return Underscore;

    })();
    HtmlFactory.Jquery = (function() {
      function Jquery(template) {
        this._getOuterHtml = __bind(this._getOuterHtml, this);
        this.make = __bind(this.make, this);
        this.engine = _.bind($.tmpl, $, template);
      }

      Jquery.prototype.make = function(object) {
        return _(this.engine(object)).map(this._getOuterHtml).join('');
      };

      Jquery.prototype._getOuterHtml = function(dom) {
        return dom.outerHTML;
      };

      return Jquery;

    })();
    MainViews = (function() {
      function MainViews(options) {
        this.options = options;
        this.closeInfo = __bind(this.closeInfo, this);
        this.openInfo = __bind(this.openInfo, this);
        this.clear = __bind(this.clear, this);
        this.build = __bind(this.build, this);
        this.getMap = __bind(this.getMap, this);
        this.mapView = new MapView(this.options);
        this.listView = new ListView(this.options);
        this.genresView = new GenresView(this.options);
      }

      MainViews.prototype.getMap = function() {
        return this.mapView.map;
      };

      MainViews.prototype.build = function(entries) {
        this.mapView.build(entries);
        return this.listView.build(entries);
      };

      MainViews.prototype.clear = function(entries) {
        this.mapView.clear(entries);
        return this.listView.clear(entries);
      };

      MainViews.prototype.openInfo = function(entry) {
        return this.mapView.openInfo(entry);
      };

      MainViews.prototype.closeInfo = function() {
        return this.mapView.closeOpenedInfo();
      };

      return MainViews;

    })();
    MapView = (function(_super) {
      __extends(MapView, _super);

      function MapView() {
        this.fitBounds = __bind(this.fitBounds, this);
        this.closeOpenedInfo = __bind(this.closeOpenedInfo, this);
        this.openInfo = __bind(this.openInfo, this);
        this.clear = __bind(this.clear, this);
        this.build = __bind(this.build, this);
        this.getMap = __bind(this.getMap, this);
        this.initialize = __bind(this.initialize, this);
        _ref2 = MapView.__super__.constructor.apply(this, arguments);
        return _ref2;
      }

      MapView.prototype.initialize = function() {
        var canvas;
        canvas = $(this.options.mapSelector).get(0);
        return this.map = new google.maps.Map(canvas, this.options);
      };

      MapView.prototype.getMap = function() {
        return this.map;
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

      MapView.prototype.openInfo = function(entry) {
        var _ref3;
        if ((_ref3 = this.openedInfoEntry) != null) {
          _ref3.closeInfo();
        }
        entry.info.open(this.map, entry.marker);
        return this.openedInfoEntry = entry;
      };

      MapView.prototype.closeOpenedInfo = function() {
        if (this.openedInfoEntry != null) {
          this.openedInfoEntry.info.close();
          return this.openedInfoEntry = null;
        }
      };

      MapView.prototype.fitBounds = function(entries) {
        var bounds, entry, _i, _len;
        if (entries.length > 0) {
          bounds = new google.maps.LatLngBounds;
          for (_i = 0, _len = entries.length; _i < _len; _i++) {
            entry = entries[_i];
            bounds.extend(entry.marker.getPosition());
          }
          if (this.options.fixedZoom) {
            this.map.setCenter(bounds.getCenter());
            return this.map.setZoom(this.options.zoom);
          } else {
            this.map.fitBounds(bounds);
            if (this.map.getZoom() > this.options.maxFitZoom) {
              return this.map.setZoom(this.options.maxFitZoom);
            }
          }
        }
      };

      return MapView;

    })(Backbone.View);
    ListView = (function(_super) {
      __extends(ListView, _super);

      function ListView() {
        this.openInfo = __bind(this.openInfo, this);
        this.clear = __bind(this.clear, this);
        this.build = __bind(this.build, this);
        this.initialize = __bind(this.initialize, this);
        _ref3 = ListView.__super__.constructor.apply(this, arguments);
        return _ref3;
      }

      ListView.prototype.initialize = function() {
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
        this.selectGenre = __bind(this.selectGenre, this);
        this.initialize = __bind(this.initialize, this);
        _ref4 = GenresView.__super__.constructor.apply(this, arguments);
        return _ref4;
      }

      GenresView.prototype.initialize = function() {
        this.selector = this.options.genresSelector;
        this.$el = $(this.selector);
        return this.$el.on("click", this.options.genreSelector, this.selectGenre);
      };

      GenresView.prototype.selectGenre = function(e) {
        var $group, $target, key, val;
        $target = $(e.currentTarget);
        $group = $target.closest(this.selector);
        key = $group.data(this.options.genreGroup) || "genre";
        val = $target.data(this.options.genreDataName);
        this.trigger("change:genre", key, val);
        return false;
      };

      return GenresView;

    })(Backbone.View);
    EntryViews = (function(_super) {
      __extends(EntryViews, _super);

      /*
      現在Entryの情報をもつEntryクラスがレンダリングなども行っているため
      機能が分散し,非常にわかりにくいことになっている。
      そこで、データそのものに関するものはEntryクラス
      Viewに関するものはEntryViewsに分け
      さらにEntryViewsはEntryInfoViewやEntryListItemViewに分解する。
      メリットとしてDOMを必要な時に構築すれば良くなる。
      どのEntryがInfoを出しているかなどは、EntryViewsCollectionが管理しなきゃいけないね
      */


      function EntryViews(options, entry) {
        this.options = options;
        this.entry = entry;
        this._createListItem = __bind(this._createListItem, this);
        this._getMarkerOptions = __bind(this._getMarkerOptions, this);
        this._createMarker = __bind(this._createMarker, this);
        this._createInfo = __bind(this._createInfo, this);
        this.closeInfoQuery = __bind(this.closeInfoQuery, this);
        this.openInfoQuery = __bind(this.openInfoQuery, this);
        this.getListItem = __bind(this.getListItem, this);
        this.getMarker = __bind(this.getMarker, this);
        this.getInfo = __bind(this.getInfo, this);
      }

      EntryViews.prototype.getInfo = function() {
        return this._info != null ? this._info : this._info = this._createInfo();
      };

      EntryViews.prototype.getMarker = function() {
        return this._marker != null ? this._marker : this._marker = this._createMarker();
      };

      EntryViews.prototype.getListItem = function() {
        return this._marker != null ? this._marker : this._marker = this._createListItem();
      };

      EntryViews.prototype.openInfoQuery = function(e) {
        return this.trigger("openInfoQuery");
      };

      EntryViews.prototype.closeInfoQuery = function() {
        return this.trigger("closeInfoQuery");
      };

      EntryViews.prototype._createInfo = function() {
        var content, factory, info, _ref5;
        factory = this.options.infoHtmlFactory;
        content = (_ref5 = this.entry.get('__infoElement')) != null ? _ref5 : factory.make(this.entry.toJSON());
        if ((content != null) && !!content.replace(/\s/g, "")) {
          info = new google.maps.InfoWindow({
            content: content
          });
          google.maps.event.addListener(info, 'closeclick', this.closeInfoQuery);
          return info;
        }
      };

      EntryViews.prototype._createMarker = function() {
        var marker;
        marker = new google.maps.Marker(this._getMarkerOptions());
        google.maps.event.addListener(marker, 'click', this.openInfoQuery);
        return marker;
      };

      EntryViews.prototype._getMarkerOptions = function() {
        return {
          position: new google.maps.LatLng(this.entry.get('lat'), this.entry.get('lng')),
          icon: this.entry.get('icon'),
          shadow: this.entry.get('shadow')
        };
      };

      EntryViews.prototype._createListItem = function() {
        var content, factory;
        factory = this.options.listHtmlFactory;
        content = factory.make(this.entry.toJSON());
        return $(content).on("click", this.options.openInfoSelector, this.openInfoQuery);
      };

      return EntryViews;

    })(Events);
    EntryInfo = (function(_super) {
      __extends(EntryInfo, _super);

      function EntryInfo(options) {
        this.options = options;
        this.closeInfoQuery = __bind(this.closeInfoQuery, this);
        this.get = __bind(this.get, this);
        this.entry = this.options.entry;
      }

      EntryInfo.prototype.get = function() {
        var content, info, _ref5;
        content = (_ref5 = this.entry.get('__infoElement')) != null ? _ref5 : infoHtmlFactory.make(this.entry.toJSON());
        if ((content != null) && !!content.replace(/\s/g, "")) {
          info = new google.maps.InfoWindow({
            content: content
          });
          google.maps.event.addListener(info, 'closeclick', this.closeInfoQuery);
          return info;
        }
      };

      EntryInfo.prototype.closeInfoQuery = function() {
        return this.trigger("closeInfoQuery");
      };

      return EntryInfo;

    })(Events);
    EntryMarker = (function(_super) {
      __extends(EntryMarker, _super);

      function EntryMarker(options) {
        this.options = options;
        this.openInfoQuery = __bind(this.openInfoQuery, this);
        this.getMarkerOptions = __bind(this.getMarkerOptions, this);
        this.get = __bind(this.get, this);
        this.entry = this.options.entry;
      }

      EntryMarker.prototype.get = function() {
        var marker;
        marker = new google.maps.Marker(this.getMarkerOptions());
        google.maps.event.addListener(marker, 'click', this.openInfoQuery);
        return marker;
      };

      EntryMarker.prototype.getMarkerOptions = function() {
        return {
          position: new google.maps.LatLng(this.entry.get('lat'), this.entry.get('lng')),
          icon: this.entry.get('icon'),
          shadow: this.entry.get('shadow')
        };
      };

      EntryMarker.prototype.openInfoQuery = function(e) {
        return this.trigger("openInfoQuery");
      };

      return EntryMarker;

    })(Events);
    EntryListItem = (function(_super) {
      __extends(EntryListItem, _super);

      function EntryListItem(options) {
        this.options = options;
        this.openInfoQuery = __bind(this.openInfoQuery, this);
        this.get = __bind(this.get, this);
        this.entry = this.options.entry;
      }

      EntryListItem.prototype.get = function() {
        var content;
        content = listHtmlFactory.make(this.entry.toJSON());
        return $(content).on("click", this.options.openInfoSelector, this.openInfoQuery);
      };

      EntryListItem.prototype.openInfoQuery = function(e) {
        return this.trigger("openInfoQuery");
      };

      return EntryListItem;

    })(Events);
    EntryViewsCollection = (function() {
      EntryViewsCollection.prototype.list = [];

      function EntryViewsCollection(options, entries) {
        var entry, _i, _len, _ref5;
        this.options = options;
        this.entries = entries;
        _ref5 = this.entries.selectedList;
        for (_i = 0, _len = _ref5.length; _i < _len; _i++) {
          entry = _ref5[_i];
          this.list.push(new EntryViews(entry));
        }
      }

      /*
      entriesのeventを監視して、listにEntryViewsを追加していく
      */


      return EntryViewsCollection;

    })();
    return global.MapList = _.extend(App, {
      Options: Options,
      AppDelegator: AppDelegator,
      Source: Source,
      Parser: Parser,
      Entry: Entry,
      Entries: Entries,
      HtmlFactory: HtmlFactory,
      MainViews: MainViews,
      MapView: MapView,
      ListView: ListView,
      GenresView: GenresView,
      EntryViews: EntryViews
    });
  })(jQuery, this);

}).call(this);
