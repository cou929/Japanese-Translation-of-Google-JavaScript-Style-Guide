.. -*- coding: utf-8; -*-

.. Google JavaScript Style Guide 和訳

===============================================================
Google JavaScript Style Guide 和訳
===============================================================


この和訳について
====================
この文章は `Google JavaScript Style Guide <http://google-styleguide.googlecode.com/svn/trunk/javascriptguide.xml>`_ を非公式に和訳したものです. 内容の正確性は保証しません. ライセンスは原文と同じく `CC-By 3.0 <http://creativecommons.org/licenses/by/3.0/>`_ とします. フィードバック `Issue の登録 <https://github.com/cou929/Japanese-Translation-of-Google-JavaScript-Style-Guide/issues>`_ , あるいは `Kosei Moriyama <http://cou929.nu/>`_ (`@cou929 <http://twitter.com/cou929>`_ または cou929 at gmail.com) へ直接お願いします. この和訳のリポジトリは `こちら <https://github.com/cou929/Japanese-Translation-of-Google-JavaScript-Style-Guide/blob/master/doc/index.rst>`_ です.

バージョン
========================================
Revision 2.20

著者
========================================

* Aaron Whyte
* Bob Jervis
* Dan Pupius
* Eric Arvidsson
* Fritz Schneider
* Robby Walker

背景
========================================
JavaScript は Google の オープンソースプロジェクトにおいて使われる, 主要なクライアントサイドスクリプト言語です. このスタイルガイドでは JavaScript プログラムにおいて `すべき` こと, `すべきでない` ことをまとめています.

JavaScript Language Rules
========================================

var
----------------------------------------
変数宣言には常に var をつける.

宣言時に var を付けなかった場合, その変数はグローバルコンテキストに置かれます. このことにより, 既存の変数が汚染される可能性があります. また宣言がない場合は, その変数がどのスコープなのかが分かりづらくなります. よって常に var をつけるべきです.

定数
----------------------------------------
定数は ``NAMES_LIKE_THIS`` のように名付けます. 適切な場面で ``@const`` を使います. ``const`` キーワードは使うべきではありません.

プリミティブ値の定数の場合, 以下のようにします.

.. code-block:: javascript

   /**
    * The number of seconds in a minute.
    * @type {number}
    */
   goog.example.SECONDS_IN_A_MINUTE = 60;

プリミティブ値でない定数の場合は ``@const`` アノテーションを使います.

.. code-block:: javascript

   /**
    * The number of seconds in each of the given units.
    * @type {Object.<number>}
    * @const
    */
   goog.example.SECONDS_TABLE = {
     minute: 60,
     hour: 60 * 60
     day: 60 * 60 * 24
   }

この記法を用いることで, 変数を定数として扱うようにコンパイラに伝えることができます.

``const`` キーワードは Internet Explorer が認識しないため, 使うべきではありません.

セミコロン
----------------------------------------
常にセミコロンを使います.

コードのセミコロンを省き, セミコロンの挿入を処理系に任せた場合, 非常にデバッグが困難な問題が起こります. 決してセミコロンを省くべきではありません.

以下のコードで, セミコロンの省略が非常に危険である例を示します.

.. code-block:: javascript

   // 1.
   MyClass.prototype.myMethod = function() {
     return 42;
   }  // ここにセミコロンがない
   
   (function() {
     // この一時的なブロックスコープで初期化処理などを行う
   })();
   
   
   var x = {
     'i': 1,
     'j': 2
   }  // セミコロンがない
   
   // 2. Internet Explorer や FireFox のために以下のようなコードを書く
   // 普通はこんな書き方はしないけど, 例なので
   [normalVersion, ffVersion][isIE]();
   
   
   var THINGS_TO_EAT = [apples, oysters, sprayOnCheese]  // セミコロンがない
   
   // 3. bash 風な条件文
   -1 == resultOfOperation() || die();

何が起こるか
****************************************

1. JavaScript Error: はじめの 42 を返している無名関数が, 2つ目の関数を引数にとって実行されてしまい, 42 を関数として呼び出そうとしてエラーになる.
2. おそらく実行時に 'no such property in undefined' エラーとなる. x[ffVersion][isIE]() と解釈されてしまうため.
3. resultOfOperation() が NaN でない限り die がコールされ, THINGS_TO_EAT に die() の結果が代入される.

なぜ
****************************************
JavaScript は, 安全にセミコロンの存在が推測できる場合を除いて, 文の最後にセミコロンを要求します. 上記の例では関数宣言やオブジェクトや配列リテラルが文の中にあります. 閉じ括弧は文の終わりを表現するものではありません. 次のトークンが()演算子などの場合, JavaScript はそれを前の文の続きとみなしてしまいます.

これらの挙動は本当にプログラマを驚かせてしまいます. よってセミコロンを徹底すべきです.

ネストした関数
----------------------------------------
使っても良い.

ネストした関数は非常に便利です. 例えば, continuation を作り, ヘルパー関数を隠蔽する場合などです. 自由にネストした関数を使ってください.

ブロックの中での関数宣言
----------------------------------------
してはいけない.

.. code-block:: javascript

   if (x) {
     function foo() {}
   }

ブロック内での関数宣言は多くのスクリプトエンジンでサポートされていますが, これは ECMAScript で標準化されていません (`ECMA-262 <http://www.ecma-international.org/publications/standards/Ecma-262.htm>`_ の 13, 14 節を参照してください). よって各実装や将来の ECMAScript 標準との間での一貫性がとれなくなります. ECMAScript での関数宣言は, スクリプトのルート部分か関数内で許可されています. ブロック内では関数宣言の代わりに関数式を用いてください:

.. code-block:: javascript

   if (x) {
     var foo = function() {}
   }

例外
----------------------------------------
使っても良い.

何か通常でないこと (例えばフレームワークを使う場合など) をするときには, 基本的に例外は避けられません. よって使うべきです.

カスタム例外
----------------------------------------
使っても良い.

例外を独自に定義しない場合, エラー時の関数の戻り値を工夫せねばならず, エレガントではありません. エラー情報へのリファレンスを返すか, エラーメンバーを含むオブジェクトを返すことで解決できますが, これらはプリミティブな例外をハックすることで実現できます. よって適切な場面では独自の例外を使用すべきです.

標準機能
----------------------------------------
常に標準の機能を使うべきです.

ポータビリティとコンパチビリティを最大化するために, 常に非標準の機能よりも標準の機能を使うべきです (例えば string[3] ではなく string.charAt(3) を使ったり, アプリケーション特有の省略記法ではなく DOM 関数を使うなど).

プリミティブ型のラッパーオブジェクト
----------------------------------------
使用すべきでない.

プリミティブな型のラッパーオブジェクトを使う理由はありません. またそれは危険です.

.. code-block:: javascript

   var x = new Boolean(false);
   if (x) {
     alert('hi');  // 'hi' がアラートされる.
   }

絶対にやらないでください!

しかし型キャストは問題ありません.

