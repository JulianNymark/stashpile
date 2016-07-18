require 'src/helper'
require 'src/unit'
require 'src/controls'
require 'src/viewport'
require 'src/world'

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

   World.load()

   -- insert an NPC test unit (player = 0 )
   units = {}
   table.insert(units, Unit:new())
   u1 = units[1]

   -----------------------
   -- AI
   -----------------------
   --unit_set_timer_event(units[1])
   unit_set_new_destination(units[1])

   -- dynamic game variables
   pan = {0, 0}
   map_zoom  = {0.85, 0.85}

end

---------------------------

function love.update(dt)
   World.update(dt)
   Viewport.update(dt)
   Mouse.update(dt)
end

---------------------------
---------------------------

function love.draw()
   World.draw()
   -- Gui.draw()
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

function unit_set_new_destination( unit )

   local function unit_has_reached_destination( unit )
      if unit.act_x - ( unit.grid_x - 1 ) * BLOCK_SIZE <= BLOCK_SIZE/50 and
         unit.act_y - ( unit.grid_y - 1 ) * BLOCK_SIZE <= BLOCK_SIZE/50
      then
         return true
      end
      return false
   end

   local function unit_reached_destination( unit )
      print('unit reached destination!')
      -- unit will set new destination asap on reaching dest

      -- set new destination
      local rand_x = 2 - math.random(3)
      local rand_y = 2 - math.random(3)
      local want_move_x = unit.grid_x + rand_x
      local want_move_y = unit.grid_y + rand_y

      if game_map[want_move_y][want_move_x] == 0 then
         unit.grid_x = want_move_x
         unit.grid_y = want_move_y
      end

      -- register a new eventlistener (for this very same event!)
      unit_set_new_destination(unit)
   end

   local event = {
      cond=unit_has_reached_destination, -- what condition
      fun=unit_reached_destination, -- what to do
   }
   table.insert(unit.events, event)
end

function unit_set_timer_event( unit )
   -- give test unit some timer event AI logic
   local function decide_on_random_destination( unit )
      -- set destination
      local rand_x = 2 - math.random(3)
      local rand_y = 2 - math.random(3)
      local want_move_x = unit.grid_x + rand_x
      local want_move_y = unit.grid_y + rand_y

      if game_map[want_move_y][want_move_x] == 0 then
         unit.grid_x = want_move_x
         unit.grid_y = want_move_y
      end
   end

   local timerevent = {
      every=5, -- when to fire
      count=0, -- how often it should trigger
      uptime=0, -- accumulate time (don't set to other than 0 :p )
      triggered=0, -- how many times has it currently been triggered ( don't change :p )
      fun=decide_on_random_destination, -- what to do
   }
   table.insert(unit.timers, timerevent)
end
