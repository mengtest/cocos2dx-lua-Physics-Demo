physicsScene = class("physicsScene",function()
	return cc.Scene:createWithPhysics() 
end)

function physicsScene:create()
	pScene = physicsScene:new()
	pScene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
	pScene:addChild(pScene:createLayer())
	return pScene
end

function physicsScene:ctor(  )
	
end

function physicsScene:createLayer()
	
	local layer = cc.Layer:create()

	local size = cc.Director:getInstance():getWinSize()
	--定义世界的边界
	local body = cc.PhysicsBody:createEdgeBox(size,cc.PHYSICSBODY_MATERIAL_DEFAULT,5.0)
	local edgeNode = cc.Node:create()
	edgeNode:setPosition(cc.p(size.width/2,size.height/2))
	edgeNode:setPhysicsBody(body)
	layer:addChild(edgeNode)


	local function touchBegan(touch,event)
		local location = touch:getLocation()
		self:addNewSpriteAtPosition(location)
		return false
	end

	local function onContactBegin(contact)

		local spriteA = contact:getShapeA():getBody():getNode()
		local spriteB = contact:getShapeB():getBody():getNode()

		if spriteA and spriteA:getTag() == 1 and spriteB and spriteB:getTag() == 1 then
			spriteA:setColor(cc.c3b(255,0,255))
			spriteB:setColor(cc.c3b(255,0,255))
		end
		return true
	end

	local function onContactPreSolve(contact)

		return true

	end

	local function onContactPostSolve(contact)
		
	end

	local function onContactSeperate(contact)
		
		local spriteA = contact:getShapeA():getBody():getNode()
		local spriteB = contact:getShapeB():getBody():getNode()
		if spriteA and spriteA:getTag() == 1 and spriteB and spriteB:getTag() == 1 then
			spriteA:setColor(cc.c3b(255, 255, 255))
			spriteB:setColor(cc.c3b(255, 255, 255))
		end

	end

	--创建一个事件监听器 OneByOne为单点触摸
	local listener = cc.EventListenerTouchOneByOne:create()
	--设置是否吞没事件，在onTouchBegan方法返回true时吞没
	listener:setSwallowTouches(true)
	--onTouchBegan事件回调函数
	listener:registerScriptHandler(touchBegan,cc.Handler.EVENT_TOUCH_BEGAN)

	local contactListener = cc.EventListenerPhysicsContact:create()
	contactListener:registerScriptHandler(onContactBegin,
		cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
	contactListener:registerScriptHandler(onContactPreSolve,
		cc.Handler.EVENT_PHYSICS_CONTACT_PRESOLVE)
	contactListener:registerScriptHandler(onContactPostSolve,
		cc.Handler.EVENT_PHYSICS_CONTACT_POSTSOLVE)
	contactListener:registerScriptHandler(onContactSeperate,
		cc.Handler.EVENT_PHYSICS_CONTACT_SEPERATE)

	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
	eventDispatcher:addEventListenerWithSceneGraphPriority(contactListener, layer)

	return layer

end

function physicsScene:addNewSpriteAtPosition(pos)
	local sp = cc.Sprite:create("menu1.png")
	local body = cc.PhysicsBody:createCircle(sp:getContentSize().width/2)
	sp:setPhysicsBody(body)
	sp:setPosition(pos)
	
	sp:setTag(1)
	body:setContactTestBitmask(0x1)

	local sp2 = cc.Sprite:create("menu1.png")
	local body2 = cc.PhysicsBody:createCircle(sp2:getContentSize().width/2)
	sp2:setPhysicsBody(body2)
	sp:setPosition(pos.x,pos.y)

	self:addChild(sp)
	self:addChild(sp2)

	local world = self:getScene():getPhysicsWorld()

	local joint = cc.PhysicsJointDistance:construct(body,body2,
		cc.p(0,0),cc.p(0,sp2:getContentSize().width/2))
	world:addJoint(joint)
end

return physicsScene