.. code-block:: javascript

   var x = Boolean(0);
   if (x) {
     alert('hi');  // これはアラートされません
   }
   typeof Boolean(0) == 'boolean';
   typeof new Boolean(0) == 'object';

この方法はデータを ``number``, ``string``, ``boolean`` にキャストする際に便利です.

多層のプロトタイプヒエラルキー
----------------------------------------
好ましくありません.

多層のプロトタイプヒエラルキー(Multi-level prototype hierarchies) は JavaScript が継承を実装している方法です. ユーザー定義クラスDがプロトタイプとしてユーザー定義クラスBを持っている場合, 多層のヒエラルキーになります. こうしたヒエラルキーは理解するのが難しくなります.

よって同様のことを実現したい場合は, `Closure Library <http://code.google.com/closure/library/>`_ の ``goog.inherits()`` を使うべきです.

.. code-block:: javascript
   
   function D() {
     goog.base(this)
   }
   goog.inherits(D, B);
   
   D.prototype.method = function() {
     ...
   };

関数宣言
----------------------------------------
``Foo.prototype.bar = function() { ... };``

メソッドやプロパティをコンストラクタに付与する方法はいくつかありますが, 次の方法を使用してください:

.. code-block:: javascript

   Foo.prototype.bar = function() {
     /* ... */
   };

クロージャ
----------------------------------------
使っても良い. ただし慎重に.

クロージャは JavaScript の中でも最も便利でよく見る機能です. `クロージャについて詳しくはこちらを参照してください <http://jibbering.com/faq/notes/closures/>`_.

ただし一点注意すべき点は, クロージャはその閉じたスコープへのポインタを保持しているという点です. そのため, クロージャを DOM 要素に付加すると循環参照が発生する可能性があり, メモリリークの原因となります. 例えば, 以下のコードを見てください:

.. code-block:: javascript

   function foo(element, a, b) {
     element.onclick = function() { /* 引数 a と b を使う */ };
   }

上記の無名関数はそれらを使う・使わないにかかわらず ``element``, ``a``, ``b`` への参照をずっと保持しています. ``element`` はクロージャへの参照をもっているので, 循環が発生していて, gc が回収できなくなっています. この場合, コードは以下のような構造になっています:

.. code-block:: javascript

   function foo(element, a, b) {
     element.onclick = bar(a, b);
   }
   
   function bar(a, b) {
     return function() { /* 引数 a と b を使う */ }
   }

eval()
----------------------------------------
デシリアライズ (deserialization) するときのみ使用可. (例えば RPC レスポンスを評価するときなど)

``eval()`` はセマンティクスを混乱させやすいし, ユーザーインプットを ``eval()`` したものは危険です. 通常はもっとクリアで安全な代替手段が存在するので, 大抵の場合には ``eval()`` は使用すべきではありません. しかし ``eval`` をデシリアライズ (deserialization) に使う場合は, 代替手段よりも ``eval`` の方が便利です. (例えば RPC レスポンスを評価するときなど)

Deserialization とはバイト列をメモリ上のデータ構造に変換する処理です. 例えば, 以下のようなオブジェクトがファイルに書き出してあったとします:

.. code-block:: javascript

   users = [
     {
       name: 'Eric',
       id: 37824,
       email: 'jellyvore@myway.com'
     },
     {
       name: 'xtof',
       id: 31337,
       email: 'b4d455h4x0r@google.com'
     },
     ...
   ];

単にこの文字列を ``eval`` するだけで, このデータをメモリに移すことができます.

また, ``eval()`` によって RPC のレスポンスを簡単にデコードできます. 例えば ``XMLHttpRequest`` を使って RPC の呼出を行ない, サーバは JavaScript を返す場合はこのようになります:

.. code-block:: javascript

   var userOnline = false;
   var user = 'nusrat';
   var xmlhttp = new XMLHttpRequest();
   xmlhttp.open('GET', 'http://chat.google.com/isUserOnline?user=' + user, false);
   xmlhttp.send('');
   // サーバは以下のようなコードを返す:
   // userOnline = true;
   if (xmlhttp.status == 200) {
     eval(xmlhttp.responseText);
   }
   // userOnline は現在 true になる.

with() {}
----------------------------------------
使用すべきでない.

``with`` によってコードの意味がわかりにくくなります. ``with`` のオブジェクトはローカル変数と衝突するプロパティを持ちます. これによってプログラムの意味が大きく変わってしまいます. 例えば次のコードはどういう動作をするでしょう?

.. code-block:: javascript

   with (foo) {
     var x = 3;
     return x;
   }

答え: anything. ローカル変数 ``x`` は ``foo`` プロパティによって上書きされます. もし ``x`` がセッターだったとき, 3 を代入することが沢山のコードを実行してしまいます. ``with`` を使ってはいけません.

this
----------------------------------------
オブジェクトのコンストラクタ, メソッド, クロージャのセットアップのときのみ使用可.

this の意味はトリッキーです. this はグローバルスコープを指していたり (多くの場合), 呼び出し元を指していたり (``eval``), DOMのノードを指していたり (イベントハンドラを HTML 要素にセットした場合), 新しく作られたオブジェクトを指していたり (コンストラクタ), なにか他のオブジェクトを指している場合 (call(), apply() された関数) もあります.

this の使用は間違えやすいので, 以下の場面以外での使用は制限されています.

- コンストラクタ内での使用
- オブジェクトのメソッド内での使用 (クロージャの作成を含む)

for-in ループ
----------------------------------------
オブジェクト, map, hash のキーに対してイテレーションする場合のみ使用可.

``for-in`` ループは配列のすべての要素を走査する場合などによく誤って利用されています. これはインデックス ``0`` から ``length - 1`` までをループするわけではなく, 配列プロトタイプにあるすべてのキーについてループします. 以下は ``for-in`` ループでの配列の走査を失敗する例です.

.. code-block:: javascript

   function printArray(arr) {
     for (var key in arr) {
       print(arr[key]);
     }
   }
   
   printArray([0,1,2,3]);  // 正しく動作.
   
   var a = new Array(10);
   printArray(a);  // 正しく動かない.
   
   a = document.getElementsByTagName('*');
   printArray(a);  // 正しく動かない.
   
   a = [0,1,2,3];
   a.buhu = 'wine';
   printArray(a);  // 正しく動かない.

   a = new Array;
   a[3] = 3;
   printArray(a);  // 正しく動かない.

配列には通常の ``for`` ループを使用してください.

.. code-block:: javascript

   function printArray(arr) {
     var l = arr.length;
     for (var i = 0; i < l; i++) {
       print(arr[i]);
     }
   }

連想配列
----------------------------------------
配列を map/hash/連想配列 として使用してはいけません.

連想配列は許可されていません, つまり配列に数値以外のインデックスを使用してはいけません. map/hash を使いたいときは配列でなくオブジェクトを使用してください. なぜならこのような機能はもともと配列ではなくオブジェクトの機能です. 配列はオブジェクトを拡張したものです (そして他の JavaScript のオブジェクト, Data, RegExp, String なども同様です).

