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
---@return table baseColor
---@return table deadColor
---@return table warningColor
---@return table mouseOverColor
function AAC.UTILS.GetColorOptions()
    local color_option = AAC.OPTIONS.USERS_OPTIONS['baseColor']:getValue()
    local color_option_dead = AAC.OPTIONS.USERS_OPTIONS['deadColor']:getValue()
    local color_option_warning = AAC.OPTIONS.USERS_OPTIONS['warningColor']:getValue()
    local color_option_mouseover = AAC.OPTIONS.USERS_OPTIONS['mouseOverColor']:getValue()

    if color_option and color_option_dead and color_option_warning and color_option_mouseover then
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
        }, {
            r = color_option_mouseover.r,
            g = color_option_mouseover.g,
            b = color_option_mouseover.b,
            a = color_option_mouseover.a
        }
    end

    return AAC.OPTIONS.DEFAULT_OPTIONS['baseColor'].color, AAC.OPTIONS.DEFAULT_OPTIONS['deadColor'].color, AAC.OPTIONS.DEFAULT_OPTIONS['warningColor'].color, AAC.OPTIONS.DEFAULT_OPTIONS['mouseOverColor'].color
end

---return checkbox options choice.
---@return table checkboxOptions
function AAC.UTILS.GetCheckboxOptions()
    local checkbox_options = AAC.OPTIONS.USERS_OPTIONS['displayOptions']

    if not checkbox_options then
        return {}
    end

    local values = {}

    for i = 1, #AAC.OPTIONS.DEFAULT_OPTIONS.DISPLAY, 1 do
        local id = AAC.OPTIONS.DEFAULT_OPTIONS.DISPLAY[i].id
        values[id] = checkbox_options:getValue(i)
    end

    return values
end

---format rich text line.
---@param key string
---@param value string | number
---@param color table | nil
---@return string
function AAC.UTILS.FormatRichTextLine(key, value, color)
    if not key then return "" end

    local label = string.gsub(getText(key), "%s*:%s*$", "")
    local valueText = value == nil and "-" or tostring(value)

    if color then
        return "<TEXT> <RGB:1,1,1> " .. label .. " <SPACE> : <SPACE><RGB:"..string.format("%.2f,%.2f,%.2f", color.r, color.g, color.b).."> " .. valueText .. " <LINE>"
    end
    return "<TEXT> <RGB:1,1,1> " .. label .. " <SPACE> : <SPACE><RGB:0.7,0.7,0.7> " .. valueText .. " <LINE>"
end

---format rich text value.
---@param text string
---@param color table | nil
---@return string
function AAC.UTILS.FormatRichTextValue(text, color)
    if not text then return "" end

    if color then
        return "<TEXT> <SIZE:medium> <RGB:"..string.format("%.2f,%.2f,%.2f", color.r, color.g, color.b).."> <SIZE:small> " .. tostring(text) .. " <LINE>"
    end
    return "<TEXT> <SIZE:medium> " .. tostring(text) .. " <LINE>"
end