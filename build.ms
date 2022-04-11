/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  /* 初期化 */
  local mp = ::MxsPackStruct (getSourceFileName())
  /* 出力先ディレクトリ削除 */
  -- mp.DeleteDirectory @".\Distribution"

  /* コード切り出し */
  local SystemEventHandlerCode = mp.ClipFile @".\SystemEventHandler.ms" 1 -1

  /* コード置換 */
  local code = SystemEventHandlerCode

  /* インストールコード追加 */
  code = mp.AppendText code "::SystemEventHandlerStruct.Install()\n::SystemEventHandlerStruct\n"
  /* インストーラーオプション削除 */
  code = mp.RemoveInstallerOption code
  /* バンドルファイルを保存 */
  -- mp.WriteAllText @".\Distribution\SystemEventHandler.bundle.ms" code
  /* 最小化ファイルを保存 */
  code = mp.Minify code
  mp.WriteAllText @".\Distribution\SystemEventHandler.min.ms" code
  /* ファイルコピー */
  -- mp.CopyDirectory @".\SystemEventHandler.SubDir" @".\Distribution\SystemEventHandler.SubDir"
  ok
)