複数行の string リテラル
----------------------------------------
以下のような複数行の文字列は使用してはいけません.

.. code-block:: javascript

   var myString = 'A rather long string of English text, an error message \
                   actually that just keeps going and going -- an error \
                   message to make the Energizer bunny blush (right through \
                   those Schwarzenegger shades)! Where was I? Oh yes, \
                   you\'ve got an error and all the extraneous whitespace is \
                   just gravy.  Have a nice day.';

各行の先頭の空白はコンパイラによって安全に取り除かれますが, スラッシュの後の空白によってトリッキーなエラーが発生する可能性があります. また多くの JavaScript エンジンはこの記法をサポートしていますが, これは ECMAScript 標準ではありません.

このような場合は, 次のように文字列を結合させます.

.. code-block:: javascript

   var myString = 'A rather long string of English text, an error message ' +
       'actually that just keeps going and going -- an error ' +
       'message to make the Energizer bunny blush (right through ' +
       'those Schwarzenegger shades)! Where was I? Oh yes, ' +
       'you\'ve got an error and all the extraneous whitespace is ' +
       'just gravy.  Have a nice day.';

.. note:: 訳注

   バックスラッシュによる複数行の string リテラルは ECMAScript 3 では非標準だったのですが, ECMAScript 5 では標準化されたようです.

   http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-262.pdf

配列・オブジェクトリテラル
----------------------------------------
使用して良い.

``Array``, ``Object`` コンストラクタではなくリテラルを使ってください.

``Array`` コンストラクタはその引数の取り方のせいでエラーを引き起こしがちです.

.. code-block:: javascript
   
   // 長さは 3.
   var a1 = new Array(x1, x2, x3);
   
   // 長さは 2.
   var a2 = new Array(x1, x2);
   
   // もし x1 が数字で, かつ自然数の場合, length は x1 になる.
   // もし x1 が数字で, かつ自然数でない場合, 例外が発生する.
   // 数字でない場合, 配列は x1 を値として持つ.
   var a3 = new Array(x1);
   
   // 長さは 0.
   var a4 = new Array();

コンストラクタはこのような動作をするので, もし別のひとがコードを書き換えて, コンストラクタに2つの引数を与えていたところを1つにすると, その結果できた配列は期待する長さを持っていないかもしれません.

このようなミスを避けるために, 配列のリテラルを使用してください.

.. code-block:: javascript

   var a = [x1, x2, x3];
   var a2 = [x1, x2];
   var a3 = [x1];
   var a4 = [];

オブジェクトの場合は, コンストラクタに配列のような紛らわしさはないのですが, 可読性と一貫性のためにリテラルを使用してください. 

.. code-block:: javascript

   var o = new Object();
   
   var o2 = new Object();
   o2.a = 0;
   o2.b = 1;
   o2.c = 2;
   o2['strange key'] = 3;

上記のようなコードは, 以下のように書くべきです.

.. code-block:: javascript

   var o = {};
   
   var o2 = {
     a: 0,
     b: 1,
     c: 2,
     'strange key': 3
   };

ビルトインオブジェクトのプロトタイプの書き換え
--------------------------------------------------------------------------------
してはいけません.

``Object.prototype`` や ``Array.prototype`` などのビルトインオブジェクトのプロトタイプを変更することは厳密に禁じられています. ``Function.prototype`` などはそれに比べ比較的安全ですが, デバッグ時に問題を引き起こす可能性があるので, 変更は避けてください.

Internet Explorer の条件付きコメント
--------------------------------------------------------------------------------
使ってはいけない.

次のように書かないでください.

.. code-block:: javascript

   var f = function () {
     /*@cc_on if (@_jscript) { return 2* @*/  3; /*@ } @*/
   };

条件付きコメントはランタイムに JavaScript のシンタックスツリーを変更するので, 自動化されたツールの動作を妨げてしまいます.

JavaScript Style Rules
========================================

命名
----------------------------------------
基本的に次のように命名してください: ``functionNamesLikeThis, variableNamesLikeThis, ClassNamesLikeThis, EnumNamesLikeThis, methodNamesLikeThis, and SYMBOLIC_CONSTANTS_LIKE_THIS.``

プロパティとメソッド
****************************************

- ``Private`` のプロパティ, 変数, メソッドには, 末尾にアンダースコア ``_`` を付けてください.
- ``Protected`` のプロパティ, 変数, メソッドにはアンダースコアを付けないでください (パブリックなものと同様です).

``Private`` と ``Protected`` に関しては visibility のセクションを参考にしてください.

メソッドと関数パラメータ
****************************************
オプション引数には ``opt_`` というプレフィックスをつけてください.

可変長の引数を取る場合, 最後の引数を ``var_args`` と名づけてください. ただし参照する際は ``var_args`` ではなく ``arguments`` を参照するようにしてください.

オプション引数と可変長引数に関しては ``@param`` アノテーションでもコンパイラは正しく解釈してくれます. 両方を同時に用いることが好ましいです.

getter と setter
****************************************
getter, setter は必須ではありません. もし使う場合は ``getFoo()``, ``setFoo(value)`` という名前にしてください. (boolean の getter の場合は ``isFoo()`` も許可されています. こちらのほうがより自然です.)

名前空間
****************************************
JavaScript は階層的なパッケージングや名前空間をサポートしていません.

グローバル名前衝突が起こるとデバッグは難しくなり, 2つのプロジェクトの統合も難しくなります. 名前の衝突を避け, 共有できる JavaScript コードをモジュール化するために, 以下のような規約を設けています.

グローバルなコードには名前空間を使う
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
グローバルスコープに出すものには, プロジェクトやライブラリ名に関連したプレフィックスを常に付けてください. 例えば "Project Sloth" の場合, ``sloth.*`` という具合です.

.. code-block:: javascript

   var sloth = {};
   
   sloth.sleep = function() {
     ...
   };
   
`Closure Library <http://code.google.com/closure/library/>`_ や `Dojo toolkit <http://www.dojotoolkit.org/>`_ でも名前空間を定義する関数が提供されています. これらを使う場合は一貫性に注意してください.

.. code-block:: javascript

   goog.provide('sloth');
   
   sloth.sleep = function() {
     ...
   };

名前空間のオーナーシップへの配慮
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
子の名前空間を作る場合は, 親の名前空間への連絡をしてください. sloth から hats というプロジェクトを始めた場合は, sloth チームに ``sloth.hats`` という名前を使用する旨を伝えてください.

外部のコードと内部のコードで別の名前空間を使う
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"外部のコード (External code)" とはあなたのコードの外から読み込んだもので, 独立してコンパイルされたものです. 内部と外部のコードの名前空間は厳密に分けてください. もし ``foo.hats.*`` という外部ライブラリを使用した場合, 衝突の可能性があるので, 内部のコードでは ``foo.hats.*`` に何も定義してはいけません.

