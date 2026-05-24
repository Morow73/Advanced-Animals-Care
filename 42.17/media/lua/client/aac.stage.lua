AAC = AAC or {}
AAC.STAGE = AAC.STAGE or {}

---return pregnant animals stage
---@param animal IsoAnimal
---@return string stage
function AAC.STAGE.GetAnimalPregnancyStage(animal)
    local data = animal:getData()

    if not data:isPregnant() then
        return ""
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

---return animal milk stage
---@param animal IsoAnimal
---@return string stage
function AAC.STAGE.GetAnimalMilkStage(animal)
    if not animal or not animal:hasUdder() then
        return ""
    end

    local data = animal:getData()
    local canHaveMilk = data:canHaveMilk()

    if not canHaveMilk then
        return ""
    end

    local milkQuantity = data:getMilkQuantity()
    local maxMilk = data:getMaxMilk()
    local stage

    if milkQuantity > maxMilk then
        stage = getText("IGUI_Animal_UdderUrgent")
    elseif milkQuantity < 1 and milkQuantity > 0.1 then
        stage = getText("IGUI_Animal_UdderSmall")
    elseif milkQuantity < 0.1 then
        stage = getText("IGUI_Animal_UdderNotEnough")
    elseif milkQuantity > (maxMilk / 24) then
        stage = getText("IGUI_Animal_UdderReady")
    end

    return stage or ""
end

---return animal mating season status or pregnancy cooldown text
---@param animal IsoAnimal
---@return string stage
function AAC.STAGE.GetAnimalMatingStatus(animal)
    if not animal or animal:isBaby() then
        return ""
    end

    local data = animal:getData()
    if not data then
        return ""
    end

    local lastPregnancy = data:getLastPregnancyPeriod()
    local stage

    if lastPregnancy then
        stage = getText("IGUI_Animal_TooSoonForBaby") .. " (" .. lastPregnancy .. " " .. getText("IGUI_Gametime_hours") .. ")"
    end

    if data:getDaysSurvived() < animal:getMinAgeForBaby() then
        stage = getText("IGUI_Animal_TooYoungForBaby")
    end

    if animal:isInMatingSeason() then
        stage = getText("IGUI_Yes")
    end

    return stage or getText("IGUI_No")
end

---return male impregnation readiness status
---@param animal IsoAnimal
---@return string stage
function AAC.STAGE.GetAnimalMaleImpregnateStatus(animal)
    if not animal or animal:isFemale() or animal:isBaby() then
        return ""
    end

    local data = animal:getData()

    if not data then
        return ""
    end

---@diagnostic disable-next-line: param-type-mismatch
    local lastImpregnate = data:getLastImpregnatePeriod(nil)

    if not lastImpregnate or lastImpregnate < 0 then
        return ""
    end

    if lastImpregnate == 0 then
        if animal:haveMatingSeason() and not animal:isInMatingSeason() then
            return getText("IGUI_No")
        end
        return getText("IGUI_Animal_ReadyToImpregnate")
    end

    return getText("IGUI_Animal_ReadyToImpregnateIn") .. " " .. lastImpregnate .. " " .. getText("IGUI_Gametime_hours")
end