Unit = {
   player = 0, -- 0 = npc, 1 = player 1, ...
   grid_x = 256,
   grid_y = 256,
   act_x = 200,
   act_y = 200,
   speed = 10
}

function Unit:new (obj)
   obj = obj or {}   -- create object if user does not provide one
   setmetatable(obj, self)
   self.__index = self
   return obj
end

function Unit:draw ()
   gr.setColor(0, 255, 0)
   gr.circle("fill", self.act_x + B_2, self.act_y + B_2, BLOCK_SIZE/2, CIRCLE_SEGMENTS)
end

function Unit:update (dt)
   self.act_y = self.act_y - ((self.act_y - self.grid_y) * self.speed * dt)
   self.act_x = self.act_x - ((self.act_x - self.grid_x) * self.speed * dt)
end