.. code-block:: javascript
   
   foo.require('foo.hats');
   
   /**
    * 間違い -- 絶対にこのようにはしないでください.
    * @constructor
    * @extend {foo.hats.RoundHat}
    */
   foo.hats.BowlerHat = function() {
   };

もし外部名前変数に新しい API を定義する必要がある場合は, 明示的に公開 API をエクスポート擦る必要があります. 一貫性とコンパイラの最適化のために, 内部のコードでは内部の API を内部の名前で呼ぶ必要があります. 

.. code-block:: javascript

   foo.provide('googleyhats.BowlerHat');
   
   foo.require('foo.hats');
   
   /**
    * @constructor
    * @extend {foo.hats.RoundHat}
    */
   googleyhats.BowlerHat = function() {
     ...
   };
   
   goog.exportSymbol('foo.hats.BowlerHat', googleyhats.BowlerHat);

長い型名をエイリアスし可読性を向上させる
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
ローカルのエイリアスを使うことで長い型名の可読性を向上できる場合はそうしてください. エイリアスの名前は型名の最後の部分にしてください.

.. code-block:: javascript

   /**
    * @constructor
    */
   some.long.namespace.MyClass = function() {
   };
   
   /**
    * @param {some.long.namespace.MyClass} a
    */
   some.long.namespace.MyClass.staticHelper = function(a) {
   	  ...
   };
   
   myapp.main = function() {
   	var MyClass = some.long.namespace.MyClass;
   	var staticHelper = some.long.namespace.MyClass.staticHelper;
   	staticHelper(new MyClass());
   };

名前空間のエイリアスは作成しないでください.

.. code-block:: javascript

   // 訳注: 悪い例
   myapp.main = function() {
     var namespace = some.long.namespace;
     namespace.MyClass.staticHelper(new namespace.MyClass());
   };

エイリアスした型のプロパティにはアクセスしないでください. ただし列挙型は除きます.

.. code-block:: javascript

   // 訳注: エイリアスからのプロパティアクセスが許可される例 (enumであるため)
   /** @enum {string} */
   some.long.namespace.Fruit = {
     APPLE: 'a',
     BANANA: 'b'
   };
   
   myapp.main = function() {
     var Fruit = some.long.namespace.Fruit;
     switch (fruit) {
       case Fruit.APPLE:
         ...
       case Fruit.BANANA:
         ...
     }
   };

.. code-block:: javascript

   // 訳注: 悪い例
   myapp.main = function() {
     var MyClass = some.long.namespace.MyClass;
     MyClass.staticHelper(null);
   };

グローバルスコープではエイリアスを使用しないでください. エイリアスは関数スコープの中でのみ使用可能です.

ファイル名
****************************************
ファイル名は case-sensitive なプラットフォームのために, 必ず小文字にしてください. サフィックスは ``.js`` に, 句読点は ``-``, ``_`` (``_`` よりも ``-`` を使用してください) 以外は使わないでください.

カスタム toString() メソッド
----------------------------------------
副作用なしに, 必ず動作しないといけません.

``toString()`` メソッドを定義して, 独自のオブジェクトがどのように文字列化されるかを定義できます. ただし以下の2点が必ず守られる必要があります.

1. 必ず成功する
2. 副作用がない

これらが守られなかった場合, 簡単に問題が引き起こされてしまいます. 例えば ``toString()`` が ``assert`` を呼び出している場合, ``assert`` はオブジェクト名をアウトプットしようとするので, ``toString()`` が必要になります.

初期化の延期
----------------------------------------
しても良い.

必ずしも宣言時に変数の初期化ができるわけではないので, 初期化を延期することは認められています.

明示的なスコープ
----------------------------------------
常に必要です.

常に明示的なスコープを使用してください. ポータビリティが向上し, またクリアになります. 例えば ``window`` が content window でないアプリケーションもあるので, ``window`` に依存するようなコードは書かないでください.

コードのフォーマット
----------------------------------------
基本的に `C++ formatting rules <http://google-styleguide.googlecode.com/svn/trunk/cppguide.xml#Formatting>`_ に従います. 以下はそれに追加する項目です.

波括弧
********************************************************************************
処理系によってセミコロンが暗黙で挿入されるのを防ぐために, かならず開き波括弧は改行せずに同じ行に書いてください.

.. code-block:: javascript

   if (something) {
     // ...
   } else {
     // ...
   }
   
配列・オブジェクトの初期化
********************************************************************************
一行に収まる場合は, 初期化を一行で行ってもかまいません.

.. code-block:: javascript

   var arr = [1, 2, 3];  // 括弧の前後に空白を入れないでください
   var obj = {a: 1, b: 2, c: 3};  // 括弧の前後に空白を入れないでください

複数行に渡る初期化の場合は, ふつうのブロック同様スペース2つのインデントを行ってください.

.. code-block:: javascript

   // オブジェクトの初期化
   var inset = {
     top: 10,
     right: 20,
     bottom: 15,
     left: 12
   };
   
   // 配列の初期化
   this.rows_ = [
     '*Slartibartfast* <fjordmaster@magrathea.com>',
     '*Zaphod Beeblebrox* <theprez@universe.gov>',
     '*Ford Prefect* <ford@theguide.com>',
     '*Arthur Dent* <has.no.tea@gmail.com>',
     '*Marvin the Paranoid Android* <marv@googlemail.com>',
     'the.mice@magrathea.com'
   ];
   
   // メソッドの引数としてのオブジェクト
   goog.dom.createDom(goog.dom.TagName.DIV, {
     id: 'foo',
     className: 'some-css-class',
     style: 'display:none'
   }, 'Hello, world!');
  
identifer が長い場合, プロパティを整列させると問題を引き起こす場合があるので, 整列させないようにしてください.

.. code-block:: javascript
   
   CORRECT_Object.prototype = {
     a: 0,
     b: 1,
     lengthyName: 2
   };
   
以下のようにはしないでください.

.. code-block:: javascript
   
   WRONG_Object.prototype = {
     a          : 0,
     b          : 1,
     lengthyName: 2
   };

関数の引数
********************************************************************************
可能ならば, すべての関数の引数は一行にしてください. もしそれでは80文字の制限を超えてしまう場合は, 読みやすい形で複数行にしてください. スペースの節約のために各行をできるだけ80文字に近づけるように書くか, あるいは可読性のためにひとつの引数に付き一行を割り当てます. インデントは空白4つにするか, 括弧にあわせてください. 以下に典型的な例を示します.

