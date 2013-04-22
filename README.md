MapList.js
====================

google maps ver3 を地図を表示する． だけでなく，
entry に対して marker を落としたり，
infowindow を作ったり，
地図の外にリストを構築したりするためのスクリプトです．

できること
--------------------
* google maps を表示
* AJAXで外部からデータを読み込む
    + entry の集合として管理
    + データの形式はXML, JSON
    + データのParse
    + スクリプト利用時にデータを直接渡すことも
* 地図にentryに対応したMarker
    + Markerをクリックした時にInfoWindowを出す
* 地図の外にentryに対応したリストを構築
    + リストをクリックすると関連するMarkerが地図に移るように切り替わり，
    InfoWindowを出す
* ジャンルなどの分類
    + 指定したジャンルのみの表示

簡単な使い方
--------------------
1. 依存する以下のJavascriptを読み込む．

        <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=false"></script>
        <script type="text/javascript" src='/js/jquery-1.9.1.min.js'></script>
        <script type="text/javascript" src='/js/jquery.tmpl.min.js'></script>
        <script type="text/javascript" src='/js/underscore-min.js'></script>

2. 当スクリプトを読み込む

        <script type="text/javascript" src='/js/maplist.js'></script>

3. Map用の要素に幅と高さの指定を忘れない

        <div id="map_canvas"" style="width:900px;height:600px;"></div>

4. スクリプトを実行する

        <script type="text/javascript">
        $(function(){
          var maplist = new MapList({
            data : "entries.json"
          });
        });
        </script>

5. 地図が表示される

補足
--------------------
当スクリプトを読み込むことで，
globalに`MapList`クラスが作成されます．

    new MapList({
        // オプション
    })

とすることで，マップやリストの構築を始めます．

インスタンス作成の方法
--------------------
MapListインスタンスはイベントを登録する`on`メソッドや
entriesを後から設定する`data`メソッドがあります．

イベントを登録する場合，dataの設定は後から望ましいです．

1. 普通に

    イベントを登録しない場合使ってやってください．基本通りのインスタンス作成です．

        new MapList({
            data: "entries.json"
            // options
        });

2. イベントを登録する場合

    `on`メソッドでイベントを登録し， `data`メソッドでentriesを設定してください．

        var maplist = new Maplist(options);
        maplist.on("event",function);
        maplist.data("entries.json");

3. メソッドチェーンでイベントを登録

    `MapList`はnewメソッドを持っています．
    newメソッドはMapListをMapListインスタンスを返します．

        MapList
            .new(options)
            .on("event",function)
            .data("entries.json");

4. 初期化メソッドを渡す

    MapListのコンストラクタの第2引数は関数を受け取ります．
    この関数はコンストラクタ内でdataを設定する前に実行されます．
    この関数は引数に初期化中のMapListインスタンスを渡します．

        new MapList({
            data: "entries.json"
            // options...
        },function(maplist){
            maplist.on("event",function);
        });

オプション
--------------------
### Core
#### data
初期値 `[]`

entriesデータを渡します．

値が配列の場合，そのままデータとして扱います．

値が文字列の場合，URLとして扱い，AJAXでデータを取得します．
取得したデータがJSONの場合，そのままデータとして扱います．
取得したデータがXMLの場合，なんかあれこれなParseを通して配列オブジェクトに変換します．

### Map Options
#### mapSelector
初期値 `'#map_canvas'`

地図を構築するDOM要素のセレクターです．
複数のDOM要素が選択された場合，1番最初の要素に構築されます．

google mapsの仕様ですが，地図の大きさは
このDOM要素の大きさになります．
したがって，このDOM要素のwidthやheightはしっかり指定してください．

#### canFitBounds
初期値 `true`

マーカー構築後，すべてのマーカーが表示されるようにするか否か．
`true`ならばFitさせ，`false`ならばFitさせません．

#### fixedZoom
初期値 `false`

Fitするとき，規定のzoomにするか否か

#### center
初期値 `null`

地図の初期構築時，表示する緯度経度を設定します．
値はgoogle.mapsのLatLngオブジェクトを渡してください．

例 `google.maps.LatLng( 35, 135 )`

このオプションが`null`の場合,次のlat,lngのオプションを用いて
初期値を設定します．

#### lat
初期値 `35`

地図の初期構築時，表示する緯度を設定します．

#### lng
初期値 `135`

地図の初期構築時，表示する経度を設定します．

#### zoom
初期値 `4`

地図の初期構築時，表示するズームの度合いを設定します．

#### mapTypeId
初期値 `google.maps.MapTypeId.ROADMAP`

地図の初期構築時，表示する地図のタイプを設定します．
値はgoogle.mapsのMapTypeIdの保持する値を渡してください．

### List Options

#### listSelector
初期値 `'#list'`

リストを構築するDOM要素のセレクターです．
このDOM要素の中にentryから生成されたHTMLが追加されたりします．

例えば，リストを普通のリスト構造で構築するなら，指定する要素は`<ul>`にすべきだし，
テーブルで構築するなら，指定する要素は`<table>`ではなく
`<tbody>`にすることをオススメします．

