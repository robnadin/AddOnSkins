if not IsAddOnLoaded("ElvUI") then return end
if not IsAddOnLoaded("BigWigs") then return end
local U = unpack(select(2,...))
local s = U.s
local c = U.c

local name = "BigWigsSkin"
local function SkinBigWigs(self)
	local s = U.s
	local c = U.c

	local buttonsize = 20

	-- init some tables to store backgrounds
	local freebg = {}

	-- styling functions
	local createbg = function()
		local bg = CreateFrame("Frame")
		bg:SetTemplate("Transparent")
		return bg
	end

	local function freestyle(bar)
		-- reparent and hide bar background
		local bg = bar:Get("bigwigs:elvui:barbg")
		if bg then
			bg:ClearAllPoints()
			bg:SetParent(UIParent)
			bg:Hide()
			freebg[#freebg + 1] = bg
		end

		-- reparent and hide icon background
		local ibg = bar:Get("bigwigs:elvui:iconbg")
		if ibg then
			ibg:ClearAllPoints()
			ibg:SetParent(UIParent)
			ibg:Hide()
			freebg[#freebg + 1] = ibg
		end

		-- replace dummies with original method functions
		bar.candyBarBar.SetPoint=bar.candyBarBar.OldSetPoint
		bar.candyBarIconFrame.SetWidth=bar.candyBarIconFrame.OldSetWidth
		bar.SetScale=bar.OldSetScale
		
		--Reset Positions
		--Icon
		bar.candyBarIconFrame:ClearAllPoints()
		bar.candyBarIconFrame:SetPoint("TOPLEFT")
		bar.candyBarIconFrame:SetPoint("BOTTOMLEFT")
		bar.candyBarIconFrame:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		
		--Status Bar
		bar.candyBarBar:ClearAllPoints()
		bar.candyBarBar:SetPoint("TOPRIGHT")
		bar.candyBarBar:SetPoint("BOTTOMRIGHT")
		
		--BG
		bar.candyBarBackground:SetAllPoints()
		
		--Duration
		bar.candyBarDuration:ClearAllPoints()
		bar.candyBarDuration:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)
		
		--Name
		bar.candyBarLabel:ClearAllPoints()
		bar.candyBarLabel:SetPoint("LEFT", bar.candyBarBar, "LEFT", 2, 0)
		bar.candyBarLabel:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)	
	end

	local applystyle = function(bar)

		-- general bar settings

		bar:SetHeight(buttonsize-8)
		bar.OldSetScale=bar.SetScale
		bar.SetScale=c.noop
		bar:Height(buttonsize)
		bar:SetScale(1)
		
		-- create or reparent and use bar background
		local bg = nil
		if #freebg > 0 then
			bg = table.remove(freebg)
		else
			bg = createbg()
		end

		bg:SetParent(bar)
		bg:ClearAllPoints()
		bg:Point("TOPLEFT", bar, "TOPLEFT", -2, 2)
		bg:Point("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 2, -2)
		bg:SetFrameStrata("BACKGROUND")
		bg:Show()
		bar:Set("bigwigs:elvui:barbg", bg)

		-- create or reparent and use icon background
		local ibg = nil
		if bar.candyBarIconFrame:GetTexture() then
			if #freebg > 0 then
				ibg = table.remove(freebg)
			else
				ibg = createbg()
			end
			ibg:SetParent(bar)
			ibg:ClearAllPoints()
			ibg:Point("TOPLEFT", bar.candyBarIconFrame, "TOPLEFT", -2, 2)
			ibg:Point("BOTTOMRIGHT", bar.candyBarIconFrame, "BOTTOMRIGHT", 2, -2)
			ibg:SetFrameStrata("BACKGROUND")
			ibg:Show()
			bar:Set("bigwigs:elvui:iconbg", ibg)
		end

		-- setup timer and bar name fonts and positions
		bar.candyBarLabel:FontTemplate(nil, nil, 'MONOCHROMEOUTLINE')
		bar.candyBarLabel:SetJustifyH("LEFT")
		bar.candyBarLabel:ClearAllPoints()
		bar.candyBarLabel:Point("LEFT", bar, "LEFT", 4, 0)

		bar.candyBarDuration:FontTemplate(nil, nil, 'MONOCHROMEOUTLINE')
		bar.candyBarDuration:SetJustifyH("RIGHT")
		bar.candyBarDuration:ClearAllPoints()
		bar.candyBarDuration:Point("RIGHT", bar, "RIGHT", -4, 0)

		-- setup bar positions and look
		bar.candyBarBar.OldPoint, bar.candyBarBar.Anchor, bar.candyBarBar.OldPoint2, bar.candyBarBar.XPoint, bar.candyBarBar.YPoint  = bar.candyBarBar:GetPoint()
		bar.candyBarBar:ClearAllPoints()
		bar.candyBarBar:SetAllPoints(bar)
		bar.candyBarBar.OldSetPoint = bar.candyBarBar.SetPoint
		bar.candyBarBar.SetPoint=c.noop
		bar.candyBarBar:SetStatusBarTexture(c["media"].normTex)
		bar.candyBarBackground:SetTexture(unpack(c.media.backdropcolor))

		-- setup icon positions and other things
		bar.candyBarIconFrame.OldPoint, bar.candyBarIconFrame.Anchor, bar.candyBarIconFrame.OldPoint2, bar.candyBarIconFrame.XPoint, bar.candyBarIconFrame.YPoint  = bar.candyBarIconFrame:GetPoint()
		bar.candyBarIconFrame.OldWidth = bar.candyBarIconFrame:GetWidth()
		bar.candyBarIconFrame.OldHeight = bar.candyBarIconFrame:GetHeight()
		bar.candyBarIconFrame.OldSetWidth = bar.candyBarIconFrame.SetWidth
		bar.candyBarIconFrame.SetWidth=c.noop
		bar.candyBarIconFrame:ClearAllPoints()
		bar.candyBarIconFrame:Point("BOTTOMLEFT", bar, "BOTTOMLEFT", -(buttonsize + 5), 0)
		bar.candyBarIconFrame:SetSize(buttonsize, buttonsize)
		bar.candyBarIconFrame:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	end
	--Backup if the new events dont work [ DONT UNCOMMENT ]
	--self:SetScript("OnEvent", function(self, event) if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" or event == "ZONE_CHANGED_NEW_AREA" then RegisterStyle() end)
local function RegisterStyle()
	if not BigWigs then return end
	local bars = BigWigs:GetPlugin("Bars", true)
	local prox = BigWigs:GetPlugin("Proximity", true)
	if bars then
	bars:RegisterBarStyle("ElvUI", {
		apiVersion = 1,
		version = 1,
		GetSpacing = function(bar) return 8 end,
		ApplyStyle = applystyle,
		BarStopped = freestyle,
		GetStyleName = function() return "ElvUI" end,
	})
end
	hooksecurefunc(BigWigs.pluginCore.modules.Proximity, "RestyleWindow", function() BigWigsProximityAnchor:SetTemplate("Transparent") end)
end
s:RegisterSkin('BigWigs_Plugins', RegisterStyle, nil, true)
end

U.RegisterSkin(name,SkinBigWigs,"ZONE_CHANGED","ZONE_CHANGED_INDOORS","ZONE_CHANGED_NEW_AREA")

