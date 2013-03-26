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
            lat: 36.115135,
            lng: 137,953949,
            zoom: 11
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

オプション
--------------------
### center
初期値 `null`

地図の初期構築時，表示する緯度経度を設定します．
値はgoogle.mapsのLatLngオブジェクトを渡してください．

例 `google.maps.LatLng( 35, 135 )`

このオプションが`null`の場合,次のlat,lngのオプションを用いて
初期値を設定します．

### lat
初期値 `35`

地図の初期構築時，表示する緯度を設定します．

### lng
初期値 `135`

地図の初期構築時，表示する経度を設定します．

### zoom
初期値 `4`

地図の初期構築時，表示するズームの度合いを設定します．

### mapTypeId
初期値 `google.maps.MapTypeId.ROADMAP`

地図の初期構築時，表示する地図のタイプを設定します．
値はgoogle.mapsのMapTypeIdの保持する値を渡してください．

### data
初期値 `[]`

entriesデータを渡します．

値が配列の場合，そのままデータとして扱います．

値が文字列の場合，URLとして扱い，AJAXでデータを取得します．
取得したデータがJSONの場合，そのままデータとして扱います．
取得したデータがXMLの場合，なんかあれこれなParseを通して配列オブジェクトに変換します．

### parse
初期値 `function`

AJAXで受け取ったデータを適切なデータ形式に変換する関数です．
この関数は引数としてAJAXで受け取ったデータをそのまま受け取り，
返り値の値がそのままデータとして扱われます．

注意すべきことは，この関数はデフォルトと違って
取得したデータをJSONなのかXMLなのか判別しません．

### mapSelector
初期値 `'#map_canvas'`

地図を構築するDOM要素のセレクターです．
複数のDOM要素が選択された場合，1番最初の要素に構築されます．

google mapsの仕様ですが，地図の大きさは
このDOM要素の大きさになります．
したがって，このDOM要素のwidthやheightはしっかり指定してください．

### listSelector
初期値 `'#list'`

リストを構築するDOM要素のセレクターです．
このDOM要素の中にentryから生成されたHTMLが追加されたりします．

例えば，リストを普通のリスト構造で構築するなら，指定する要素は`<ul>`にすべきだし，
テーブルで構築するなら，指定する要素は`<table>`ではなく
`<tbody>`にすることをオススメします．

### listToMarkerSelector
初期値 `'.open-info'`

リスト要素の中で，このセレクターに適合する要素をクリックした場合，
対応するMarkerのInfoWindowを開きます．

### listTemplate
初期値 `null`

リストに追加されるentryに対応したHTMLを構築するためのテンプレートです．
テンプレートには`jquery.tmpl`を用いています．詳しくはそちらのリファレンスを参照ください．
以下のようにテンプレートを作成します．

    <script id="tmpl-list-elem" type="text/template">
    <tr>
      <td>${genreName}</td>
      <td>${title}</td>
      <td>
        {{if postal}}${postal}　{{/if}}
        ${address}
      </td>
      <td>${tel}</td>
      <td><a href="${link}">詳細</a></td>
    </tr>
    </script>

このテンプレートは以下のように値に設定します．

    listTemplate : $('temp-list-elem')
    // もしくは
    listTemplate : $('temp-list-elem').html()
    // のように文字列を渡しても構いません．

この値が`null`のときリストは構築されません．

### infoTemplate
初期値 `null`

InfoWindowとしてentryに対応したHTMLを構築するためのテンプレートです．
テンプレートには`jquery.tmpl`を用いています．詳しくはそちらのリファレンスを参照ください．
以下のようにテンプレートを作成します．

    <script id="tmpl-info-window" type="text/template">
    <div id="info-window">
      <h3><a href="${link}">
          ${title}
      </a></h3>
      <p>${postal} ${address}</p>
      <p>${tel}</p>
      {{if image}}<img src="${image}" />{{/if}}
    </div>
    </script>

このテンプレートは以下のように値に設定します．

    listTemplate : $('temp-info-window')
    // もしくは
    listTemplate : $('temp-info-window').html()
    // のように文字列を渡しても構いません．

この値が`null`のときリストは構築されません．

### genreAlias
初期値 `'genre'`

ジャンルの別名を指定します．
例えば，entriesの分類を`cat`などでやっていた場合は，
その値に指定することで，デフォルトのParserがうまいことやってくれることもあります．

### genreContainerSelector
初期値 `'#genre'`

ジャンルの要素を保持するDOM要素を指定するセレクターです．

### genreSelector
初期値 `'a'`

先の genreContainerSelector の中で このオプションのセレクターがクリックされた場合，
genreが切り替わります．

### genreDataName
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

### firstGenre
初期値 `'__all__'`

地図の初期構築時に表示するgenreを指定します．

### beforeBuild
初期値 `null`

指定されたgenreのentriesのもろもろを構築する前に実行される関数です．

`null`の場合，何もしません．

### afterBuild
初期値 `null`

指定されたgenreのentriesのもろもろを構築した後に実行される関数です．

`null`の場合，何もしません．

### beforeClear
初期値 `null`

地図のMarkerやリスト要素を全て消す前に実行される関数です．

`null`の場合，何もしません．

### afterClear
初期値 `null`

地図のMarkerやリスト要素を全て消した後に実行される関数です．

`null`の場合，何もしません．

### doFit
初期値 `true`

マーカー構築後，すべてのマーカーが表示されるようにするか否か．
`true`ならばFitさせ，`false`ならばFitさせません．

メソッド
--------------------
### build
引数 `genreID`

指定された`genreID`でentriesを抽出して，
Markerやリスト要素を構築します．

### clear
Markerやリスト要素を全て削除します．

### rebuild
引数 `genreID`

clear した後， build します．


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
ちょっと仕様が煮詰まってないです．


