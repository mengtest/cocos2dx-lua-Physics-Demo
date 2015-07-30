cc.FileUtils:getInstance():addSearchPath("src")
cc.FileUtils:getInstance():addSearchPath("res")
-- CC_USE_DEPRECATED_API = true
--require "cocos2d"
--require "GuiConstants"
require "Cocos.init"
require "cocos.spine.SpineConstants"

-- cclog
cclog = function(...)
    print(string.format(...))
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
    glView:setDesignResolutionSize(960, 640, cc.ResolutionPolicy.NO_BORDER) 

    --turn on display FPS
    director:setDisplayStats(true)

    --set FPS. the default value is 1.0/60 if you don't call this
    director:setAnimationInterval(1.0 / 60)
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    initGLView()
    require "hello2"
	
    require("physicsScene")
    local gameScene = physicsScene:create()

    if cc.Director:getInstance():getRunningScene() then    
        cc.Director:getInstance():replaceScene(gameScene)
    else    
        cc.Director:getInstance():runWithScene(gameScene)
    end
end

xpcall(main, __G__TRACKBACK__)

