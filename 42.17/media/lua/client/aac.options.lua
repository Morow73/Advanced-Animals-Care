AAC = AAC or {}
AAC.OPTIONS = AAC.OPTIONS or {}
AAC.OPTIONS.USERS_OPTIONS = {}
AAC.OPTIONS.DEFAULT_OPTIONS = {
    COLOR = {
        ['deadColor'] = { id = "deadColor", description = "IGUI_AAC_Dead_Animal_Color", color = { r = 1.0, g = 0.0, b = 0.0, a = 0.5 } },
        ['warningColor'] = { id = "warningColor", description = "IGUI_AAC_Warning_Animal_Color", color = { r = 1.0, g = 1.0, b = 0.0, a = 0.85 } },
        ['mouseOverColor'] = { id = "mouseOverColor", description = "IGUI_AAC_Mouse_Over_Animal_Color", color = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 } },
        ['pregnancyColor'] = { id = "pregnancyColor", description = "IGUI_AAC_Pregnancy_Animal_Color", color = { r = 1.0, g = 0.75, b = 0.80, a = 0.85 } }
    },
    DISPLAY = {
        { id = "showPregnancyStage", description = "IGUI_AAC_Show_Pregnancy_Stage", value = true },
        { id = "showMilkStage", description = "IGUI_AAC_Show_Milk_Stage", value = true },
        { id = "showMatingSeason", description = "IGUI_AAC_Show_Mating_Season", value = true },
        { id = "showImpregnationReadiness", description = "IGUI_AAC_Show_Impregnation_Readiness", value = true },
        { id = "showPregnancyTime", description = "IGUI_AAC_Show_Pregnancy_Time", value = true },
    }
}

local PZ_Options = PZAPI.ModOptions:create('aac_options', 'Advanced Animals Care')

for key, value in pairs(AAC.OPTIONS.DEFAULT_OPTIONS.COLOR) do
    AAC.OPTIONS.USERS_OPTIONS[key] = PZ_Options:addColorPicker(
        value.id,
        value.description,
        value.color.r,
        value.color.g,
        value.color.b,
        value.color.a,
        nil
    )
end

PZ_Options:addDescription("IGUI_AAC_Choice_Status_Show")
local PZ_Options_MultipleTickBox = PZ_Options:addMultipleTickBox('aac_options_tickbox', "")

AAC.OPTIONS.USERS_OPTIONS['displayOptions'] = PZ_Options_MultipleTickBox

for i = 1, #AAC.OPTIONS.DEFAULT_OPTIONS.DISPLAY, 1 do
    local value = AAC.OPTIONS.DEFAULT_OPTIONS.DISPLAY[i]
    PZ_Options_MultipleTickBox:addTickBox(value.description, value.value)
end

PZ_Options.apply = function(self) end
