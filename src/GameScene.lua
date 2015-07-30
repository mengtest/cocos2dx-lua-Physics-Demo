GameScene = class("GameScene", function (  )
	return cc.Scene:createWithPhysics() 
end)

function GameScene:create()
	scene = GameScene:new()
	scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
	scene:addChild(scene:createLayer())
	return scene
end

function GameScene:createLayer(  )

	local layer = cc.layer:create()

	local body = cc.PhysicsBody:createEdgeBox(size,
						cc.PHYSICSBODY_MATERIAL_DEFAULT, 5.0)
	local edgeNode = cc.Note:create()
	edgeNode:setPosition(cc.p(size.width/2, size.height/2))
	edgeNode:setPhysicsBody(body)
	self:addChild(edgeNode)

	local function touchBegan( touch, event )
		local location = touch:getLocation()
		self:addNewSpriteAtPosition(location)
		return false
	end

	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(true)
	listener:registerScriptHandler(touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	local eventDispatcher = self:getEventDispatcher()

	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

	return layer
end

function GameScene( pos )
	local sp = cc.Sprite:create("menu1")
	sp:setTag(1)
	local body = cc.PhysicsBody:createCircle(sp:getContentSize().width/2)
	sp:setPhysicsBody(body)
	sp:setPosition(pos)
	self:addChild(sp)
end

return GameScene