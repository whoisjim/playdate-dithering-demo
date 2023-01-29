local gfx = playdate.graphics

local stencil = gfx.image.new(400, 240, gfx.kColorWhite)

speed = 1

function setPattern100 ()
	gfx.setColor(gfx.kColorBlack)
end
function setPattern75 ()
	gfx.setPattern({0xaa, 0x00, 0xaa, 0x00, 0xaa, 0x00, 0xaa, 0x00}) --normal
	--gfx.setPattern({0x88, 0x22, 0x44, 0x11, 0x88, 0x22, 0x44, 0x11}) -- alt staggered
end
function setPattern50 ()
	gfx.setPattern({0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55})
end
function setPattern25 ()
	gfx.setPattern({0xff, 0x55, 0xff, 0x55, 0xff, 0x55, 0xff, 0x55}) -- normal
	--gfx.setPattern({0xee, 0xbb, 0xdd, 0x77, 0xee, 0xbb, 0xdd, 0x77}) -- alt staggered
end
function setPattern0 ()
	gfx.setColor(gfx.kColorWhite)
end

function loadDitheredImage (path)
	local img = {}
	local i = 1
	while true do
		local p = path..i
		img[i] = gfx.image.new(p)
		if img[i] == nil then
			break
		end
		i = i + 1
	end
	img.size = i - 1
	img.draw = function (t, x, y, flip)
		for j = 1,t.size do
			-- draw the sencil
			-- look into playdate.graphics.setStencilPattern
			gfx.lockFocus(stencil)
			gfx.setColor(gfx.kColorBlack)
			gfx.fillRect(0,0,400,240)
			gfx.setImageDrawMode(gfx.kDrawModeNXOR)  -- the images should be white instead of black so we can just copy instead
			t[j]:draw(x, y, flip)
			gfx.setImageDrawMode(gfx.kDrawModeCopy)
			gfx.unlockFocus()
			
			-- set the dither pattern for the level this image is
			if j == 1 then
				setPattern0()
			elseif j == 2 then	
				setPattern25()
			elseif j == 3 then	
				setPattern50()
			elseif j == 4 then	
				setPattern75()
			elseif j == 5 then	
				setPattern100()
			end

			-- draw the dither within the stencil
			gfx.setStencilImage(stencil)
			w, h = t[j]:getSize()
			gfx.fillRect(x, y, w, h)
			gfx.clearStencil()
		end
	end
	return img
end

balls = {
	{ -- posterized 5 colors and then dithered by playdate
		img = loadDitheredImage('assets\\ball_5posterize'),
		x = 200 - 64,
		y = 120 - 64,
		dx = math.sin(1),
		dy = math.cos(1),
	},
	{ -- dithered 5 colors and then dithered by playdate
		img = loadDitheredImage('assets\\ball_5dither'),
		x = 200 - 64,
		y = 120 - 64,
		dx = math.sin(3),
		dy = math.cos(3),
	},
	{ -- dithered 2 colors no dithering by playdate
		img = gfx.image.new('assets\\ball_2dither'),
		x = 200 - 64,
		y = 120 - 64,
		dx = math.sin(5),
		dy = math.cos(5),
	},
	{ -- dithered 2 colors no dithering by playdate, but with big 2x pixels
		img = gfx.image.new('assets\\ball_2ditherX2'),
		x = 200 - 64,
		y = 120 - 64,
		dx = math.sin(7),
		dy = math.cos(7),
	}
}

function playdate.update()
	setPattern25()
	gfx.fillRect(0,0,400,240)

	for key, ball in pairs(balls) do
		ball.img:draw(ball.x, ball.y)
		ball.x = ball.x + ball.dx * speed
		ball.y = ball.y + ball.dy * speed

		if ball.x > 400 - 128 or ball.x < 0 then
			ball.dx = ball.dx * -1
		end
		if ball.y > 240 - 128 or ball.y < 0 then
			ball.dy = ball.dy * -1
		end
	end
	playdate.drawFPS(0, 0)
end

function playdate.AButtonDown()
	balls[1], balls[2], balls[3], balls[4] = balls[4], balls[1], balls[2], balls[3]
end

function playdate.BButtonDown()
	for key, ball in pairs(balls) do
		local v = math.random() * 2 * math.pi
		ball.dx = math.sin(v)
		ball.dy = math.cos(v)
	end
	speed = 1
end

function playdate.BButtonHeld()
	for key, ball in pairs(balls) do
		ball.x = 200 - 64
		ball.y = 120 - 64
	end
end

function playdate.upButtonDown()
	speed = speed + 0.2
end

function playdate.downButtonDown()
	speed = speed - 0.2
end

function playdate.cranked(change, acceleratedChange)
	speed = speed + change * 0.01
end

if playdate.update == nil then
	playdate.update = function() end
	playdate.graphics.drawText("Please uncomment one of the import statements.", 15, 100)
end
