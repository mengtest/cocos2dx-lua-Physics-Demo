cc.FileUtils:getInstance():addSearchPath("src")
cc.FileUtils:getInstance():addSearchPath("res")
-- CC_USE_DEPRECATED_API = true
require "cocos.init"
require "cocos.spine.SpineConstants"

-- cclog
cclog = function(...)
    print(string.format(...))
end

local SpineTestLayerNormal = class("SpineTestLayerNormal",function()
	return cc.Layer:create()
end)

function SpineTestLayerNormal:ctor()
	local function onNodeEvent(event)
		if event == "enter" then 
			self:init()
		end
	end
	self:registerScriptHandler(onNodeEvent)
end

function SpineTestLayerNormal:init()
	local skeletonNode = sp.SkeletonAnimation:create("spine/spineboy.json","spine/spineboy.atlas",0.6)
	skeletonNode:setScale(0.5)
	
	skeletonNode:registerSpineEventHandler(function (event)
		print(string.format("[spine] %d start: %s",
								event.trackIndex,
								event.animation))
		end,sp.EventType.ANIMATION_START)
		
	skeletonNode:registerSpineEventHandler(function (event)
      print(string.format("[spine] %d end:", 
                                event.trackIndex))
	end, sp.EventType.ANIMATION_END)
    
	skeletonNode:registerSpineEventHandler(function (event)
      print(string.format("[spine] %d complete: %d", 
                              event.trackIndex, 
                              event.loopCount))
	end, sp.EventType.ANIMATION_COMPLETE)
	
	skeletonNode:registerSpineEventHandler(function (event)
      print(string.format("[spine] %d event: %s, %d, %f, %s", 
                              event.trackIndex,
                              event.eventData.name,
                              event.eventData.intValue,
                              event.eventData.floatValue,
                              event.eventData.stringValue)) 
	end, sp.EventType.ANIMATION_EVENT)
	--俩个动画能衔接上
  skeletonNode:setMix("walk", "jump", 0.2)
  skeletonNode:setMix("jump", "run", 0.2)
  
  --setAnimation只能播放一种动画
  skeletonNode:setAnimation(0, "walk", true)

  --addAnimation可连续播放不同的动画
  skeletonNode:addAnimation(0, "jump", false, 3)
  skeletonNode:addAnimation(0, "run", true)

  local windowSize = cc.Director:getInstance():getWinSize()
  skeletonNode:setPosition(cc.p(windowSize.width / 2, 20))
  self:addChild(skeletonNode)

  local listener = cc.EventListenerTouchOneByOne:create()
  listener:registerScriptHandler(function (touch, event)
        if not skeletonNode:getDebugBonesEnabled() then
            skeletonNode:setDebugBonesEnabled(true)
        elseif skeletonNode:getTimeScale() == 1 then
            skeletonNode:setTimeScale(0.3)
        else
            skeletonNode:setTimeScale(1)
            skeletonNode:setDebugBonesEnabled(false)
        end

        return true
    end,cc.Handler.EVENT_TOUCH_BEGAN )

  local eventDispatcher = self:getEventDispatcher()
  eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
end



local function initGLView()
	
    local director = cc.Director:getInstance()
    local glView = director:getOpenGLView()
    if nil == glView then
        glView = cc.GLViewImpl:create("Lua Empty Test")
		
        director:setOpenGLView(glView)
    end

    director:setOpenGLView(glView)
	
	-- 屏幕适配
    glView:setDesignResolutionSize(480, 320, cc.ResolutionPolicy.NO_BORDER) 

    --turn on display FPS
    director:setDisplayStats(true)

    --set FPS. the default value is 1.0/60 if you don't call this
    director:setAnimationInterval(1.0 / 60)
end

local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    initGLView()

    require "hello2"
	
    cclog("result is " .. myadd(1, 1))
	
	visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()
	
   
    local function createLayerFarm()
        local layerFarm = cc.Layer:create()

        -- add in farm background
        local bg = cc.Sprite:create("farm.jpg")
        bg:setPosition(origin.x + visibleSize.width / 2 + 80, origin.y + visibleSize.height / 2)
        layerFarm:addChild(bg)

        -- add land sprite
        for i = 0, 3 do
            for j = 0, 1 do
                local spriteLand = cc.Sprite:create("land.png")
                spriteLand:setPosition(200 + j * 180 - i % 2 * 90, 10 + i * 95 / 2)
                layerFarm:addChild(spriteLand)
            end
        end

        -- add crop
        local frameCrop = cc.SpriteFrame:create("crop.png", cc.rect(0, 0, 105, 95))
        for i = 0, 3 do
            for j = 0, 1 do
                local spriteCrop = cc.Sprite:createWithSpriteFrame(frameCrop)
                spriteCrop:setPosition(10 + 200 + j * 180 - i % 2 * 90, 30 + 10 + i * 95 / 2)
                layerFarm:addChild(spriteCrop)
            end
        end

      
        return layerFarm
    end


    -- create menu
    local function createLayerMenu()
        local layerMenu = cc.Layer:create()

        local menuPopup, menuTools, effectID

        local function menuCallbackClosePopup()
            -- stop test sound effect
            cc.SimpleAudioEngine:getInstance():stopEffect(effectID)
            menuPopup:setVisible(false)
        end

        local function menuCallbackOpenPopup()
            -- loop test sound effect
            local effectPath = cc.FileUtils:getInstance():fullPathForFilename("effect1.wav")
            effectID = cc.SimpleAudioEngine:getInstance():playEffect(effectPath)
            menuPopup:setVisible(true)
        end
		
        -- add a popup menu
        local menuPopupItem = cc.MenuItemImage:create("menu2.png", "menu2.png")
        menuPopupItem:setPosition(0, 0)
		
		--注册点击事件
        menuPopupItem:registerScriptTapHandler(menuCallbackClosePopup)
        menuPopup = cc.Menu:create(menuPopupItem)
        menuPopup:setPosition(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 2)
        menuPopup:setVisible(false)
        layerMenu:addChild(menuPopup)
        
        -- add the left-bottom "tools" menu to invoke menuPopup
        local menuToolsItem = cc.MenuItemImage:create("menu1.png", "menu1.png")
        menuToolsItem:setPosition(0, 0)
        menuToolsItem:registerScriptTapHandler(menuCallbackOpenPopup)
        menuTools = cc.Menu:create(menuToolsItem)
        local itemWidth = menuToolsItem:getContentSize().width
        local itemHeight = menuToolsItem:getContentSize().height
        menuTools:setPosition(origin.x + itemWidth/2, origin.y + itemHeight/2)
        layerMenu:addChild(menuTools)

        return layerMenu
    end

    -- play background music, preload effect
    local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename("background.mp3") 
    cc.SimpleAudioEngine:getInstance():playMusic(bgMusicPath, true)
    local effectPath = cc.FileUtils:getInstance():fullPathForFilename("effect1.wav")
    cc.SimpleAudioEngine:getInstance():preloadEffect(effectPath)

    -- run
    local sceneGame = cc.Scene:create()
	Helper.createFunctionTable = 
    {
        SpineTestLayerNormal.create,
    }

	sceneGame:addChild(SpineTestLayerNormal.create(),1)
    sceneGame:addChild(createLayerFarm())
    sceneGame:addChild(createLayerMenu())
    cc.Director:getInstance():runWithScene(sceneGame)
end

xpcall(main, __G__TRACKBACK__)
