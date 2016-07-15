Viewport = {
   pos = {0, 0},
   dim = { gr.getWidth(), gr.getHeight() },
   zoom = {1, 1}
}

function Viewport.getX()
   return Viewport.pos[1] - (Viewport.getW()/2)
end

function Viewport.getY()
   return Viewport.pos[2] - (Viewport.getH()/2)
end

function Viewport.getW()
   return Viewport.dim[1] * Viewport.zoom[1]
end

function Viewport.getH()
   return Viewport.dim[2] * Viewport.zoom[2]
end