#### listTemplate
初期値 `null`

リストに追加されるentryに対応したHTMLを構築するためのテンプレートです．
テンプレートには`templateEngine`オプションで指定されたものを用いています．
詳しくはそちらのリファレンスを参照ください．
以下のようにテンプレートを作成します．

    <script id="tmpl-list-elem" type="text/template">
    <li class="span2">
      <a href="#" class='open-info'>
        <span class="label label-info">
          <%- states %> - <%- capitals %>
        </span>
      </a>
    </li>
    </script>

このテンプレートは以下のように値に設定します．

    listTemplate : $('temp-list-elem').html()

この値が`null`のときリストは構築されません．

#### openInfoSelector
初期値 `'.open-info'`

リスト要素の中で，このセレクターに適合する要素をクリックした場合，
対応するMarkerのInfoWindowを開きます．

### Info Options
#### infoTemplate
初期値 `null`

InfoWindowとしてentryに対応したHTMLを構築するためのテンプレートです．
テンプレートには`templateEngine`オプションで指定されたものを用いています．
詳しくはそちらのリファレンスを参照ください．
以下のようにテンプレートを作成します．

    <script id="tmpl-info-window" type="text/template">
    <div id="info-window">
      <h3> <%- states %> - <%- capitals %> </h3>
      <p>[ <%- genre %> ] </p>
    </div>
    </script>

このテンプレートは以下のように値に設定します．

    listTemplate : $('temp-info-window').html()

この値が`null`のときリストは構築されません．

### Genres Options
### General
<!--
#### genreAlias
初期値 `'genre'`

ジャンルの別名を指定します．
例えば，entriesの分類を`cat`などでやっていた場合は，
その値に指定することで，デフォルトのParserがうまいことやってくれることもあります．
-->
#### genresSelector
初期値 `'#genre'`

ジャンルの要素を保持するDOM要素を指定するセレクターです．

#### genreSelector
初期値 `'a'`

先の genreContainerSelector の中で このオプションのセレクターがクリックされた場合，
genreが切り替わります．

#### genreDataName
初期値 `"target-genre"`

先の genreSelector がクリックされた場合，
その要素のどのdata属性を用いて次のジャンルを指定するかを渡します．

例えば次の場合，次のgenreは`food`になります．

    <li>
      <a href="#" data-target-genre='food'>
        Food
      </a>
    <li>

また，この値が`__all__`の場合，全てのgenreが選択されたとみなします．

#### firstGenre
初期値 `'__all__'`

地図の初期構築時に表示するgenreを指定します．


### Parser
#### parser
初期値 `function`

AJAXで受け取ったデータを適切なデータ形式に変換する関数です．
この関数は引数としてAJAXで受け取ったデータをそのまま受け取り，
返り値の値がそのままデータとして扱われます．

注意すべきことは，この関数はデフォルトと違って
取得したデータをJSONなのかXMLなのか判別しません．

メソッド
--------------------
### on
引数:
    `イベント名`:string,
    `実行する関数`:function

Backbone.jsのEventsを継承してるんで，詳しくはそっち見てください．
MapListが発火するイベントについては後述します．

    maplist.on("beforeBuild",function(properties,entries){
        console.log(properties, entries);
    });

### data
引数: `entries`
maplistのdataを設定します．

maplist.data("entries.json");

### build
引数 `properties`

指定された`properties`でentriesを抽出して，
Markerやリスト要素を構築します．

### clear
Markerやリスト要素を全て削除します．

### rebuild
引数 `properties`

entriesをunselectしてselectします．

### getMap
mapオブジェクトを返します．

イベント
--------------------
### beforeBuild
選択されたentriesを構築する前に発火します．

登録された関数に渡される引数: `properties`, `entries`

### afterBuild
選択されたentriesを構築した後に発火します．

登録された関数に渡される引数: `properties`, `entries`

### beforeClear
地図のMarkerやリスト要素を全て消す前に発火します．

登録された関数に渡される引数: `entries`

### afterClear
地図のMarkerやリスト要素を全て消した後に発火します．

登録された関数に渡される引数: `entries`

### openInfo
infoWindowを開く前に発火します．

登録された関数に渡される引数: `entry`

### openedInfo
infoWindowを開いた後に発火します．

登録された関数に渡される引数: `entry`

### closeInfo
InfoWindowを閉じる前に発火します．

登録された関数に渡される引数: `entry`

### closedInfo
InfoWindowを閉じた後に発火します．

登録された関数に渡される引数: `entry`

### changeGenre
Genreが変更された直後に発火します．
rebuildされる前です．

登録された関数に渡される引数: `properties`

### changedGenre
Genreが変更された後に発火します．
rebuildされた後です．

登録された関数に渡される引数: `properties`


Entriesの要素について
--------------------
当スクリプトが扱うデータをここでは`Entries`と呼称します．

`Entries`は`Entry`の配列です．

`Entry`はオブジェクト(連想配列)で次の値は必須です．

### lat
緯度
### lng
経度

また，次の値は推奨です．
### icon
### shadow
ちょっと仕様が煮詰まってないです．


