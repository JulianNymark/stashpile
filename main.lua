require 'src/helper'
require 'src/unit'
require 'src/controls'
require 'src/viewport'

BLOCK_SIZE = 256
B_2 = BLOCK_SIZE / 2
CIRCLE_SEGMENTS = 10

ZOOM_SENSITIVITY = 0.25
ZOOM_POWER = 2
ZOOM_MAX = 8.0
ZOOM_MIN = 1.0

function love.load()

   wn.setMode( 1920, 1080, {} )
   --ms.setVisible(false)

   -- images
   grass1 = gr.newImage('assets/img/ground/grass1.png')
   rock1 = gr.newImage('assets/img/ground/rock1.png')

   -- other data structs
   game_map = {
      { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
      { 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
      { 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
      { 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
      { 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
      { 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1 },
      { 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
      { 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
      { 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
      { 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
      { 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
      { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
      { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
      { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
   }

   -- insert an NPC test unit (player = 0 )
   units = {}
   table.insert(units, Unit:new())

   -----------------------
   -- AI
   -----------------------
   -- give test unit some timer event AI logic
   u1 = units[1]
   local function decide_on_random_destination( unit )
      -- set destination
      local rand_x = 2 - math.random(3)
      local rand_y = 2 - math.random(3)
      unit.grid_x = unit.grid_x + rand_x
      unit.grid_y = unit.grid_y + rand_y
      print(rand_x, rand_y)
   end

   local timerevent = {
      every=1, -- when to fire
      count=0, -- how often it should trigger
      uptime=0, -- accumulate time (don't set to other than 0 :p )
      triggered=0, -- how many times has it currently been triggered ( don't change :p )
      fun=decide_on_random_destination, -- what to do
   }
   table.insert(u1.timers, timerevent)


   -- dynamic game variables
   pan = {0, 0}
   map_zoom  = {0.85, 0.85}

end

---------------------------

function love.update(dt)
   update_map(dt)
   update_units(dt)

   Viewport.update(dt)
   Mouse.update(dt)
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
   gr.push()

   -- zoom
   gr.scale(unpack( map( function(p) return 1/p end, Viewport.zoom)))

   -- pan
   local pos = { Viewport.getX(), Viewport.getY() }
   gr.translate(unpack( map( function(p) return (p * -1) end, pos)))

   -- draw 'world'
   draw_map()
   draw_units()

   gr.pop()
end

function draw_units()
   for u=1, #units do
      units[u]:draw()
   end
end

function draw_map()
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
end

function draw_debug()
   --debug map
   gr.setColor(222, 222, 222)
   for y=1, #game_map do
      for x=1, #game_map[y] do
         local rx, ry, rx2, ry2
         rx = (x - 1) * BLOCK_SIZE
         ry =(y - 1) * BLOCK_SIZE
         rx2 = rx + BLOCK_SIZE
         ry2 = ry + BLOCK_SIZE

         if is_point_inside_rect( Mouse.world_coord, { rx, ry, rx2, ry2 } ) then
            gr.rectangle("line", rx, ry, BLOCK_SIZE, BLOCK_SIZE)
         end
      end
   end

   -- map bounds
   gr.setColor(0, 255, 0)
   gr.rectangle("line", 0 * BLOCK_SIZE, 0 * BLOCK_SIZE, #game_map[1] * BLOCK_SIZE, #game_map * BLOCK_SIZE)

   -- draw viewport bounds
   gr.setColor(0, 255, 255)
   gr.rectangle("line", Viewport.getX(), Viewport.getY(), Viewport.getW(), Viewport.getH())

   debug_draw_mouse_target()
end

function debug_draw_mouse_target()
  gr.setColor(255, 255, 255)
  gr.circle(
     "line",
     Mouse.world_coord[1],
     Mouse.world_coord[2],
     10,
     CIRCLE_SEGMENTS)
end

---------------------------

function is_point_inside_rect( point, rect )
   if ( point[1] < rect[1] ) or
      ( point[1] > rect[3] ) or
      ( point[2] < rect[2] ) or
      ( point[2] > rect[4] )
   then
      return false
   end
   return true
end
