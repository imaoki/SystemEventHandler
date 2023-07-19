# SystemEventHandler

<!-- [![GitHub release (latest by date)](https://img.shields.io/github/v/release/imaoki/SystemEventHandler)](https://github.com/imaoki/SystemEventHandler/releases/latest) -->
[![GitHub](https://img.shields.io/github/license/imaoki/SystemEventHandler)](https://github.com/imaoki/SystemEventHandler/blob/main/LICENSE)

コールバックの処理を一本化するための仕組みを提供する。
<!-- Provide a mechanism to unify callback processing. -->

## 特徴
<!-- ## Features -->

* 一般イベントコールバック、時間変更コールバック、ビューポート再描画コールバックに対応。
  <!-- * Supports general event callback, time change callback, and viewport redraw callback. -->

* コールバックの遅延実行。
  <!-- * Delayed callback execution. -->

## ライセンス
<!-- ## License -->

[MIT License](https://github.com/imaoki/SystemEventHandler/blob/main/LICENSE)

## 要件
<!-- ## Requirements -->

* [imaoki/Standard](https://github.com/imaoki/Standard)

## 開発環境
<!-- ## Development Environment -->

`3ds Max 2024`

## インストール
<!-- ## Install -->

01. 依存スクリプトは予めインストールしておく。
    <!-- 01. Dependent scripts should be installed beforehand. -->

02. `install.ms`を実行する。
    <!-- 02. Execute `install.ms`. -->

## アンインストール
<!-- ## Uninstall -->

`uninstall.ms`を実行する。
<!-- Execute `uninstall.ms`. -->

## 単一ファイル版
<!-- ## Single File Version -->

### インストール
<!-- ### Install -->

01. 依存スクリプトは予めインストールしておく。
    <!-- 01. Dependent scripts should be installed beforehand. -->

02. `Distribution\SystemEventHandler.min.ms`を実行する。
    <!-- 02. Execute `Distribution\SystemEventHandler.min.ms`. -->

### アンインストール
<!-- ### Uninstall -->

```maxscript
::systemEventHandler.Uninstall()
```

## 使い方
<!-- ## Usage -->

### イベントハンドラの作成
<!-- ### Create Event Handler -->

[`ObservableStruct`](https://imaoki.github.io/mxskb/mxsdoc/standard-observable.html)を使用してイベントハンドラを作成する。
<!-- Create event handler using [`ObservableStruct`](https://imaoki.github.io/mxskb/mxsdoc/standard-observable.html). -->

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
<!-- ### Register Event Handler -->

```maxscript
-- 一般イベントコールバック
::systemEventHandler.Add #SelectionSetChanged observer

-- 時間変更コールバック
::systemEventHandler.Add #TimeChange observer

-- ビューポート再描画コールバック
::systemEventHandler.Add #ViewportRedraw observer
```

* 一般イベントのタイプはMAXScriptリファレンスを参照。
  <!-- * See MAXScript Reference for general event types. -->

### イベントハンドラの登録解除
<!-- ### Unregister Event Handler -->

```maxscript
-- 一般イベントコールバック
::systemEventHandler.Remove #SelectionSetChanged observer

-- 時間変更コールバック
::systemEventHandler.Remove #TimeChange observer

-- ビューポート再描画コールバック
::systemEventHandler.Remove #ViewportRedraw observer
```

* `observer`は登録時と同じ値を使用する。
  <!-- * Use the same value for `observer` as when registering. -->

* 一般イベントのタイプはMAXScriptリファレンスを参照。
  <!-- * See MAXScript Reference for general event types. -->

### 遅延実行
<!-- ### Delayed Execution -->

```maxscript
::systemEventHandler.Add #SelectionSetChanged observer delayInterval:100
```

* 最後にイベントが通知されてからコールバック関数を呼び出すまでの遅延時間をミリ秒で指定する。
  <!-- * Specify the delay in milliseconds between the last event notification and the callback function call. -->

* 遅延時間以内に同じイベントが通知された場合は時間をリセットして計測し直す。
  <!-- * If the same event is notified within the delay time, the time is reset and measured again. -->

* `0`（既定値）を指定した場合はこの遅延処理を行わない。
  <!-- * If `0` (default) is specified, this delay processing is not performed. -->
