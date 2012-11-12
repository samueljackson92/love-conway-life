Block = {}
BlockImages = {}
BlockImages[1] = love.graphics.newImage("images/white8.png")
BlockImages[2] = love.graphics.newImage("images/black8.png")
function Block:new()
	o = 
	{
		living = false,
		image = BlockImages[2],
		row = 1,
		coll = 1,
		x = 0,
		y = 0
	}

      setmetatable(o, self)
      self.__index = self
      return o
end

function Block:draw()
	love.graphics.draw(self.image, self.x, self.y)
end

function Block:setTableVal(coll, row)
	self.coll = coll
	self.row = row
	self.x = (coll - 1) * 8
	self.y = (row - 1) * 8
end

function Block:changeState()
	if self.living == false then
		self.living = true
		self.image = BlockImages[1]
	else
		self.living = false
		self.image = BlockImages[2]
	end
end

function Block:makeAlive()
	self.living = true
	self.image = BlockImages[1]
end

function Block:makeDead()
	self.living = false
	self.image = BlockImages[2]
end
