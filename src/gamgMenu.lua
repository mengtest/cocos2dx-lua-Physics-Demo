gameMenu = class("gameMenu", function()
	return cc.Scene:create()
end)

function gameMenu:create()
	menuScene = gameMenu:new()
	menuScene:addChild(menuScene:createMenu())
	return menuScene
end

local function gameMenu:ctor()
	local menuPlay = cc.MenuItemImage:create("play.png","play.png")
	local menuAbout = cc.MenuItemImage:create("about.png","about.png")
	local menuScores = cc.MenuItemImage:create("scores.png","scores.png")
end

local function gameMenu:createMenu()
	local menu = cc.Menu:create()

	menuPlay:registerScriptTapHandler(menuPlayCallback)
	menuAbout:registerScriptTapHandler(menuAboutCallback)
	menuScores:registerScriptTapHandler(menuScoresCallback)

	menu:addChild(menuScores)
	menu:addChild(menuPlay)
	menu:addChild(menuAbout)

	menu:setPosition(cc.p(0,0))
	menuScene:addChild(menu)
end

local function gameMenu:menuPlayCallback(sender)
	local scene = require(physicsScene)
	local mScene = scene:create()
	cc.Director:getInstance():replaceScene(mScene)
end

local function gameMenu:menuAboutCallback(sender)
end

local function gameMenu:menuScoresCallback(sebder)
end