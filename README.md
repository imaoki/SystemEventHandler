# SystemEventHandler

<!-- [![GitHub release (latest by date)](https://img.shields.io/github/v/release/imaoki/SystemEventHandler)](https://github.com/imaoki/SystemEventHandler/releases/latest) -->
[![GitHub](https://img.shields.io/github/license/imaoki/SystemEventHandler)](https://github.com/imaoki/SystemEventHandler/blob/main/LICENSE)

Provide a mechanism to unify callback processing.
<!-- コールバックの処理を一本化するための仕組みを提供する。 -->

## Features
<!-- 特徴 -->

* Supports general event callback, time change callback, and viewport redraw callback.
  <!-- 一般イベントコールバック、時間変更コールバック、ビューポート再描画コールバックに対応。 -->

* Delayed callback execution.
  <!-- コールバックの遅延実行。 -->

## Requirements
<!-- 要件 -->

* [imaoki/Standard](https://github.com/imaoki/Standard)

## Development Environment
<!-- 開発環境 -->

`3ds Max 2022.3 Update`

## Install
<!-- インストールする -->

01. Dependent scripts should be installed beforehand.
    <!-- 依存スクリプトは予めインストールしておく。 -->

02. Execute `install.ms`.
    <!-- `install.ms`を実行する。 -->

## Uninstall
<!-- アンインストールする -->

Execute `uninstall.ms`.
<!-- `uninstall.ms`を実行する。 -->

## Standalone version
<!-- スタンドアローン版 -->

### Install
<!-- インストールする -->

01. Dependent scripts should be installed beforehand.
    <!-- 依存スクリプトは予めインストールしておく。 -->

02. Execute `Distribution\SystemEventHandler.min.ms`.
    <!-- `Distribution\SystemEventHandler.min.ms`を実行する。 -->

### Uninstall
<!-- アンインストールする -->

```maxscript
::systemEventHandler.Uninstall()
```

## Usage
<!-- 使い方 -->

### Create Event Handler
<!-- イベントハンドラの作成 -->

Create event handler using [`ObserverStruct`](https://imaoki.github.io/mxskb/mxsdoc/standard-observer.html).
<!-- [`ObserverStruct`](https://imaoki.github.io/mxskb/mxsdoc/standard-observer.html)を使用してイベントハンドラを作成する。 -->

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

| Argument | Content    |
| -------- | ---------- |
| `type`   | Event Name |
| `param`  | Event Data |
<!-- イベント名 -->
<!-- イベントデータ -->

### Register Event Handler
<!-- イベントハンドラの登録 -->

```maxscript
-- General Event Callback
::systemEventHandler.Add #SelectionSetChanged observer

-- Time Change Callback
::systemEventHandler.Add #TimeChange observer

-- Viewport Redraw Callback
::systemEventHandler.Add #ViewportRedraw observer
```

* See MAXScript Reference for general event types.
  <!-- 一般イベントのタイプはMAXScriptリファレンスを参照。 -->

### Unregister Event Handler
<!-- イベントハンドラの登録解除 -->

```maxscript
-- General Event Callback
::systemEventHandler.Remove #SelectionSetChanged observer

-- Time Change Callback
::systemEventHandler.Remove #TimeChange observer

-- Viewport Redraw Callback
::systemEventHandler.Remove #ViewportRedraw observer
```

* Use the same value for `observer` as when registering.
  <!-- `observer`は登録時と同じ値を使用する。 -->

* See MAXScript Reference for general event types.
  <!-- 一般イベントのタイプはMAXScriptリファレンスを参照。 -->

### Delayed Execution
<!-- 遅延実行 -->

```maxscript
::systemEventHandler.Add #SelectionSetChanged observer delayInterval:100
```

* Specify the delay in milliseconds between the last event notification and the callback function call.
  <!-- 最後にイベントが通知されてからコールバック関数を呼び出すまでの遅延時間をミリ秒で指定する。 -->

* If the same event is notified within the delay time, the time is reset and measured again.
  <!-- 遅延時間以内に同じイベントが通知された場合は時間をリセットして計測し直す。 -->

* If `0` (default) is specified, this delay processing is not performed.
  <!-- `0`（既定値）を指定した場合はこの遅延処理を行わない。 -->

## License
<!-- ライセンス -->

[MIT License](https://github.com/imaoki/SystemEventHandler/blob/main/LICENSE)
