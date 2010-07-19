.. Google JavaScript Style Guide 和訳

===============================================================
Google JavaScript Style Guide 和訳
===============================================================


この和訳について
====================
この文章は `Google JavaScript Style Guide <http://google-styleguide.googlecode.com/svn/trunk/javascriptguide.xml>`_ を和訳したものです. 内容の正確性は保証しません. ライセンスは原文と同じく `CC-By 3.0 <http://creativecommons.org/licenses/by/3.0/>`_ とします. フィードバックは Kosei Moriyama (`@cou929 <http://twitter.com/cou929>`_ または cou929 at gmail.com) までお願いします. この和訳のリポジトリは `こちら <http://github.com/cou929>`_

バージョン
========================================
Revision 2.2

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

メソッドやプロパティをコンストラクタに付与する方法はいくつかありますが, 次の方法を推奨します:

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
     element.onclick = function() { /* uses a and b */ };
   }

上記の無名関数はそれらを使う・使わないにかかわらず ``element``, ``a``, ``b`` への参照をずっと保持しています. ``element`` はクロージャへの参照をもっているので, 循環が発生していて, gc が回収できなくなっています. この場合, コードは以下のような構造になっています:

.. code-block:: javascript

   function foo(element, a, b) {
     element.onclick = bar(a, b);
   }
   
   function bar(a, b) {
     return function() { /* uses a and b */ }
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

