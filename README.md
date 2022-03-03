# SystemEventHandler

イベントコールバックの処理を共通化するための仕組みを提供する。

## 特徴

* 一般イベントコールバック、時間変更コールバック、ビューポート再描画コールバックに対応。

* コールバックの遅延実行が可能。

## 要件

* [imaoki/Standard](https://github.com/imaoki/Standard)

## 動作確認

`3ds Max 2022.3 Update`

## インストール

01. 依存スクリプトがある場合は予めインストールしておく。

02. `install.ms`を実行する。

## アンインストール

`uninstall.ms`を実行する。

## スタンドアローン版

### インストール

01. 依存スクリプトがある場合は予めインストールしておく。

02. `Distribution\SystemEventHandler.min.ms`を実行する。

### アンインストール

```maxscript
::systemEventHandler.Uninstall()
```

## 使い方

### イベントハンドラの作成

[`ObserverStruct`](https://imaoki.github.io/mxskb/mxsdoc/standard-observer.html)を使用してイベントハンドラを作成する。

```maxscript
(
  fn update context params type: = (
    if classOf type == Name do (
      case type of (
        (#SelectionSetChanged): ()
        (#TimeChange): ()
        (#ViewportRedraw): ()
        default: ()
      )
    )
    ok
  )
  local observer = ::std.ObserverStruct update 0
)
```

| 引数      | 内容                            |
| --------- | ------------------------------- |
| `context` | `Context`プロパティに設定した値 |
| `params`  | 発生したイベントの補足情報      |
| `type:`   | 発生したイベントの名前          |

`ObserverStruct`の第二引数には、構造体メソッドの場合はその構造体のインスタンスを、通常の関数の場合は識別可能な任意の値を指定する。

### イベントハンドラの登録

```maxscript
-- 一般イベント
::systemEventHandler.Add #SelectionSetChanged observer
-- 時間変更
::systemEventHandler.Add #TimeChange observer
-- ビューポート再描画
::systemEventHandler.Add #ViewportRedraw observer
```

* 一般イベントのタイプはMAXScriptリファレンスを参照。

### イベントハンドラの登録解除

```maxscript
-- 一般イベント
::systemEventHandler.Remove #SelectionSetChanged observer
-- 時間変更
::systemEventHandler.Remove #TimeChange observer
-- ビューポート再描画
::systemEventHandler.Remove #ViewportRedraw observer
```

* `observer`は登録時と同じ値を使用する。

* 一般イベントのタイプはMAXScriptリファレンスを参照。

### 遅延実行

```maxscript
::systemEventHandler.Add #SelectionSetChanged observer delayInterval:100
```

最後にイベントが通知されてからコールバック関数を呼び出すまでの遅延時間をミリ秒で指定する。
遅延時間以内に同じイベントが通知された場合は時間をリセットして計測し直す。
これにより短い間隔で大量に発生した同一イベントの通知を一度にまとめることができる。
`0`（既定値）を指定した場合はこの遅延処理を行わない。

## ライセンス

[MIT License](https://github.com/imaoki/SystemEventHandler/blob/main/LICENSE)