.. code-block:: javascript

   // 空白4つのインデント, 80文字近くまで並べる. とても長い関数名で, スペースが少ない場合.
   goog.foo.bar.doThingThatIsVeryDifficultToExplain = function(
       veryDescriptiveArgumentNumberOne, veryDescriptiveArgumentTwo,
       tableModelEventHandlerProxy, artichokeDescriptorAdapterIterator) {
     // ...
   };
   
   // 空白4つのインデント, 1引数につき1行. とても長い関数名で各引数を強調したい場合
   goog.foo.bar.doThingThatIsVeryDifficultToExplain = function(
       veryDescriptiveArgumentNumberOne,
       veryDescriptiveArgumentTwo,
       tableModelEventHandlerProxy,
       artichokeDescriptorAdapterIterator) {
     // ...
   };
   
   // 括弧に合わせたインデント, 80文字近くまで並べる. 引数を見やすくまとめて, スペースが少ない場合.
   function foo(veryDescriptiveArgumentNumberOne, veryDescriptiveArgumentTwo,
                tableModelEventHandlerProxy, artichokeDescriptorAdapterIterator) {
     // ...
   }
   
   // 括弧に合わせたインデント, 1引数につき1行. 引数を見やすくまとめて, 各引数を強調したい場合.
   function bar(veryDescriptiveArgumentNumberOne,
                veryDescriptiveArgumentTwo,
                tableModelEventHandlerProxy,
                artichokeDescriptorAdapterIterator) {
     // ...
   }

関数呼び出しそのものがインデントされている場合は, オリジナルの文のはじめからスペース4つ分のインデントをあけ引数を記述, 関数呼び出しのはじめからスペース4つ分のインデントをあけ引数を記述, のどちらでもかまいません. 以下はすべて正しいインデント方法です.

.. code-block:: javascript

   if (veryLongFunctionNameA(
           veryLongArgumentName) ||
       veryLongFunctionNameB(
       veryLongArgumentName)) {
     veryLongFunctionNameC(veryLongFunctionNameD(
         veryLongFunctioNameE(
             veryLongFunctionNameF)));
   }

無名関数を渡す場合
********************************************************************************
関数の引数として無名関数を定義し渡すとき, 無名関数の中身はその分の左端からスペース2つか, あるいは ``function`` キーワードの左端からスペース2つのインデントを入れます. これは引数の無名関数の可読性を高めるためのルールです (例えばコードが右側に寄りすぎてしまうのを防ぎます).

.. code-block:: javascript

   prefix.something.reallyLongFunctionName('whatever', function(a1, a2) {
     if (a1.equals(a2)) {
       someOtherLongFunctionName(a1);
     } else {
       andNowForSomethingCompletelyDifferent(a2.parrot);
     }
   });
   
   var names = prefix.something.myExcellentMapFunction(
       verboselyNamedCollectionOfItems,
       function(item) {
         return item.name;
       });
   
More Information
********************************************************************************
配列・オブジェクトの初期化と引数としての無名関数以外では, すべて文の左端に合わせるか, 左からスペース4つのインデントにします.

.. code-block:: javascript

   someWonderfulHtml = '' +
                       getEvenMoreHtml(someReallyInterestingValues, moreValues,
                                       evenMoreParams, 'a duck', true, 72,
                                       slightlyMoreMonkeys(0xfff)) +
                       '';
   
   thisIsAVeryLongVariableName =
       hereIsAnEvenLongerOtherFunctionNameThatWillNotFitOnPrevLine();
   
   thisIsAVeryLongVariableName = 'expressionPartOne' + someMethodThatIsLong() +
       thisIsAnEvenLongerOtherFunctionNameThatCannotBeIndentedMore();
   
   someValue = this.foo(
       shortArg,
       '非常に長い文字列型の引数 - 実際にはこのようなケースはとてもよくあります.',
       shorty2,
       this.bar());
   
   if (searchableCollection(allYourStuff).contains(theStuffYouWant) &&
       !ambientNotification.isActive() && (client.isAmbientSupported() ||
                                           client.alwaysTryAmbientAnyways())) {
     ambientNotification.activate();
   }
   
空白行
********************************************************************************
論理的に関連のある行をまとめるために空白行を使用してください.

.. code-block:: javascript

   doSomethingTo(x);
   doSomethingElseTo(x);
   andThen(x);
   
   nowDoSomethingWith(y);
   
   andNowWith(z);
   
2項・3項演算子
********************************************************************************
演算子は常に先行する行においてください. そうしないと暗黙のセミコロンの問題が発生します. 改行を入れる場合は上記のルールにのっとってインデントします.

.. code-block:: javascript

   var x = a ? b : c;  // 可能ならば1行に
   
   // 空白4つのインデント
   var y = a ?
       longButSimpleOperandB : longButSimpleOperandC;
   
   // 最初のオペランドに合わせたインデント
   var z = a ?
           moreComplicatedB :
           moreComplicatedC;
   
丸括弧
----------------------------------------
必要なところだけで使います.

構文上・ 意味上不可欠な場面以外では, 丸括弧を使わないようにします.

単項演算子 (delete, typeof) や void に丸括弧を使用してはいけません. また return や throw, case, new などのあとにも付けません.

文字列
----------------------------------------
``"`` よりも ``'`` を使ってください.

ダブルクオートよりもシングルクオートを使ってください. そのほうが HTML を含む文字列を作る際に便利です.

.. code-block:: javascript

   var msg = 'なんらかの HTML';

Visibility (private, protected 領域)
----------------------------------------
JSDoc の ``@private``, ``@protected`` アノテーションが推奨されます.

クラス, 関数, プロパティの visibility レベルの指定に, JSDoc の ``@private``, ``@protected`` アノテーションを使うことが推奨されます.

コンパイル時に ``--jscomp_warning=visibility`` フラグを付けることで, visibility の侵害があった場合コンパイラが警告を出してくれるようにできます. 詳しくは `Closure Compiler Warnings <http://code.google.com/p/closure-compiler/wiki/Warnings>`_ を参照してください.

``@private`` なグローバル変数と関数は同じファイルのコードからのみアクセスできます.

``@private`` なコンストラクタは, 同じファイルの同じインスタンスのメンバーからアクセスできます. また ``@private`` コンストラクタは同じファイルのパブリックな静的プロパティと ``instanceof`` 演算子からアクセスできます.

グローバル変数・関数・コンストラクタは ``@protected`` にはなりません.

.. code-block:: javascript

   // File 1.
   // AA_PrivateClass_ と AA_init_ はグローバルで同じファイルからなのでアクセスできる
   
   /**
    * @private
    * @constructor
    */
   AA_PrivateClass_ = function() {
   };
   
   /** @private */
   function AA_init_() {
     return new AA_PrivateClass_();
   }
   
   AA_init_();
   
``@private`` なプロパティは同じファイルのすべてのコードにアクセスできます. 加えて, そのプロパティがクラスに属していた場合, そのプロパティが含まれるクラスの静的メソッドとインスタンスメソッドにもアクセスできます. ただし, 別ファイルのサブクラスからアクセスしたり, オーバーライドすることはできません.

``@protected`` なプロパティは同じファイルのすべてのコードにアクセスできます. 加えて, そのプロパティを含むクラスのサブクラスの, 静的メソッドとインスタンスメソッドにもアクセスできます.

ここで, これらのセマンティクスは C++ や Java のものとは異なっていることに注意してください. まずここでの private, protected 指定は同じファイルのすべてのコードにアクセス権を与えていて, C++ や Java のようにクラスの継承関係によってアクセス権が変化するものではありません. また private なプロパティはサブクラスからオーバーライドできないことも, C++ などと異なる点です.

