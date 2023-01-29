local cel = app.activeCel
if not cel then
  return app.alert("There is no active image")
end

local dlg = Dialog("Export slices")
dlg:label{
  id = "msg",
  text = "Please Ensure you are in the indexed collor mode and that the first index is the mask!"
}
dlg:file{
    id = "directory",
    label = "Output directory:",
    filename = "untitled",
    fileTypes = ".png",
    focus = true
}
dlg:button{id = "ok", text = "Export"}
dlg:button{id = "cancel", text = "Cancel"}
dlg:show()

if not dlg.data.ok then return 0 end

app.command.ChangePixelFormat{ format="indexed", dithering="none" } -- undoccumented command to change image to indexed

-- Get path and filename
local output_path = dlg.data.directory

local numberOfColors = #app.activeSprite.palettes[1]
for i=1,numberOfColors-1 do 
  local img = cel.image:clone() -- clone the image so we can delete part of the palette for export without destroying the orginional
  if numberOfColors > 2 then
    local mask = img.spec.transparentColor
    for it in img:pixels() do
      if it() ~= i then -- delete all colors that we are not using right now
        it(mask)
      end
    end
  end
  -- add index to filename
  if string.find(output_path, ".png") then
    output_pathx = output_path:gsub("[.]", i..".")
  else 
    output_pathx = output_path .. i .. ".png"
  end
  img:saveAs(output_pathx)
end

return 0