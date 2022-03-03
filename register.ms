/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  fileIn "SystemEventHandler.ms"

  if isProperty ::startupLoader "RegisterFile" do (
    ::startupLoader.RegisterFile (getSourceFileName())
  )
  ok
)
