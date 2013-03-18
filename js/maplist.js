// Generated by CoffeeScript 1.5.0
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  (function($, global) {
    var Data, Facade, MapList, Parser, log;
    log = _.bind(console.log, console);
    Facade = (function() {

      Facade.prototype["default"] = function() {
        return {
          lat: 35,
          lng: 135,
          center: null,
          zoom: 4,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          data: [],
          mapSelector: '#map_canvas',
          listSelector: '#list',
          listTemplate: null,
          infoTemplate: null,
          listToMarkerSelector: '.open-info',
          genreAlias: 'genre',
          genreContainerSelector: '#genre',
          genreSelector: 'a',
          genreDataName: "target-genre",
          firstGenre: '__all__',
          beforeBuild: null,
          afterBuild: null,
          beforeClear: null,
          afterClear: null
        };
      };

      Facade.prototype.usingEntries = [];

      function Facade(options) {
        this["default"] = __bind(this["default"], this);
        var _this = this;
        _.bindAll(this);
        this.options = this._makeOptions(options);
        this.entries = new Data(_.clone(this.options));
        this.maplist = new MapList(_.clone(this.options));
        this.entries.then(function() {
          return _this.build(_this.options.firstGenre);
        });
        $(this.options.genreContainerSelector).on("click", this.options.genreSelector, this._selectGenre);
      }

      Facade.prototype.build = function(genreId) {
        var _base,
          _this = this;
        if (typeof (_base = this.options).beforeBuild === "function") {
          _base.beforeBuild();
        }
        return this.entries.filterdThen(genreId, function(usingEntries) {
          var _base1;
          _this.usingEntries = usingEntries;
          _this.maplist.build(_this.usingEntries);
          return typeof (_base1 = _this.options).afterBuild === "function" ? _base1.afterBuild() : void 0;
        });
      };

      Facade.prototype.clear = function() {
        var _base, _base1;
        if (typeof (_base = this.options).beforeClear === "function") {
          _base.beforeClear();
        }
        this.maplist.clear(this.usingEntries);
        return typeof (_base1 = this.options).afterClear === "function" ? _base1.afterClear() : void 0;
      };

      Facade.prototype.rebuild = function(genreId) {
        this.clear();
        return this.build(genreId);
      };

      Facade.prototype._selectGenre = function(e) {
        var $target, genreId;
        $target = $(e.currentTarget);
        genreId = $target.data(this.options.genreDataName);
        this.rebuild(genreId);
        return false;
      };

      Facade.prototype._makeOptions = function(options) {
        options = _.extend({}, _(this).result('default'), options);
        if (options.center == null) {
          options.center = new google.maps.LatLng(options.lat, options.lng);
        }
        return options;
      };

      return Facade;

    })();
    Data = (function() {

      function Data(options) {
        var parser;
        this.options = options;
        _.bindAll(this);
        parser = new Parser(_.clone(this.options));
        this.options = _.extend({
          parse: parser.parse
        }, this.options);
        this.entries = this._makeEntries();
      }

      Data.prototype.then = function(done, fail) {
        return this.entries.then(done, fail);
      };

      Data.prototype.filterdThen = function(genreId, done, fail) {
        var _this = this;
        return this.entries.then(function(entries) {
          return done(_this._filterdEntries(genreId, entries));
        }, function(e) {
          return fail(e);
        });
      };

      Data.prototype._makeEntries = function() {
        var data, dfd,
          _this = this;
        dfd = new $.Deferred;
        data = this.options.data;
        if (_.isArray(data)) {
          dfd.resolve(data);
        } else if (_.isString(data)) {
          $.ajax({
            url: data
          }).done(function(data) {
            return dfd.resolve(_this.options.parse(data));
          }).fail(function() {
            return dfd.reject();
          });
        } else {
          dfd.reject();
        }
        return dfd.promise();
      };

      Data.prototype._filterdEntries = function(genreId, entries) {
        var alias, entry, _i, _len, _results;
        if (genreId === "__all__") {
          return entries;
        } else {
          alias = this.options.genreAlias;
          _results = [];
          for (_i = 0, _len = entries.length; _i < _len; _i++) {
            entry = entries[_i];
            if (entry[alias] === genreId) {
              _results.push(entry);
            }
          }
          return _results;
        }
      };

      return Data;

    })();
    Parser = (function() {

      function Parser(options) {
        this.options = options;
        _.bindAll(this);
      }

      Parser.prototype.parse = function(data) {
        if ($.isXMLDoc(data)) {
          return this._parseForXML(data);
        } else if (_.isObject(data)) {
          return this._parseForObject(data);
        } else {
          return data;
        }
      };

      Parser.prototype._parseForXML = function(data) {
        var $root, alias,
          _this = this;
        $root = $(">*:first", data);
        alias = this.options.genreAlias;
        return $.map($root.find(">" + alias), function(genre) {
          var $genre;
          $genre = $(genre);
          genre = {
            "icon": $genre.attr("icon")
          };
          genre["" + alias] = $genre.attr("id");
          genre["" + alias + "Name"] = $genre.attr("name");
          return $.map($genre.find(">place"), function(place) {
            var $place, position, res;
            $place = $(place);
            res = {};
            $place.children().each(function(idx, elem) {
              return res[elem.nodeName] = $(elem).text();
            });
            position = {
              lat: $place.attr('latitude'),
              lng: $place.attr('longitude')
            };
            return _.extend({}, genre, position, res);
          });
        });
      };

      Parser.prototype._parseForObject = function(data) {
        return data;
      };

      return Parser;

    })();
    MapList = (function() {

      function MapList(options) {
        var canvas, mapOptions;
        this.options = options;
        _.bindAll(this);
        mapOptions = _(this.options).clone();
        canvas = $(this.options.mapSelector).get(0);
        this.map = new google.maps.Map(canvas, mapOptions);
      }

      MapList.prototype.build = function(entries) {
        var entry, info, listElem, marker, _i, _len, _ref, _results;
        _results = [];
        for (_i = 0, _len = entries.length; _i < _len; _i++) {
          entry = entries[_i];
          _ref = this.getEntryData(entry), info = _ref[0], marker = _ref[1], listElem = _ref[2];
          marker.setMap(this.map);
          _results.push(listElem.appendTo($(this.options.listSelector)));
        }
        return _results;
      };

      MapList.prototype.clear = function(entries) {
        var entry, info, listElem, marker, _i, _len, _ref, _results;
        _results = [];
        for (_i = 0, _len = entries.length; _i < _len; _i++) {
          entry = entries[_i];
          _ref = this.getEntryData(entry), info = _ref[0], marker = _ref[1], listElem = _ref[2];
          if (this.openInfo != null) {
            this.openInfo.close();
          }
          marker.setMap(null);
          _results.push(listElem.detach());
        }
        return _results;
      };

      MapList.prototype.getEntryData = function(entry) {
        var info, listElem, marker, _ref, _ref1, _ref2;
        info = (_ref = entry.__info) != null ? _ref : entry.__info = this.makeInfo(entry);
        marker = (_ref1 = entry.__marker) != null ? _ref1 : entry.__marker = this.makeMarker(entry, info);
        listElem = (_ref2 = entry.__listElem) != null ? _ref2 : entry.__listElem = this.makeListElem(entry, marker, info);
        return [info, marker, listElem];
      };

      MapList.prototype.makeInfo = function(entry) {
        var content, info,
          _this = this;
        content = this.makeHTML(this.options.infoTemplate, entry);
        if (content != null) {
          content = $(content).html();
          info = new google.maps.InfoWindow({
            content: content
          });
          google.maps.event.addListener(info, 'closeclick', function() {
            return _this.openInfo = null;
          });
          return info;
        } else {
          return null;
        }
      };

      MapList.prototype.makeMarker = function(entry, info) {
        var marker, position;
        position = new google.maps.LatLng(entry.lat, entry.lng);
        marker = new google.maps.Marker({
          position: position,
          icon: entry.icon
        });
        if (info) {
          google.maps.event.addListener(marker, 'click', this.openInfoFunc(marker, info));
        }
        return marker;
      };

      MapList.prototype.makeListElem = function(entry, marker, info) {
        var $content, content;
        content = this.makeHTML(this.options.listTemplate, entry);
        if (content != null) {
          $content = $(content);
          $content.data(this.options.genreAlias, entry[this.options.genreAlias]);
          if (this.options.listToMarkerSelector != null) {
            $content.on("click", this.options.listToMarkerSelector, this.openInfoFunc(marker, info));
          }
          return $content;
        } else {
          return null;
        }
      };

      MapList.prototype.openInfoFunc = function(marker, info) {
        var _this = this;
        return function(e) {
          if (_this.openInfo != null) {
            _this.openInfo.close();
          }
          info.open(_this.map, marker);
          _this.openInfo = info;
          return _this.toMapScroll();
        };
      };

      MapList.prototype.makeHTML = function(template, entry) {
        if (template != null) {
          return $.tmpl(template, entry);
        } else {
          return null;
        }
      };

      MapList.prototype.toMapScroll = function() {
        var top;
        top = $(this.options.mapSelector).offset().top;
        return $('html,body').animate({
          scrollTop: top
        }, 'fast');
      };

      return MapList;

    })();
    return global.MapList = Facade;
  })(jQuery, this);

}).call(this);
