/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  if GlobalVars.IsGlobal "systemEventHandler" do (
    ::systemEventHandler.Uninstall()
  )

  if isProperty ::startupLoader "UnregisterFile" do (
    local registerFile = substituteString (getSourceFileName()) "unregister.ms" "register.ms"
    ::startupLoader.UnregisterFile registerFile
  )
  ok
)
