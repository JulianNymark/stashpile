Mouse = {
   delta = {0, 0},
   pan_active = false,
   -- startPos = {0, 0},
}

function love.keypressed(key)
   if key == 'escape' then
      ev.push('quit')
   end
end

-- mouse detect square, zoom levels, scroll zoom, pan map
function love.mousepressed( x, y, button, istouch )
   if button == 2 then
      Mouse.pan_active = true
      Mouse.startPos = {x, y}
      Mouse.delta = {0, 0}

      pan = copy(Viewport.pos)
   end
end

function love.mousereleased( x, y, button, istouch )
   if button == 2 then
      -- store current pan value
      pan = Viewport.pos

      Mouse.pan_active = false
   end
end

function love.mousemoved( x, y, dx, dy, istouch )
   if Mouse.pan_active then
      local currPos = {ms.getPosition()}
      Mouse.delta = {currPos[1] - Mouse.startPos[1], currPos[2] - Mouse.startPos[2]} -- TODO: vectors
   end
end

function love.wheelmoved(x, y)
   if y == -1 then
      if Viewport.zoom[1] >= ZOOM_MAX then
         return
      end
   end

   if y == 1 then
      if Viewport.zoom[1] <= ZOOM_MIN then
         return
      end
   end

   -- zoom @ mouse (translation)
   local mousepos = { ms.getPosition() }
   mousepos[1] = mousepos[1] / gr.getWidth() -- 0 -> 1
   mousepos[2] = mousepos[2] / gr.getHeight() -- 0 -> 1

   mp_center_offset = copy(mousepos)
   mp_center_offset[1] = (mp_center_offset[1] - 0.5) * 2
   mp_center_offset[2] = (mp_center_offset[2] - 0.5) * 2

   print(mp_center_offset[1], mp_center_offset[2])

   Viewport.pos[1] = Viewport.pos[1] + ((1 / ZOOM_SENSITIVITY) * mp_center_offset[1] * y)
   Viewport.pos[2] = Viewport.pos[2] + ((1 / ZOOM_SENSITIVITY) * mp_center_offset[2] * y)

   -- actual zooming (scaling)
   Viewport.zoom[1] = Viewport.zoom[1] - y * ZOOM_SENSITIVITY
   Viewport.zoom[2] = Viewport.zoom[2] - y * ZOOM_SENSITIVITY
end

--- TODO: FEATURES
-- click select
-- rectangle select
