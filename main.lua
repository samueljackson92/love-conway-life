--Created by Samuel Jackson
--Built with LOVE version 0.6.x
require "lifemanager"

Game = {}
Game.width = 800
Game.height = 658
Game.speed = 0.5
Game.running = false
Game.drawmode = true
Game.drawingOff = false
Game.showHelp = false

tickTmr = 0

function love.load()
	love.graphics.setCaption("Conway's Game Of Life")
	love.graphics.setBackgroundColor(0, 0, 0)
	love.graphics.setMode(Game.width, Game.height, false, true, 0)
	love.graphics.setColorMode("replace")
	
	LifeManager = LifeMan:new()
	LifeManager:init()
end

function love.update(dt)
	if Game.showHelp ~= true then
		if Game.running == false and Game.drawingOff == false then
			if love.mouse.isDown("l") then
				local x,y = love.mouse.getPosition()
				LifeManager:makeLife(x,y, Game.drawmode)
			end
		end
		if Game.running == true then
			tickTmr = tickTmr + dt
			if tickTmr >= Game.speed then
				LifeManager:tick()
				tickTmr = 0
			end
		end
	end
end

function love.draw()
	LifeManager:drawLife()
	drawHUD()
	if Game.showHelp == true then
		drawHelp()
	end
end

function love.keypressed(e)
	
	--Reset game completely
	if e == "f1" then
		Game.running = false
		Game.drawingOff = false
		LifeManager.generation = 0
		for i,v in ipairs(LifeManager.blocks) do
			for j,w in ipairs(v) do
				w:makeDead()
			end
		end
	end
	
	--toggle drawing mode
	if e == "f2" then
		if Game.drawmode == true then
			Game.drawmode = false
		else
			Game.drawmode = true
		end
	end
	
	if e == "f3" then
		if Game.speed > 0.1 then
			Game.speed = Game.speed - 0.1
		end
	end
	
	if e == "f4" then
		if Game.speed < 1.5 then
			Game.speed = Game.speed + 0.1
		end
	end
	
	--run simulation
	if e == "f5" then
		Game.running = true
		Game.drawingOff = true
	end
	
	--stepforward
	if e == "f6" then
		Game.drawingOff = true
		Game.running = false
		LifeManager:tick()
	end
	
	if e == "f10" then
		if Game.showHelp == false then
			Game.showHelp = true
		else
			Game.showHelp = false
		end
	end
	
	--quit game
	if e == "escape" then
		love.event.push("q")
	end
end

--disable Love modules that are not required by the game
function love.conf(t)
    t.modules.joystick = false
    t.modules.physics = false
end

------------------------------------------------------
------------------------------------------------------

function drawHUD()
	love.graphics.setColor(30, 30, 30)
	love.graphics.rectangle("fill", 0, 608, 800, 50)
	love.graphics.printf("Generation: " .. LifeManager.generation, 10, 630, 300, "left" )
		if Game.speed < 0.1 then
			Game.speed = 0.1
		end
	love.graphics.printf("Speed: " .. Game.speed, 10, 650, 300, "left" )
	
	love.graphics.printf("Press F10 for rules and help", 480, 630, 300, "right" )
end

function drawHelp()
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, 0, 800, 658)
	
	love.graphics.setFont( 20 )
	love.graphics.printf("Help Dialogue", 150, 150, 300, "left" )
	love.graphics.printf("--------------------------------------------", 150, 170, 300, "left" )
	love.graphics.setFont( 14 )
	love.graphics.printf("Controls:", 150, 190, 300, "left" )
	love.graphics.printf("--------------------------------------------", 150, 200, 300, "left" )
	love.graphics.printf("F1 --- Reset Game", 150, 220, 300, "left" )
	love.graphics.printf("F2 --- Toggle Drawing Mode (Draw Cells/Erase Cells)", 150, 240, 500, "left" )
	love.graphics.printf("F3 --- Decrease Game Speed", 150, 260, 300, "left" )
	love.graphics.printf("F4 --- Increase Game Speed", 150, 280, 300, "left" )
	love.graphics.printf("F5 --- Run Simulation", 150, 300, 300, "left" )
	love.graphics.printf("F6 --- Step Through Simulation/Pause", 150, 320, 300, "left" )
	love.graphics.printf("F10 --- Show This Screen", 150, 340, 300, "left" )
	love.graphics.printf("Esc --- Close Game", 150, 360, 300, "left" )
	
	love.graphics.printf("Rules:", 150, 390, 300, "left" )
	love.graphics.printf("--------------------------------------------", 150, 410, 300, "left" )
	love.graphics.printf("1) Any live cell with fewer than two live neighbours dies, as if caused by under-population.", 150, 430, 600, "left" )
	love.graphics.printf("2) Any live cell with two or three live neighbours lives on to the next generation.", 150, 470, 600, "left" )
	love.graphics.printf("3) Any live cell with more than three live neighbours dies, as if by overcrowding.", 150, 490, 600, "left" )
	love.graphics.printf("4) Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.", 150, 510, 600, "left" )



	
end

