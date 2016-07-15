require 'src/helper'
require 'src/unit'
require 'src/controls'

BLOCK_SIZE = 256
B_2 = BLOCK_SIZE / 2
CIRCLE_SEGMENTS = 10
ZOOM_SENSITIVITY = 0.005
ZOOM_MAX = 1
ZOOM_MIN = 0.83

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
   old_pan = {0, 0}
   map_pan = {0, 0}
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
      map_pan = {old_pan[1] + Mouse.delta[1], old_pan[2] + Mouse.delta[2]}
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

   gr.translate(unpack(map_pan))
   gr.scale(unpack( map(function(p) return math.pow(p, 10) end, map_zoom))) -- TODO: scale at mousepos

   gr.setColor(255, 255, 255)
   for y=1, #game_map do
      for x=1, #game_map[y] do
         if game_map[y][x] == 0 then
            gr.draw(grass1, x * BLOCK_SIZE, y * BLOCK_SIZE)
         end
         if game_map[y][x] == 1 then
            gr.draw(rock1, x * BLOCK_SIZE, y * BLOCK_SIZE)
         end
      end
   end
   gr.pop()
end

---------------------------
