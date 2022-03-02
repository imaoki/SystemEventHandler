/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  if GlobalVars.IsGlobal "systemEventHandler" do (
    ::systemEventHandler.Uninstall()
  )

  if isProperty ::startupScriptLoader "UnregisterScript" do (
    local registerFile = substituteString (getSourceFileName()) "unregister.ms" "register.ms"
    ::startupScriptLoader.UnregisterScript registerFile
    ::startupScriptLoader.Save()
  )
  ok
)
