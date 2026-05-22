---return pregnant animals stage
---@param animal IsoAnimal
---@return string
function GetAnimalPregnancyStage(animal)
    local data = animal:getData()

    if not data:isPregnant() then
        return getText("IGUI_No")
    end

    local period = data:getPregnantPeriod()
    if not period or period == 0 then
        return ""
    end

    local time = data:getPregnancyTime()
    local perc = time / period
    local stage

    if perc < 0.08 then
        stage = getText("IGUI_No")
    elseif perc < 0.3 then
        stage = getText("IGUI_Animal_Pregnancy_Begin")
    elseif perc < 0.65 then
        stage = getText("IGUI_Animal_Pregnancy_Gestating")
    elseif perc < 0.85 then
        stage = getText("IGUI_Animal_Pregnancy_Almost")
    else
        stage = getText("IGUI_Animal_Pregnancy_Ready")
    end

    return stage
end