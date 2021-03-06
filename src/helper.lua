gr = love.graphics
ev = love.event
ms = love.mouse
wn = love.window

function deepcopy(orig)
   local orig_type = type(orig)
   local copy
   if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in next, orig, nil do
         copy[deepcopy(orig_key)] = deepcopy(orig_value)
      end
      setmetatable(copy, deepcopy(getmetatable(orig)))
   else -- number, string, boolean, etc
      copy = orig
   end
   return copy
end

copy = deepcopy

function map(f, t)
   local t2 = {}
   for k,v in pairs(t) do t2[k] = f(v) end
   return t2
end
