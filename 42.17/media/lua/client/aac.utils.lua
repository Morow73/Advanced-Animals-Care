AAC = AAC or {}
AAC.UTILS = {}

---round a number to a specified number of decimal places.
---@param number number
---@param decimals integer | nil
---@return number
function AAC.UTILS.Round(number, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(number * mult + 0.5) / mult
end

---return color highlight options choice.
---@return table deadColor
---@return table warningColor
---@return table mouseOverColor
---@return table pregnancyColor
function AAC.UTILS.GetColorOptions()
    local color_option_dead = AAC.OPTIONS.USERS_OPTIONS['deadColor']:getValue()
    local color_option_warning = AAC.OPTIONS.USERS_OPTIONS['warningColor']:getValue()
    local color_option_mouseover = AAC.OPTIONS.USERS_OPTIONS['mouseOverColor']:getValue()
    local color_option_pregnancy = AAC.OPTIONS.USERS_OPTIONS['pregnancyColor']:getValue()

    if color_option_dead and color_option_warning and color_option_mouseover and color_option_pregnancy then
        return {
            r = color_option_dead.r,
            g = color_option_dead.g,
            b = color_option_dead.b,
            a = color_option_dead.a
        }, {
            r = color_option_warning.r,
            g = color_option_warning.g,
            b = color_option_warning.b,
            a = color_option_warning.a
        }, {
            r = color_option_mouseover.r,
            g = color_option_mouseover.g,
            b = color_option_mouseover.b,
            a = color_option_mouseover.a
        }, {
            r = color_option_pregnancy.r,
            g = color_option_pregnancy.g,
            b = color_option_pregnancy.b,
            a = color_option_pregnancy.a
        }
    end

    return AAC.OPTIONS.DEFAULT_OPTIONS['deadColor'].color,
        AAC.OPTIONS.DEFAULT_OPTIONS['warningColor'].color, AAC.OPTIONS.DEFAULT_OPTIONS['mouseOverColor'].color,
        AAC.OPTIONS.DEFAULT_OPTIONS['pregnancyColor'].color
end

---return checkbox options choice.
---@param option string | nil
---@return table | boolean checkboxOptions
function AAC.UTILS.GetCheckboxOptions(option)
    local checkbox_options = AAC.OPTIONS.USERS_OPTIONS['displayOptions']

    if not checkbox_options then
        return {}
    end

    local values = {}

    for i = 1, #AAC.OPTIONS.DEFAULT_OPTIONS.DISPLAY, 1 do
        local id = AAC.OPTIONS.DEFAULT_OPTIONS.DISPLAY[i].id

        if option and option == id then
            return checkbox_options:getValue(i)
        end

        values[id] = checkbox_options:getValue(i)
    end

    return values
end