.. code-block:: javascript

   // File 1.
   
   /** @constructor */
     AA_PublicClass = function() {
   };
   
   /** @private */
   AA_PublicClass.staticPrivateProp_ = 1;
   
   /** @private */
   AA_PublicClass.prototype.privateProp_ = 2;
   
   /** @protected */
   AA_PublicClass.staticProtectedProp = 31;
   
   /** @protected */
   AA_PublicClass.prototype.protectedProp = 4;
   
   // File 2.
   
   /**
    * @return {number} The number of ducks we've arranged in a row (一列にならべるアヒルの数).
    */
   AA_PublicClass.prototype.method = function() {
     // これら2つのプロパティへの合法的なアクセス
     return this.privateProp_ + AA_PublicClass.staticPrivateProp_;
   };
   
   // File 3.
   
   /**
    * @constructor
    * @extends {AA_PublicClass}
    */
   AA_SubClass = function() {
     // protected な静的プロパティへの合法的なアクセス
     AA_PublicClass.staticProtectedProp = this.method();
   };
   goog.inherits(AA_SubClass, AA_PublicClass);
   
   /**
    * @return {number} The number of ducks we've arranged in a row (一列にならべるアヒルの数).
    */
   AA_SubClass.prototype.method = function() {
     // protected なインスタンスプロパティへの合法的なアクセス
     return this.protectedProp;
   };

JavaScript の型
----------------------------------------
コンパイラによって強制されます.

JSDoc で型についてドキュメント化するときはできるだけ型を特定し正確にしてください. サポートしているのは `JS2 <http://wiki.ecmascript.org/doku.php?id=spec:spec>`_ と JS1.x の型です.

JavaScript 型指定言語
********************************************************************************
JS2 のプロポーサルには JavaScript の型を指定するための言語が記述されています. この言語を使って JSDoc のドキュメントに関数パラメータや返り値の型を記述します.

JS2 のプロポーサルの発展によって, 記法にも変化がありました. コンパイラは古い記法をサポートしていますがそれらは非推奨です.

.. note:: 訳注

   省略しました. 詳しくは原文にある表を参照してください. 後日補完します.

   http://google-styleguide.googlecode.com/svn/trunk/javascriptguide.xml?showone=JavaScript_Types#JavaScript_Types

JavaScript の型
********************************************************************************

.. note:: 訳注

   省略しました. 詳しくは原文にある表を参照してください. 後日補完します.

   http://google-styleguide.googlecode.com/svn/trunk/javascriptguide.xml?showone=JavaScript_Types#JavaScript_Types

nullable vs オプション パラメータとプロパティ
********************************************************************************
JavaScript は弱い型付けの言語なので, 関数の引数やクラスのプロパティの オプション引数, nullable (ヌルを取り得る), undefine の3つの違いについて知る必要があります.

オブジェクトの型 (あるいは参照型) はデフォルトで nullable です. しかし関数の型はデフォルトで nullable ではありません. オブジェクトは文字列, 数字, 真偽値, undefine 以外のものか null として定義されます. 例として以下のコードを示します.

.. code-block:: javascript

   /**
    * コンストラクタの引数 value で初期化されるクラス.
    * @param {Object} value Some value.
    * @constructor
    */
   function MyClass(value) {
     /**
      * 何らかの値.
      * @type {Object}
      * @private
      */
     this.myValue_ = value;
   }
   
このコードではコンパイラに ``myValue_`` プロパティはオブジェクトか null をとるように指定しています. もし ``myValue_`` が null を取りえなくする場合は次のようにします。

.. code-block:: javascript

   /**
    * コンストラクタの引数 value (なんらかの null でない値) で初期化されるクラス.
    * @param {!Object} value Some value.
    * @constructor
    */
   function MyClass(value) {
     /**
      * 何らかの値.
      * @type {!Object}
      * @private
      */
     this.myValue_ = value;
   }
   
この場合, もし ``myClass`` が null で初期化されたとき, コンパイラがワーニングを出します.

関数のオプションパラメータは実行時に undefined に成り得ます. よってそれらがクラスのプロパティとして使われる場合は, 以下のように定義する必要があります.

.. code-block:: javascript

   /**
    * コンストラクタの引数 value (オプション) で初期化されるクラス.
    * @param {Object=} opt_value Some value (optional).
    * @constructor
    */
   function MyClass(opt_value) {
     /**
      * 何らかの値.
      * @type {Object|undefined}
      * @private
      */
     this.myValue_ = opt_value;
   }

この場合 ``myValue_`` はオブジェクト, null, undefined を取り得ます.

ここで ``opt_value`` は ``{Object|undefined}`` ではなく ``{Object=}`` と定義されていることに注意してください. これはオプションのパラメータは定義上そもそも undefined に成りえるためです. 可読性のためわざわざ undefined を取りうることを明示する必要はありません.

最後に, nullable と オプション引数 の指定は直行しています. よって以下の4つの宣言はすべて別の意味です.

.. code-block:: javascript

   /**
    * 4つのうち2つは nullable, 2つはオプション
    * @param {!Object} nonNull Mandatory (must not be undefined), must not be null.
    * @param {Object} mayBeNull Mandatory (must not be undefined), may be null.
    * @param {!Object=} opt_nonNull Optional (may be undefined), but if present,
    *     must not be null!
    * @param {Object=} opt_mayBeNull Optional (may be undefined), may be null.
    */
   function strangeButTrue(nonNull, mayBeNull, opt_nonNull, opt_mayBeNull) {
     // ...
   };
   
コメント
----------------------------------------
JSDoc を使用してください.

ファイル, クラス, メソッドをドキュメンテーションするために `JSDoc <http://code.google.com/p/jsdoc-toolkit/>`_ のコメントを使用してください. インラインのコメントには ``//`` を使います. 加えて, `C++ style for comments <http://google-styleguide.googlecode.com/svn/trunk/cppguide.xml#Comments>`_ に基本的に従います. つまり以下のような内容を記述します.

- コピーライトと作者情報
- トップレベル (ファイルレベル) のコメント. このファイルに詳しくない読者を対象として, このファイルでは何をしているのかを説明します. (例えば, 主要なコードのパーツとそれらがどのように協調しているかを1パラグラフ程度で書きます)
- 必要ならばクラス, 関数, 変数と実装のコメント
- 対象ブラウザ
- 固有の記法 (capitalization, punctuation, spelling)

文章が断片的になることは避けて, 文の開始は大文字, 文の最後には句点を入れます.

新人プログラマがあなたのコードをメンテナンスすることを想定して書いてください. そうすればきっとうまくいきます!

コンパイラは JSDoc で書かれたコメントから情報を抜き出し, validation や不要なコードの削除, コードの圧縮などに使用します. よって JSDoc の正しい記法で記述してください.

