local DEFAULT_OPTIONS = {
    ['baseColor'] = {id = "baseColor", description = "IGUI_AAC_Base_Animal_Color", color = {r = 0.0, g = 0.31, b = 0.0, a = 0.85}},
    ['deadColor'] = {id = "deadColor", description = "IGUI_AAC_Dead_Animal_Color", color = {r = 1.0, g = 0.0, b = 0.0, a = 0.5}},
    ['warningColor'] = {id = "warningColor", description = "IGUI_AAC_Warning_Animal_Color", color = {r = 1.0, g = 1.0, b = 0.0, a = 0.85}}
}

local PZ_Options = PZAPI.ModOptions:create('aac_options', 'Advanced Animals Care')
local options = {}

for key, value in pairs(DEFAULT_OPTIONS) do
    options[key] = PZ_Options:addColorPicker(
        value.id,
        value.description,
        value.color.r,
        value.color.g,
        value.color.b,
        value.color.a,
        nil
    )
end

function GetColorOptions()
    local color_option = options['baseColor']:getValue()
    local color_option_dead = options['deadColor']:getValue()
    local color_option_warning = options['warningColor']:getValue()

    if color_option and color_option_dead and color_option_warning then
        return {
            r = color_option.r,
            g = color_option.g,
            b = color_option.b,
            a = color_option.a
        }, {
            r = color_option_dead.r,
            g = color_option_dead.g,
            b = color_option_dead.b,
            a = color_option_dead.a
        }, {
            r = color_option_warning.r,
            g = color_option_warning.g,
            b = color_option_warning.b,
            a = color_option_warning.a
        }
    end

    return DEFAULT_OPTIONS['baseColor'].color, DEFAULT_OPTIONS['deadColor'].color, DEFAULT_OPTIONS['warningColor'].color
end

PZ_Options.apply = function(self) end
