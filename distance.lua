local addonName, addon = ...

local totalDistance = 0
local lastPosition = nil
local displayDistance = false

local function OnUpdate(self, elapsed)
  local x, y = UnitPosition("player")
  if lastPosition then
    local dx, dy = x - lastPosition.x, y - lastPosition.y
    local distance = math.sqrt(dx*dx + dy*dy)
    totalDistance = totalDistance + distance
  end
  lastPosition = { x = x, y = y }

  if displayDistance then
    print("Total distance traveled: " .. totalDistance .. " yards.")
  end
end

-- Create the frame
local frame = CreateFrame("Frame", "MyAddonDisplay", PlayerFrame)

-- Set the frame's position
frame:SetPoint("TOPLEFT", 10, -10)

-- Add a label to the frame
frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
frame.text:SetPoint("TOPLEFT", 5, -5)
frame.text:SetText("Distance: 0")

-- Set the new parent frame for the display
frame.text:SetParent(frame)


local function OnEvent(self, event, ...)
  if event == "PLAYER_LOGIN" then
    local frame = CreateFrame("Frame")
    frame:SetScript("OnUpdate", OnUpdate)
    
    -- Register slash commands for toggling the display of distance
    SLASH_MYADDON1 = "/dist"
    SlashCmdList["MYADDON"] = function(msg)
      if msg == "toggle" then
        displayDistance = not displayDistance
        if displayDistance then
          print("Distance display enabled.")
        else
          print("Distance display disabled.")
        end
      end
    end
  elseif event == "PLAYER_LOGOUT" then
    print("Total distance traveled: " .. totalDistance .. " yards.")
  end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:SetScript("OnEvent", OnEvent)
