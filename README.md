# SystemEventHandler

<!-- [![GitHub release (latest by date)](https://img.shields.io/github/v/release/imaoki/SystemEventHandler)](https://github.com/imaoki/SystemEventHandler/releases/latest) -->
[![GitHub](https://img.shields.io/github/license/imaoki/SystemEventHandler)](https://github.com/imaoki/SystemEventHandler/blob/main/LICENSE)

コールバックの処理を一本化するための仕組みを提供する。

## 特徴

* 一般イベントコールバック、時間変更コールバック、ビューポート再描画コールバックに対応。

* コールバックの遅延実行。

## ライセンス

[MIT License](https://github.com/imaoki/SystemEventHandler/blob/main/LICENSE)

## 要件

* [imaoki/Standard](https://github.com/imaoki/Standard)

* （任意）[imaoki/StartupLoader](https://github.com/imaoki/StartupLoader)
  導入済みの場合はインストール/アンインストールでスタートアップスクリプトの登録/解除が行われる。
  未使用の場合はスクリプトの評価のみ行われる。

## 開発環境

`3ds Max 2024`

## インストール

01. 依存スクリプトは予めインストールしておく。

02. `install.ms`を実行する。

## アンインストール

`uninstall.ms`を実行する。

## 単一ファイル版

### インストール

01. 依存スクリプトは予めインストールしておく。

02. `Distribution\SystemEventHandler.min.ms`を実行する。

### アンインストール

```maxscript
::systemEventHandler.Uninstall()
```

## 使い方

### イベントハンドラの作成

[`ObservableStruct`](https://imaoki.github.io/mxskb/mxsdoc/standard-observable.html)を使用してイベントハンドラを作成する。

```maxscript
(
  fn update type param = (
    case type of (
      (#SelectionSetChanged): ()
      (#TimeChange): ()
      (#ViewportRedraw): ()
      default: ()
    )
    ok
  )
  local observer = ::std.ObserverStruct update
)
```

| 引数    | 内容       |
| ------- | ---------- |
| `type`  | 通知名     |
| `param` | 通知データ |

### イベントハンドラの登録

```maxscript
-- 一般イベントコールバック
::systemEventHandler.Add #SelectionSetChanged observer

-- 時間変更コールバック
::systemEventHandler.Add #TimeChange observer

-- ビューポート再描画コールバック
::systemEventHandler.Add #ViewportRedraw observer
```

* 一般イベントのタイプはMAXScriptリファレンスを参照。

### イベントハンドラの登録解除

```maxscript
-- 一般イベントコールバック
::systemEventHandler.Remove #SelectionSetChanged observer

-- 時間変更コールバック
::systemEventHandler.Remove #TimeChange observer

-- ビューポート再描画コールバック
::systemEventHandler.Remove #ViewportRedraw observer
```

* `observer`は登録時と同じ値を使用する。

* 一般イベントのタイプはMAXScriptリファレンスを参照。

### 遅延実行

```maxscript
::systemEventHandler.Add #SelectionSetChanged observer delayInterval:100
```

* 最後にイベントが通知されてからコールバック関数を呼び出すまでの遅延時間をミリ秒で指定する。

* 遅延時間以内に同じイベントが通知された場合は時間をリセットして計測し直す。

* `0`（既定値）を指定した場合はこの遅延処理を行わない。
