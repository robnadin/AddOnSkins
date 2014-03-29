local AS = unpack(AddOnSkins)

if not AS:CheckAddOn('PetJournalEnhanced') then return end

local name = 'PetJournalEnhancedSkin'
function AS:SkinPetJournalEnhanced(event, addon)
	if event == 'PLAYER_LOGIN' then
	end
	if addon == 'Blizzard_PetJournal' or IsAddOnLoaded('Blizzard_PetJournal') then
		PetJournal:HookScript('OnShow', function() PJEUniquePetCount:StripTextures() end)
		AS:UnregisterEvent(name, 'ADDON_LOADED')
	end
end

AS:RegisterSkin(name, AS.SkinPetJournalEnhanced, 'ADDON_LOADED')