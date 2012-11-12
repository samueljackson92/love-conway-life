
require "block"

LifeMan = {}

function LifeMan:new()
	o = 
	{
		blocks = {},
		width = 100,
		height = 76,
		generation = 0
	}
    setmetatable(o, self)
    self.__index = self
    return o
end

function LifeMan:init()
	for coll = 1, self.width do
		self.blocks[coll] = {}
		for row = 1, self.height do
			self:newBlock(coll, row, 1)
		end
	end
end

function LifeMan:drawLife()
	for i,v in ipairs(self.blocks) do
		for j,w in ipairs(v) do
			w:draw()
		end
	end
end

function LifeMan:newBlock(coll, row)
	local newBlock = Block:new()
	newBlock:setTableVal(coll, row)
	self.blocks[coll][row] = newBlock
end

function LifeMan:makeLife(x,y,e)
	x = x - (x % 8)
	y = y - (y % 8)
	coll = (x / 8) + 1
	row = (y / 8) + 1
	local block = self.blocks[coll][row]
	if e == true then
		block:makeAlive()
	else
		block:makeDead()
	end
end

function LifeMan:tick()
local death = {}
local life ={}

	for i,v in ipairs(self.blocks) do
		for j,w in ipairs(v) do
			local coll = w.coll
			local row = w.row
			local liveCount = 0
			
			--build array of neighbours
			local nb = {}

			local nColl, nRow = checkPlausible(coll - 1, row - 1)
			nb[1] = self.blocks[nColl][nRow]
			local nColl, nRow = checkPlausible(coll, row - 1)
			nb[2] = self.blocks[nColl][nRow]
			local nColl, nRow = checkPlausible(coll + 1, row - 1)
			nb[3] = self.blocks[nColl][nRow]
			local nColl, nRow = checkPlausible(coll - 1, row)
			nb[4] = self.blocks[nColl][nRow]
			local nColl, nRow = checkPlausible(coll + 1, row)
			nb[5] = self.blocks[nColl][nRow]
			local nColl, nRow = checkPlausible(coll - 1, row + 1)
			nb[6] = self.blocks[nColl][nRow]
			local nColl, nRow = checkPlausible(coll, row + 1)
			nb[7] = self.blocks[nColl][nRow]
			local nColl, nRow = checkPlausible(coll + 1, row + 1)
			nb[8] = self.blocks[nColl][nRow]

			
			for p,q in ipairs(nb) do
				if q.living == true then
					liveCount = liveCount + 1
				end
			end
			
			if liveCount < 2 or liveCount > 3 then
				--mark for death
				table.insert(death, w)
			end
			if liveCount == 3 then
				--mark for life
				table.insert(life, w)
			end
		end
	end
	
	for i,v in ipairs(death) do
		v:makeDead()
	end
	for i,v in ipairs(life) do
		v:makeAlive()
	end
	
	self.generation = self.generation + 1
end

function checkPlausible (coll, row)
	if coll < 1 then
		coll = 100
	elseif coll > 100 then
		coll = 1
	end
				
	if row  < 1 then
		row = 76
	elseif row > 76 then
		row = 1
	end
				
	return coll, row
end
