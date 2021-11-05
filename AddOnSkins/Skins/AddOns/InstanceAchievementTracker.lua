local AS = unpack(AddOnSkins)

if not AS:CheckAddOn('InstanceAchievementTracker') then return end

local _G = _G
local hooksecurefunc = hooksecurefunc

local function SkinPanel(Panel)
	for i = 1, Panel:GetNumChildren() do
		local Child = select(i, Panel:GetChildren())
		-- if Child:IsObjectType('ScrollBar') then
			-- AS:SkinScrollBar(Child)
		if Child:IsObjectType('CheckButton') then
			AS:SkinCheckBox(Child)
		elseif Child:IsObjectType('Button') then
			AS:SkinButton(Child)
		elseif Child:IsObjectType('Slider') then
			AS:SkinSlideBar(Child, true)
		elseif Child:IsObjectType('Tab') then
			AS:SkinTab(Child)
		elseif Child:IsObjectType('Frame') and Child.Left and Child.Middle and Child.Right then
			AS:SkinDropDownBox(Child)
		end

		-- Apply recursively
		SkinPanel(Child)
	end
end

local function SkinButton(Button, height, dx, dy)
	if not Button.isSkinned then
		AS:SkinButton(Button)
		local original_SetSize = Button.SetSize
		Button.SetSize = function(self, width)
			original_SetSize(self, width, height)
			local point, relativeTo, relativePoint, xOfs = self:GetPoint()
			self:SetPoint(point, relativeTo, relativePoint, xOfs + dx, dy)
		end
		Button.isSkinned = true
	end
end

local function SkinOptionsFrame()
	AS:SkinFrame(_G.AchievementTracker)
	AS:SkinCloseButton(_G.AchievementTrackerClose)

	-- Skin tabs
	for i = 1, 8 do
		local Tab = _G['AchievementTrackerTab'..i]
		AS:SkinTab(Tab)

		if (i == 1) then
			Tab:SetPoint('TOPLEFT', AchievementTracker, 'BOTTOMLEFT', 5, 2)
		end
	end

	local InterfaceOptions = {
		_G.AchievementTracker
	}

	-- Skin options tab
	local Options = {
		_G.AchievementTracker_EnableAddon,
		_G.AchievementTracker_ToggleMinimapIcon,
		_G.AchievementTracker_ToggleAchievementAnnounce,
		_G.AchievementTracker_ToggleTrackMissingAchievementsOnly,
		_G.AchievementTracker_ToggleAnnounceToRaidWarning,
		_G.AchievementTracker_ToggleSound,
		_G.AchievementTracker_ToggleSoundFailed,
		_G.AchievementTracker_SelectSoundDropdownCompleted,
		_G.AchievementTracker_SelectSoundDropdownFailed,
		_G.AchievementTracker_HideCompletedAchievements,
		_G.AchievementTracker_GreyOutCompletedAchievements,
		_G.AchievementTracker_EnableAutomaticCombatLogging,
		_G.AchievementTracker_DisplayInfoFrame,
		_G.AchievementTracker_TrackCharacterAchievements,
		_G.AchievementTracker_TrackAchievementsInBlizzardUI,
		_G.AchievementTracker_TrackAchievementsAutomatically,
		_G.AchievementTracker_ChangeMinimapIcon,
	}

	for _, Frame in pairs(Options) do
		local Name = Frame:GetName()
		if Frame:IsObjectType('CheckButton') then
			AS:SkinCheckBox(Frame)
			local x, y = Frame:GetCenter()
			Frame:SetSize(25.99998664856,25.99998664856)
		elseif Frame:IsObjectType('Button') then
			AS:SkinButton(Frame)
		elseif Frame:IsObjectType('Frame') and _G[Name..'Left'] and _G[Name..'Middle'] and _G[Name..'Right'] then
			AS:SkinDropDownBox(Frame)
		end
	end

	for i = 1, _G.AchievementTracker_ChangeMinimapIcon:GetNumChildren() do
		local Child = select(i, _G.AchievementTracker_ChangeMinimapIcon:GetChildren())
		if Child:IsObjectType('Button') then
			AS:SkinButton(Child)
		end
	end

	-- Skin expansion tabs contents
	AS:SkinScrollBar(_G.AchievementTracker.ScrollFrame.ScrollBar)
	hooksecurefunc(_G.AchievementTracker.ScrollFrame, 'SetScrollChild', function(self)
		local scrollChild = self:GetScrollChild()
		if scrollChild and not scrollChild.isSkinned then
			SkinPanel(scrollChild)
			scrollChild.isSkinned = true
		end
	end)

	-- Skin achievement tabs content
	AS:SkinScrollBar(_G.AchievementTracker.ScrollFrame2.ScrollBar)
	hooksecurefunc(_G.AchievementTracker.ScrollFrame2, 'SetScrollChild', function(self)
		local scrollChild = self:GetScrollChild()
		if scrollChild and not scrollChild.isSkinned then
			for i = 1, scrollChild:GetNumChildren() do
				local Child = select(i, scrollChild:GetChildren())
				if Child:IsObjectType('Button') and not Child.isSkinned then
					Child.SetNormalTexture = function(self)
						if not self.isSkinned then
							AS:StripTextures(self)
							self.isSkinned = true
						end
					end

					AS:SkinCheckBox(Child.enabled)

					local height = Child:GetHeight() - 10		
					SkinButton(Child.tactics, height, -1, -5)
					SkinButton(Child.players, height, 0, 0)

					local original_SetFont = Child.contentText.SetFont
					Child.contentText.SetFont = function(self)
						if not self.isSkinned then
							original_SetFont(self, AS.Font, 14)
							self.isSkinned = true
						end
					end
					Child.isSkinned = true
				end
			end
			scrollChild.isSkinned = true
		end
	end)
end

local function SkinTrackingFrame()
	hooksecurefunc('createEnableAchievementTrackingUI', function()
		if _G.AchievementTrackerCheck and not _G.AchievementTrackerCheck.isSkinned then
			AS:SkinFrame(_G.AchievementTrackerCheck)
			AS:SkinCloseButton(_G.AchievementTrackerCheckClose)
			AS:SkinButton(_G.AchievementTrackerCheck.btnYes)
			AS:SkinButton(_G.AchievementTrackerCheck.btnNo)
			_G.AchievementTrackerCheck.isSkinned = true
		end
	end)
end

function AS:InstanceAchievementTracker()
	SkinOptionsFrame()
	SkinTrackingFrame()
end

AS:RegisterSkin('InstanceAchievementTracker', AS.InstanceAchievementTracker)
