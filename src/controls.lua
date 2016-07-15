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

      old_pan = copy(map_pan)
   end
end

function love.mousereleased( x, y, button, istouch )
   if button == 2 then
      -- store current pan value
      old_pan = map_pan

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
   if y == 1 then
      if map_zoom[1] >= ZOOM_MAX then
         return
      end
   end

   if y == -1 then
      if map_zoom[1] <= ZOOM_MIN then
         return
      end
   end

   map_zoom[1] = map_zoom[1] + y * ZOOM_SENSITIVITY
   map_zoom[2] = map_zoom[2] + y * ZOOM_SENSITIVITY
end

-- rectangle select
