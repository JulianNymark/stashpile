require 'src/helper'
require 'src/unit'
require 'src/controls'
require 'src/viewport'

BLOCK_SIZE = 256
B_2 = BLOCK_SIZE / 2
CIRCLE_SEGMENTS = 10

ZOOM_SENSITIVITY = 0.05
ZOOM_POWER = 10
ZOOM_MAX = 2.0
ZOOM_MIN = 0.5

function love.load()

   -- images
   grass1 = gr.newImage('assets/img/ground/grass1.png')
   rock1 = gr.newImage('assets/img/ground/rock1.png')

   -- other data structs
   game_map = {
      { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
      { 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
      { 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1 },
      { 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1 },
      { 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1 },
      { 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
      { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
   }

   units = {}

   -- dynamic game variables
   pan = {0, 0}
   map_zoom  = {0.85, 0.85}
end

---------------------------

function love.update(dt)
   update_map(dt)
   update_units(dt)
end

function update_units(dt)
   for u=1, #units do
      units[u]:update(dt)
   end
end

function update_map(dt)
   if Mouse.pan_active then
      Viewport.pos = {pan[1] - Mouse.delta[1] * Viewport.zoom[1], pan[2] - Mouse.delta[2] * Viewport.zoom[2] }
   end
end

---------------------------

function love.draw()
   draw_map()
   draw_units()

end

function draw_units()
   for u=1, #units do
      units[u]:draw()
   end
end

function draw_map()
   gr.push()

   -- map zooming
   -- local mousepos = { ms.getPosition() }
   -- mousepos[1] = mousepos[1] / gr.getWidth() -- 0 -> 1
   -- mousepos[2] = mousepos[2] / gr.getHeight() -- 0 -> 1

   -- local offset_x = mousepos[1] * BLOCK_SIZE * #game_map[1]
   -- local offset_y = mousepos[2] * BLOCK_SIZE * #game_map
   -- local offset = { offset_x, offset_y }

   -- gr.translate(unpack( copy(offset) ))
   gr.scale(unpack( map( function(p) return math.pow(p, ZOOM_POWER) end, {0.82, 0.82}))) -- TODO: scale at mousepos

   -- gr.scale(unpack( map( function(p) return 1 / math.pow(p, ZOOM_POWER) end, copy(map_zoom))))

   -- gr.translate(unpack( map( function(p) return (p * -1) end, copy(offset))))

   -- -- map panning
   -- gr.translate(unpack( copy(map_pan) ))

   -- draw tiles
   gr.setColor(255, 255, 255)
   for y=1, #game_map do
      for x=1, #game_map[y] do
         if game_map[y][x] == 0 then
            gr.draw(grass1, (x - 1) * BLOCK_SIZE , (y - 1) * BLOCK_SIZE)
         end
         if game_map[y][x] == 1 then
            gr.draw(rock1, (x - 1) * BLOCK_SIZE, (y - 1) * BLOCK_SIZE)
         end
      end
   end

   draw_debug()

   gr.pop()
end

function draw_debug()
   --debug map
   gr.setColor(222, 0, 0)
   for y=1, #game_map do
      for x=1, #game_map[y] do
         gr.rectangle("line", (x - 1) * BLOCK_SIZE, (y - 1) * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)
         if game_map[y][x] == 0 then
            --gr.rectangle("line", x * BLOCK_SIZE, y * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)
         end
         if game_map[y][x] == 1 then
            --gr.draw(rock1, x * BLOCK_SIZE, y * BLOCK_SIZE)
         end
      end
   end

   -- map bounds
   gr.setColor(0, 255, 0)
   gr.rectangle("line", 0 * BLOCK_SIZE, 0 * BLOCK_SIZE, #game_map[1] * BLOCK_SIZE, #game_map * BLOCK_SIZE)

   -- draw viewport bounds
   gr.setColor(0, 255, 255)
   gr.rectangle("line", Viewport.getX(), Viewport.getY(), Viewport.getW(), Viewport.getH())

end

---------------------------
