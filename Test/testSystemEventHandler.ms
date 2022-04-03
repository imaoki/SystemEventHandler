/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  -- clearListener()

  local nowTime = (DotNetClass "System.DateTime").Now.ToString "HH:mm:ss"
  local sw = DotNetObject "System.Diagnostics.Stopwatch"

  local currentFile = getSourceFileName()
  local pathUtility = ::std.PathUtilityStruct currentFile

  local actual
  local expected
  local testDef
  local testObj

  format "[run %]@\"%\"\n" nowTime currentFile
  /* Setup Start ------------------------------------------------------------ */
  local n1 = Point Name:"TestPoint1"
  local n2 = Point Name:"TestPoint2"

  local nodeFreezeCount = 0
  local nodeNameSetCount = 0
  local timeChangeCount = 0
  local viewportRedrawCount = 0

  local expectedNodeFreezeParam = undefined
  local expectedNodeNameSetParam = undefined
  local expectedTimeChangeParam = undefined
  local expectedViewportRedrawParam = undefined

  local testNotification
  fn testNotification type param = (
    -- format "testNotification type:% param:%\n" type param
    case type of (
      (#NodeFreeze): (
        nodeFreezeCount += 1
        actual = ::TestValueStruct param
        expected = ::TestValueStruct expectedNodeFreezeParam
        assert (actual.Equals expected == true)

        if n2.IsFrozen do (
          /* Add */
          -- #NodeNameSet
          nodeNameSetCount = 0
          actual = ::TestValueStruct (testObj.Add #NodeNameSet testNotification delayInterval:100)
          expected = ::TestValueStruct true
          assert (actual.Equals expected == true)
          -- コールバック確認
          actual = ::TestValueStruct (testObj.GetRegisteredCallbackCount #NodeNameSet)
          expected = ::TestValueStruct 1
          assert (actual.Equals expected == true)
          -- 削除
          expectedNodeNameSetParam = #("TestPoint2", "TestPoint2.Renamed", n2)
          if isValidNode n1 do n1.Name = "TestPoint1.Renamed"
          if isValidNode n2 do n2.Name = "TestPoint2.Renamed"
        )
      )
      (#NodeNameSet): (
        nodeNameSetCount += 1
        actual = ::TestValueStruct param
        expected = ::TestValueStruct expectedNodeNameSetParam
        assert (actual.Equals expected == true)

        if n2.Name == "TestPoint2.Renamed" do (
          /* Add */
          -- #TimeChange
          timeChangeCount = 0
          ::sliderTime = 0f
          actual = ::TestValueStruct (testObj.Add #TimeChange testNotification delayInterval:100)
          expected = ::TestValueStruct true
          assert (actual.Equals expected == true)
          -- 現在時間を変更
          expectedTimeChangeParam = 10f
          ::sliderTime = 10f
        )
      )
      (#TimeChange): (
        timeChangeCount += 1
        actual = ::TestValueStruct param
        expected = ::TestValueStruct expectedTimeChangeParam
        assert (actual.Equals expected == true)

        if ::currentTime == 10f do (
          /* Add */
          -- #ViewportRedraw
          viewportRedrawCount = 0
          Viewport.SetTM (Matrix3 [0.707107, 0.353715, -0.612279] [-0.707107, 0.353715, -0.612279] [0, 0.865894, 0.500228] [0, 0, 0])
          actual = ::TestValueStruct (testObj.Add #ViewportRedraw testNotification delayInterval:10)
          expected = ::TestValueStruct true
          assert (actual.Equals expected == true)
          -- ビューポート変換行列を設定
          expectedViewportRedrawParam = undefined
          Viewport.SetTM (Matrix3 [1, 0, 0] [0, 1, 0] [0, 0, 1] [0, 0, 0])
        )
      )
      (#ViewportRedraw): (
        viewportRedrawCount += 1
        actual = ::TestValueStruct param
        expected = ::TestValueStruct expectedViewportRedrawParam
        assert (actual.Equals expected == true)

        /* イベント発生数確認 */
        -- #NodeFreeze
        actual = ::TestValueStruct nodeFreezeCount
        expected = ::TestValueStruct 1
        assert (actual.Equals expected == true)
        -- #NodeNameSet
        actual = ::TestValueStruct nodeNameSetCount
        expected = ::TestValueStruct 1
        assert (actual.Equals expected == true)
        -- #TimeChange
        actual = ::TestValueStruct timeChangeCount
        expected = ::TestValueStruct 1
        assert (actual.Equals expected == true)
        -- #ViewportRedraw
        actual = ::TestValueStruct viewportRedrawCount
        expected = ::TestValueStruct 1
        assert (actual.Equals expected == true)

        /* GetRegisteredCallbackCount */
        -- #NodeFreeze
        actual = ::TestValueStruct (testObj.GetRegisteredCallbackCount #NodeFreeze)
        expected = ::TestValueStruct 1
        assert (actual.Equals expected == true)
        -- #NodeNameSet
        actual = ::TestValueStruct (testObj.GetRegisteredCallbackCount #NodeNameSet)
        expected = ::TestValueStruct 1
        assert (actual.Equals expected == true)
        -- #TimeChange
        actual = ::TestValueStruct (testObj.GetRegisteredCallbackCount #TimeChange)
        expected = ::TestValueStruct 1
        assert (actual.Equals expected == true)
        -- #ViewportRedraw
        actual = ::TestValueStruct (testObj.GetRegisteredCallbackCount #ViewportRedraw)
        expected = ::TestValueStruct 1
        assert (actual.Equals expected == true)

        -- testObj.Dump()

        /* Remove */
        -- #NodeFreeze
        actual = ::TestValueStruct (testObj.Remove #NodeFreeze testNotification)
        expected = ::TestValueStruct true
        assert (actual.Equals expected == true)
        -- コールバック確認
        actual = ::TestValueStruct (testObj.GetRegisteredCallbackCount #NodeFreeze)
        expected = ::TestValueStruct 0
        assert (actual.Equals expected == true)
        -- #NodeNameSet
        actual = ::TestValueStruct (testObj.Remove #NodeNameSet testNotification)
        expected = ::TestValueStruct true
        assert (actual.Equals expected == true)
        -- コールバック確認
        actual = ::TestValueStruct (testObj.GetRegisteredCallbackCount #NodeNameSet)
        expected = ::TestValueStruct 0
        assert (actual.Equals expected == true)
        -- #TimeChange
        actual = ::TestValueStruct (testObj.Remove #TimeChange testNotification)
        expected = ::TestValueStruct true
        assert (actual.Equals expected == true)
        -- コールバック確認
        actual = ::TestValueStruct (testObj.GetRegisteredCallbackCount #TimeChange)
        expected = ::TestValueStruct 0
        assert (actual.Equals expected == true)
        -- #ViewportRedraw
        actual = ::TestValueStruct (testObj.Remove #ViewportRedraw testNotification)
        expected = ::TestValueStruct true
        assert (actual.Equals expected == true)
        -- コールバック確認
        actual = ::TestValueStruct (testObj.GetRegisteredCallbackCount #ViewportRedraw)
        expected = ::TestValueStruct 0
        assert (actual.Equals expected == true)

        /* Uninstall */
        actual = ::TestValueStruct (testObj.Uninstall())
        expected = ::TestValueStruct ok
        assert (actual.Equals expected == true)
        -- グローバル変数の存在を確認
        actual = ::TestValueStruct (GlobalVars.IsGlobal "systemEventHandler")
        expected = ::TestValueStruct true
        assert (actual.Equals expected == true)
        -- グローバル変数の値を確認
        actual = ::TestValueStruct (GlobalVars.Get "systemEventHandler")
        expected = ::TestValueStruct undefined
        assert (actual.Equals expected == true)

        /* Test End */
        sw.Stop()
        /* Teardown Start */
        -- ノード削除
        if isValidNode n1 do delete n1
        if isValidNode n2 do delete n2
        -- コールバック出力
        format "#GeneralEvent:%\n" (Callbacks.Show asArray:true id:#SystemEventHandler)
        format "#TimeChange:%\n" (showRegisteredTimeCallbacks asArray:true)
        format "#ViewportRedraw:%\n" (showRegisteredRedrawViewsCallbacks asArray:true)
        /* Teardown End */
        format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
      )
      default: ()
    )
    ok
  )

  testDef = fileIn (pathUtility.GetFullPath @"..\SystemEventHandler.ms")
  testObj = testDef()
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  -- グローバル変数の存在を確認
  actual = ::TestValueStruct (GlobalVars.IsGlobal "systemEventHandler")
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- グローバル変数の値を確認
  actual = ::TestValueStruct (GlobalVars.Get "systemEventHandler")
  expected = ::TestValueStruct testObj
  assert (actual.Equals expected == true)

  /* InvokeGeneralEvent */

  /* InvokeTimeChange */

  /* InvokeViewportRedraw */

  /* GetRegisteredCallbackCount */
  -- #NodeFreeze
  actual = ::TestValueStruct (testObj.GetRegisteredCallbackCount #NodeFreeze)
  expected = ::TestValueStruct 0
  assert (actual.Equals expected == true)
  -- #NodeNameSet
  actual = ::TestValueStruct (testObj.GetRegisteredCallbackCount #NodeNameSet)
  expected = ::TestValueStruct 0
  assert (actual.Equals expected == true)
  -- #TimeChange
  actual = ::TestValueStruct (testObj.GetRegisteredCallbackCount #TimeChange)
  expected = ::TestValueStruct 0
  assert (actual.Equals expected == true)
  -- #ViewportRedraw
  actual = ::TestValueStruct (testObj.GetRegisteredCallbackCount #ViewportRedraw)
  expected = ::TestValueStruct 0
  assert (actual.Equals expected == true)

  /* Add */
  -- #NodeFreeze
  nodeFreezeCount = 0
  actual = ::TestValueStruct (testObj.Add #NodeFreeze testNotification delayInterval:100)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- コールバック確認
  actual = ::TestValueStruct (testObj.GetRegisteredCallbackCount #NodeFreeze)
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)
  -- 選択
  expectedNodeFreezeParam = n2
  if isValidNode n1 do freeze n1
  if isValidNode n2 do freeze n2
  -- /* Test End --------------------------------------------------------------- */
  -- sw.Stop()
  -- /* Teardown Start --------------------------------------------------------- */
  -- if isValidNode n1 do delete n1
  -- if isValidNode n2 do delete n2
  -- /* Teardown End ----------------------------------------------------------- */
  -- format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
