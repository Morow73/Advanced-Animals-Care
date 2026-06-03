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
---@return table pregnancyColor
function AAC.UTILS.GetColorOptions()
    local color_option = AAC.OPTIONS.USERS_OPTIONS['baseColor']:getValue()
    local color_option_dead = AAC.OPTIONS.USERS_OPTIONS['deadColor']:getValue()
    local color_option_warning = AAC.OPTIONS.USERS_OPTIONS['warningColor']:getValue()
    local color_option_mouseover = AAC.OPTIONS.USERS_OPTIONS['mouseOverColor']:getValue()
    local color_option_pregnancy = AAC.OPTIONS.USERS_OPTIONS['pregnancyColor']:getValue()

    if color_option and color_option_dead and color_option_warning and color_option_mouseover and color_option_pregnancy then
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
        }, {
            r = color_option_pregnancy.r,
            g = color_option_pregnancy.g,
            b = color_option_pregnancy.b,
            a = color_option_pregnancy.a
        }
    end

    return AAC.OPTIONS.DEFAULT_OPTIONS['baseColor'].color, AAC.OPTIONS.DEFAULT_OPTIONS['deadColor'].color, AAC.OPTIONS.DEFAULT_OPTIONS['warningColor'].color, AAC.OPTIONS.DEFAULT_OPTIONS['mouseOverColor'].color, AAC.OPTIONS.DEFAULT_OPTIONS['pregnancyColor'].color
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


---format rich text
---@param key string
---@param value string | number | nil
---@param center boolean
---@param size string | nil
---@param color table | nil
---@return string
function AAC.UTILS.FormatRichText(key, value, center, size, color)
    if not key then return "" end
    local chain

    if not size then
        size = "small"
    end

    if not color then
        color = { r = 1.0, g = 1.0, b = 1.0 }
    else
        color = { r = color.r, g = color.g, b = color.b }
    end

    if not value then
        if not center then
            chain = "<TEXT> <SIZE:"..size.."> <RGB:"..string.format("%.2f,%.2f,%.2f", color.r, color.g, color.b).."> " .. key
        else
            chain = "<TEXT> <CENTRE> <SIZE:"..size.."> <RGB:"..string.format("%.2f,%.2f,%.2f", color.r, color.g, color.b).."> " .. key
        end
    else
        if center then
            chain = "<TEXT> <CENTRE> <SIZE:"..size.."> <RGB:1,1,1>"..key.." <SPACE> : <SPACE><RGB:"..string.format("%.2f,%.2f,%.2f", color.r, color.g, color.b).."> " .. tostring(value) .. " <LINE>"
        else
            chain = "<TEXT> <SIZE:"..size.."> <RGB:1,1,1>"..key.." <SPACE> : <SPACE><RGB:"..string.format("%.2f,%.2f,%.2f", color.r, color.g, color.b).."> " .. tostring(value) .. " <LINE>"
        end
    end

    return chain
end