トップレベル・ファイルレベルコメント
********************************************************************************
トップレベルコメントはそのコードに詳しくない読者を対象として, そのファイルが何をしているのかを説明するコメントです. ファイルの内容, 作者, コンパチビリティの情報などを記述します.

.. code-block:: javascript

   // Copyright 2009 Google Inc. All Rights Reserved.
   
   /**
    * @fileoverview ファイルの説明, 使用方法や
    * 依存関係の情報など.
    * @author user@google.com (Firstname Lastname)
    */
   
クラスコメント
********************************************************************************
クラスコメントには説明と使用方法を記述します. コンストラクタのパラメータについても記述します. もし他のクラスを継承している場合は ``@extends`` タグを使用します. インタフェースを実装している場合は ``@implements`` タグを使用します.

.. code-block:: javascript

   /**
    * なんだか楽しいクラス.
    * @param {string} arg1 An argument that makes this more interesting.
    * @param {Array.<number>} arg2 List of numbers to be processed.
    * @constructor
    * @extends {goog.Disposable}
    */
   project.MyClass = function(arg1, arg2) {
     // ...
   };
   goog.inherits(project.MyClass, goog.Disposable);
   
メソッド・関数コメント
********************************************************************************
パラメータの説明を必ず記述します. それが適切・必要な場合はフルセンテンスで記述します. メソッドの説明文は, 第三者が宣言している文体で書きます.

.. code-block:: javascript

   /**
    * テキストをなにか全く別のテキストに変換する
    * @param {string} arg1 An argument that makes this more interesting.
    * @return {string} Some return value.
    */
   project.MyClass.prototype.someMethod = function(arg1) {
     // ...
   };
   
   /**
    * MyClass のインスタンスを処理して何かを返す関数
    * @param {project.MyClass} obj Instance of MyClass which leads to a long
    *     comment that needs to be wrapped to two lines.
    * @return {boolean} Whether something occured.
    */
   function PR_someMethod(obj) {
     // ...
   }
   
パラメータのないシンプルな getter メソッドの場合は説明を省略できます.

.. code-block:: javascript

   /**
    * @return {Element} あるコンポーネントの要素.
    */
   goog.ui.Component.prototype.getElement = function() {
     return this.element_;
   };
   
プロパティコメント
********************************************************************************
プロパティにもコメントを付けると良いです.

.. code-block:: javascript
   
   /**
    * 1 pane ごとの最大数.
    * @type {number}
    */
   project.MyClass.prototype.someProperty = 4;

型キャストコメント
********************************************************************************
型チェックがある文の型を正確に推論できない場合, 型キャストのコメントを付加して括弧でくくります. 括弧は必ず必要です. コメントと共に括弧でくくります.

.. code-block:: javascript
   
   /** @type {number} */ (x)
   (/** @type {number} */ x)
   
JSDoc のインデント
********************************************************************************
``@param``, ``@return``, ``@supported``, ``@this``, ``@deprecated`` アノテーションが複数行に渡る場合, 空白4つのインデントを使います.

.. code-block:: javascript

   /**
    * 説明文が長く, 複数行にまたがった場合の例.
    * @param {string} これはとても説明文の長い引数の例です. 複数行にまたがる場合は空白4つ分の
    *     インデントを入れてください.
    * @return {number} これはとても説明文の長い返り値の例です. 複数行にまたがる場合は空白4つ分の
    *     インデントを入れてください.
    */
   project.MyClass.prototype.method = function(foo) {
     return 5;
   };

``@fileoverview`` のコメントはインデントしてはいけません.

文章の左端でそろえる方法も可能ですが, 推奨されません. 変数名が変わったときに毎回対応する必要が出てくるためです.

.. code-block:: javascript

   /**
    * これらは推奨されないインデントの例です.
    * @param {string} これはとても説明文の長い引数の例です. 複数行にまたがっていますが, 上の例のように
    *                     4スペースのインデントではありません.
    * @return {number} これはとても説明文の長い返り値の例です. 複数行にまたがっていますが, 4つの空白ではなく
    *                  説明文の開始位置にあわせてインデントしています.
    */
   project.MyClass.prototype.method = function(foo) {
     return 5;
   };
   
Enum
********************************************************************************
.. code-block:: javascript

   /**
    * 3つの状態を持つ Enum
    * @enum {number}
    */
   project.TriState = {
     TRUE: 1,
     FALSE: -1,
     MAYBE: 0
   };
   
Enum は有効な型でもあるので, パラメータの型などで使用することができます.

.. code-block:: javascript

   /**
    * プロジェクトの状態をセットする関数
    * @param {project.TriState} state New project state.
    */
   project.setState = function(state) {
     // ...
   };
   
Typedef
********************************************************************************
型が複雑になることもあります. 例えばある要素を引数としてとる関数はこのようになります:

.. code-block:: javascript

   /**
    * @Param {string} tagName
    * @param {(string|Element|Text|Array.<Element>|Array.<Text>)} contents
    * @return {Element}
    */
   goog.createElement = function(tagName, contents) {
     ...
   };
   
``@typedef`` タグで型を定義することができます.

.. code-block:: javascript

   /** @typedef {(string|Element|Text|Array.<Element>|Array.<Text>)} */
   goog.ElementContent;
   
   /**
   * @param {string} tagName
   * @param {goog.ElementContent} contents
   * @return {Element}
   */
   goog.createElement = function(tagName, contents) {
   ...
   };

テンプレート型
********************************************************************************
コンパイラはテンプレート型を不完全にしかサポートできていません. コンパイラは無名関数の中の ``this`` の型については, ``this`` 引数の型とそれの有無からしか推論できません.

.. code-block:: javascript

   /**
    * @param {function(this:T, ...)} fn
    * @param {T} thisObj
    * @param {...*} var_args
    * @template T
    */
   goog.bind = function(fn, thisObj, var_args) {
   ...
   };
   // プロパティが無いという警告を出すことができる例
   goog.bind(function() { this.someProperty; }, new SomeClass());
   // undefined this という警告を出す例
   goog.bind(function() { this.someProperty; });
   
JSDoc タグリファレンス
********************************************************************************
.. note:: 訳注

   省略しました. 詳しくは原文にある表を参照してください. 後日補完します.

   http://google-styleguide.googlecode.com/svn/trunk/javascriptguide.xml?showone=Comments#Comments

JSDoc での HTML
********************************************************************************
JavaDoc のように JSDoc でも多くの HTML タグがサポートされています. 

よってプレインテキスト上のフォーマットは考慮されなくなります. JSDoc では空白に頼ったフォーマットをしないでください.

.. code-block:: javascript

   /**
    * 3つの要素から重みを計算する:
    *   items sent
    *   items received
    *   last timestamp
    */
   
このコードは次のように表示されます

.. code-block:: javascript

   3つの要素から重みを計算する: items sent items received items received 

代わりに以下のように記述してください.

.. code-block:: javascript

   /**
    * 3つの要素から重みを計算する:
    * <ul>
    * <li>items sent
    * <li>items received
    * <li>last timestamp
    * </ul>
    */
   
