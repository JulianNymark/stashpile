Unit = {
   player = 0, -- 0 = npc, 1 = player 1, ...
   grid_x = 10,
   grid_y = 10,
   speed = 10,
   size = 0.5,
   uptime = 0,
   timers = {},
}

function Unit:new (obj)
   obj = obj or {}   -- create object if user does not provide one
   setmetatable(obj, self)
   self.__index = self

   -- initial actual location
   self.act_x = (self.grid_x - 1) * BLOCK_SIZE
   self.act_y = (self.grid_y - 1) * BLOCK_SIZE

   return obj
end

function Unit:draw ()
   if self.player == 0 then
      gr.setColor(222, 222, 222)
   elseif self.player == 1 then
      gr.setColor(0, 255, 0)
   end
   gr.circle("fill", self.act_x + B_2, self.act_y + B_2, self.size * BLOCK_SIZE/2, CIRCLE_SEGMENTS)
   gr.setColor(0,0,0)
   gr.setLineWidth(2)
   gr.circle("line", self.act_x + B_2, self.act_y + B_2, self.size * BLOCK_SIZE/2, CIRCLE_SEGMENTS)
   gr.setLineWidth(1)
end

function Unit:update (dt)
   self.uptime = self.uptime + dt

   -- update timers (events)
   for t=1, #self.timers do
      local the_t = self.timers[t]
      the_t.uptime = the_t.uptime + dt
      if the_t.uptime >= the_t.every * the_t.triggered then
         the_t.triggered = the_t.triggered + 1
         the_t.fun( self )
      end
   end

   -- move
   self.act_y = self.act_y - ((self.act_y - ( self.grid_y - 1 ) * BLOCK_SIZE) * self.speed * dt)
   self.act_x = self.act_x - ((self.act_x - ( self.grid_x - 1 ) * BLOCK_SIZE) * self.speed * dt)
end
