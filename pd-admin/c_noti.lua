sx, sy = guiGetScreenSize()

zoom = exports["pd-gui"]:getInterfaceZoom()

bgnoti = dxCreateTexture("images/background.png")



function drawNoti()
  local w, h = sx*0.156, sy*0.182
  local x, y = sx*0.058, sy-h-sy*0.056
dxDrawImage(85/zoom, y-250/zoom, 400/zoom, 140/zoom, bgnoti, 0,0,0, tocolor(255,255,255,a["alpha"]))

dxDrawText(title, 350/zoom, y-245/zoom, 350/zoom, y-245/zoom, tocolor(200,0,200,a["alpha"]), 0.9/zoom, exports['pd-gui']:getGUIFont("normal_small"), "center")
dxDrawText(desc, 235/zoom, y-220/zoom, 235/zoom, y-220/zoom, tocolor(255,255,255, a["alpha"]), 0.8/zoom, exports['pd-gui']:getGUIFont("normal_small"), "left")

end

function initNoti(tytul, opis)
  title = tytul 
  desc = opis
  addEventHandler("onClientRender", root, drawNoti)
  setAnimation("alpha", 0, 255, 1000, "InQuad" )
  setTimer(function()
  
  removeEventHandler("onClientRender", root, drawNoti)
  
  end, 10000, 1)


end
addEvent("admin:addPunishment", true)
addEventHandler("admin:addPunishment", root, initNoti)


bg = dxCreateTexture("images/ann_background.png")


function announce()

dxDrawImage(0,0,sx, 25/zoom, bg, 0,0,0, tocolor(255,255,255,a["a"]))
dxDrawText(text, a["textmove"]/zoom, 1/zoom,  a["textmove"]/zoom, 1/zoom, tocolor(255,255,255,a["a"]), 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "right"  )

end

actual = false

function initAnnounce(tekst)
    if actual == true then return end
    text = tekst
    playSound("sounds/ann.wav")
    actual = true
    setTimer(function()
      width = dxGetTextWidth(text, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small"))
    addEventHandler("onClientRender", root, announce)
    setAnimation("a", 0, 255, 2000, "InQuad" )
    setAnimation("textmove", sx, -width-100, 20000, "Linear" )
    end, 2000, 1)
    setTimer(function()
    setAnimation("textmove", sx+width+100, -width-100, 20000, "Linear" )
    end, 20000, 1)
    setTimer(function()
        setAnimation("a", 255, 0, 2000, "InQuad" )
        setTimer(function()
        removeEventHandler("onClientRender", root, announce)
        actual = false
        end, 2000, 1)
    end, 33000, 1)
end
addEvent("admin:addAnnounce", true)
addEventHandler("admin:addAnnounce", root, initAnnounce)




function drawPunish()
  local r,g,b = interpolateBetween(50,0,0,255,0,0,(getTickCount()-tick)/1000,"SineCurve")
  exports["pd-gui"]:drawBWRectangle(0/zoom, 0/zoom, sx, sy, tocolor(0,0,0,255), false)
  dxDrawText(title, sx/2, sy/2-250/zoom, sx/2, sy/2-250/zoom, tocolor(240, 65, 53,r), 1/zoom, exports["pd-gui"]:getGUIFont("normal_big"), "center"  )
  dxDrawText(opis, sx/2, sy/2-200/zoom, sx/2, sy/2-200/zoom, tocolor(255,255,255,r), 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center"  )

end

function initPunish(tytul, desc)

title = tytul
opis = desc
addEventHandler("onClientRender", root, drawPunish)
warnSound = playSound("sounds/warn.wav")
tick = getTickCount()
setTimer(function()

  removeEventHandler("onClientRender", root, drawPunish)

end, 10000, 1)

end
addEvent("admin:initPunish", true)
addEventHandler("admin:initPunish", root, initPunish)