また, HTML として解釈できないようなタグを書かないでください.

.. code-block:: javascript

   /**
    * <b> タグを <span> タグへ変換する.
    */
   
これは次のように表示されます.

.. code-block:: javascript

    タグを  タグへ変換する.  

さらに, プレインテキストのドキュメントも同様によく読まれます. あまり HTML 表記にこだわりすぎないでください.

.. code-block:: javascript

   /**
    * &lt;b&gt; タグを &lt;span&gt; タグへ変換する.
    */
   
'少なり', '大なり' 記号をわざわざ書かなくても読者には伝わるでしょう. 以下のように記述してください.

.. code-block:: javascript

   /**
   * 'b' タグを 'span' タグへ変換する.
   */
   
コンパイル
----------------------------------------
`Closure Compiler <http://code.google.com/closure/compiler/>`_ のような JavaScript コンパイラを使うことが推奨されています.

Tips や トリック
----------------------------------------

真偽値表現
********************************************************************************
以下はすべて boolean 表現では false になります.

- null
- undefined
- '' (空の文字列)
- 0 (数字)

以下は true になるので注意してください

- '0' (文字列)
- [] (空の配列)
- {} (空のオブジェクト)

以上より, 以下のようなコードの代わりに:

.. code-block:: javascript

   while (x != null) {

以下のように短く書くことができます (ただし x は 0 や空文字列や false にならないと仮定しています). 

.. code-block:: javascript

   while (x) {

もし文字列が null でも空でもないことをチェックしたいときは:

.. code-block:: javascript

   if (y != null && y != '') {

こうではなく, 以下のようによりスマートに記述できます.

.. code-block:: javascript

   if (y) {

ただし, boolean 表現には直感的でないものが多くあるので注意してください.

.. code-block:: javascript

      Boolean('0') == true
      '0' != true
      0 != null
      0 == []
      0 == false
      Boolean(null) == false
      null != true
      null != false
      Boolean(undefined) == false
      undefined != true
      undefined != false
      Boolean([]) == true
      [] != true
      [] == false
      Boolean({}) == true
      {} != true
      {} != false

条件式と3項演算子
********************************************************************************
このコードの代わりに:

.. code-block:: javascript

   if (val != 0) {
     return foo();
   } else {
     return bar();
   }
   
以下のように書けます.

.. code-block:: javascript

   return val ? foo() : bar();

3項演算子は HTML を生成するときにも便利です.

.. code-block:: javascript

   var html = '<input type="checkbox"' +
       (isChecked ? ' checked' : '') +
       (isEnabled ? '' : ' disabled') +
       ' name="foo">';

&& と ||
********************************************************************************
2項の boolean 演算子はショートサーキットで, 最後の項まで評価されます.

``||`` は "デフォルト演算子" とも呼ばれます. 以下のコードは,

.. code-block:: javascript

   /** @param {*=} opt_win */
   function foo(opt_win) {
     var win;
     if (opt_win) {
       win = opt_win;
     } else {
       win = window;
     }
     // ...
   }

次のように書き換えられます.

.. code-block:: javascript

   /** @param {*=} opt_win */
   function foo(opt_win) {
     var win = opt_win || window;
     // ...
   }

同様に ``&&`` 演算子を使うことでもコードを短縮できます. このようなコードの代わりに:

.. code-block:: javascript

   if (node) {
     if (node.kids) {
       if (node.kids[index]) {
         foo(node.kids[index]);
       }
     }
   }

次のように書けます.

.. code-block:: javascript

   if (node && node.kids && node.kids[index]) {
     foo(node.kids[index]);
   }

あるいは, 次のような書き方も可能です.

.. code-block:: javascript

   var kid = node && node.kids && node.kids[index];
   if (kid) {
     foo(kid);
   }   

しかしながら, この例はすこしやりすぎでしょう.

.. code-block:: javascript

   node && node.kids && node.kids[index] && foo(node.kids[index]);

文字列の組み立てに join() を使う
********************************************************************************
このようなコードはよく見かけられます:

.. code-block:: javascript

   function listHtml(items) {
     var html = '<div class="foo">';
     for (var i = 0; i < items.length; ++i) {
       if (i > 0) {
         html += ', ';
       }
       html += itemHtml(items[i]);
     }
     html += '</div>';
     return html;
   }

しかしこの書き方は Internet Explorer では遅くなります. 次の書き方がベターです:

.. code-block:: javascript

   function listHtml(items) {
     var html = [];
     for (var i = 0; i < items.length; ++i) {
       html[i] = itemHtml(items[i]);
     }
     return '<div class="foo">' + html.join(', ') + '</div>';
   }
   
配列を stringbuilder として使い, ``myArray.join('')`` で文字列に変換することも可能です. また ``push()`` で配列の要素を追加するよりもインデックスを指定して追加する方が高速なので, そちらを用いるべきです.

ノードリストのイテレート
********************************************************************************
ノードリストの多くは, ノードのイテレータとフィルタから実装されています. よって, 例えばリストの長さを取得したい場合は O(n), またリストの要素を操作しそれぞれについて長さをチェックした場合は O(n^2) かかってしまいます.

.. code-block:: javascript

   var paragraphs = document.getElementsByTagName('p');
   for (var i = 0; i < paragraphs.length; i++) {
     doSomething(paragraphs[i]);
   }

代わりにこう書いたほうがベターです:

.. code-block:: javascript

   var paragraphs = document.getElementsByTagName('p');
   for (var i = 0, paragraph; paragraph = paragraphs[i]; i++) {
     doSomething(paragraph);
   }

これは, false として扱われる値を含まない, すべてのコレクションや配列に対して問題なく動作します.

.. note:: 訳注

   id:co-sche さんにご指摘いただき修正しました.

   http://d.hatena.ne.jp/co-sche/20100729/1280409953

childNodes をたどる場合は, firstChild や nextSibling プロパティを使うことができます.

.. code-block:: javascript

   var parentNode = document.getElementById('foo');
   for (var child = parentNode.firstChild; child; child = child.nextSibling) {
     doSomething(child);
   }

あとがき
========================================
**一貫性をもたせてください**

あなたがコードを書くとき, どのようなスタイルで書くかを決める前に, 少しまわりのコードを見るようにしてください. もし周りのコードが算術演算子の両端にスペースを入れていれば, あなたもそうすべきです. もしまわりのコードのコメントが, ハッシュマーク ``#`` を使って矩形を描いていたとしたら, あなたもまたそうすべきです.

コーディングスタイルのガイドラインを策定することのポイントは, コーディングの共通の語彙をもって, *どう書くか* ではなく *何を書くか* に集中できるようにすることです. 私たちはここでグローバルなスタイルのルールを提供したので, 人々は共通の語彙を得られたことになります しかしローカルなスタイルもまた重要です. もしあなたが追加したコードがあまりにも周りのコードと違っていた場合, コードを読む人のリズムが乱されてしまいます. それは避けてください.
