require "ISUI/ISToolTip"
require "ISUI/ISRichTextPanel"

AAC = AAC or {}
AAC.BASE = AAC.BASE or {}

local OriginalZoneUIRender
local OriginalZoneUIClose
local OriginalAnimalsPanelRender
local OriginalAnimalsPanelRightMouseUp
local AnimalTooltip = nil
local ContextMenuOpen = false
local SelectedAnimals = nil

---HighlightAnimal
---@param animal IsoAnimal | IsoDeadBody
---@param playerNum integer
---@param isdead boolean
local function HighlightAnimal(animal, playerNum, isdead)
    if not animal or not playerNum then return end

    local color = nil
    local basecolor, deadcolor, warningcolor, mouseovercolor, pregnancycolor = AAC.UTILS.GetColorOptions()

    if isdead then
        color = { r = deadcolor.r, g = deadcolor.g, b = deadcolor.b, a = deadcolor.a }
    elseif SelectedAnimals and SelectedAnimals == animal then
        color = { r = mouseovercolor.r, g = mouseovercolor.g, b = mouseovercolor.b, a = mouseovercolor.a }
    else
        local stress = AAC.UTILS.Round(animal:getStress(), 2)
        local health = animal:getHealth() * 100
        local hunger = AAC.UTILS.Round(animal:getHunger(), 2)
        local thirst = AAC.UTILS.Round(animal:getThirst(), 2)
        local pregnancy = animal:getData():isPregnant()

        if (stress >= 25.0 or hunger > 0.10 or thirst > 0.10 or health < 80.0) then
            color = { r = warningcolor.r, g = warningcolor.g, b = warningcolor.b, a = warningcolor.a }
        elseif pregnancy then
            color = { r = pregnancycolor.r, g = pregnancycolor.g, b = pregnancycolor.b, a = pregnancycolor.a }
        else
            color = { r = basecolor.r, g = basecolor.g, b = basecolor.b, a = basecolor.a }
        end
    end

    if color then
        animal:setOutlineHighlight(playerNum, true)
        animal:setOutlineHighlightCol(playerNum, color.r, color.g, color.b, color.a)
        animal:setOutlineHlAttached(playerNum, true)
        animal:setOutlineThickness(color.a)
    end
end

---@param ui table
local function GetAnimalsInZone(ui)
    if not ui or not ui.zone then return end
    local playerNum = ui.playerNum
    local animals = ui.zone:getAnimalsConnected()
    local deadbody = ui.zone:getCorpsesConnected()

    if animals then
        for i = 1, animals:size() do
            local animal = animals:get(i - 1)
            HighlightAnimal(animal, playerNum, false)
        end
    end

    if deadbody then
        for i = 1, deadbody:size() do
            local corpse = deadbody:get(i - 1)
            HighlightAnimal(corpse, playerNum, true)
        end
    end
end

---@param ui table
local function ClearAnimalsInZone(ui)
    if not ui or not ui.zone then return end
    local playerNum = ui.playerNum
    local animals = ui.zone:getAnimalsConnected()
    local corpses = ui.zone:getCorpsesConnected()

    if animals then
        for i = 1, animals:size() do
            local animal = animals:get(i - 1)
            if animal then
                animal:setOutlineHighlight(playerNum, false)
            end
        end
    end

    if corpses then
        for i = 1, corpses:size() do
            local corpse = corpses:get(i - 1)
            if corpse then
                corpse:setOutlineHighlight(playerNum, false)
            end
        end
    end
end

---return the button and animal for the hovered row.
---@param self table
---@return nil|ISButton
---@return nil|IsoAnimal
local function GetAnimalFromButton(self)
    if not self or not self.ui then return end

    local animalButtons = self.ui.animalbuttons
    local itemHeight = self.ui.itemHgt

    if not animalButtons or not itemHeight or itemHeight <= 0 then return end

    local row = math.floor(self:getMouseY() / itemHeight) + 1
    if row < 1 or row > #animalButtons then return end

    local button = animalButtons[row]
    if not button or not button.animal then return end

    return button, button.animal
end

---animal context menu on right click.
---@param playerNum integer
---@param animal IsoAnimal|IsoDeadBody
---@param isBody boolean
local function AnimalsContextMenu(playerNum, animal, isBody)
    if not playerNum or not animal then return end

    local context = ISContextMenu.get(playerNum, getMouseX(), getMouseY())
    if not context then return end

    local OnMouseDownOutside, OnMouseDown

    if isBody then
        ---@cast animal IsoDeadBody
        AnimalContextMenu.doAnimalBodyMenu(context, playerNum, animal)
    else
        ---@cast animal IsoAnimal
        AnimalContextMenu.doMenu(playerNum, context, animal)
    end

    if AnimalContextMenu and ContextMenuOpen then
        local ContextMenuInstance = _G["ISContextMenu"]
        OnMouseDownOutside = ContextMenuInstance.onMouseDownOutside
        OnMouseDown = ContextMenuInstance.onMouseDown

        function ContextMenuInstance:onMouseDownOutside(x, y)
            if OnMouseDownOutside then
                OnMouseDownOutside(self, x, y)
            end
            ContextMenuOpen = false
        end

        function ContextMenuInstance:onMouseDown(x, y)
            if OnMouseDown then
                OnMouseDown(self, x, y)
            end
            ContextMenuOpen = false
        end
    end
end

---return text format for tooltip
---@param animal IsoAnimal
---@return string
local function GetAnimalTooltipText(animal)
    local stress = animal:getStressTxt(false, 5)
    local health = animal:getHealthText(false, 5)
    local checkboxOptions = AAC.UTILS.GetCheckboxOptions()
    local player = getSpecificPlayer(0)
    local skillLvl = player and player:getPerkLevel(Perks.Husbandry) or 0
    local str = ""

    str = str ..
        AAC.UTILS.FormatRichText(getText("IGUI_AAC_Animal_Stress"), stress, false, nil, { r = 0.7, g = 0.9, b = 0.7 })

    str = str ..
        AAC.UTILS.FormatRichText(getText("IGUI_AAC_Animal_Health"), health, false, nil, { r = 0.8, g = 0.9, b = 0.8 })

    if animal:isFemale() then
        local showPregnancyStage = checkboxOptions['showPregnancyStage']
        local showMilkStage = checkboxOptions['showMilkStage']
        local showMatingSeason = checkboxOptions['showMatingSeason']
        local pregnancyStage = AAC.STAGE.GetAnimalPregnancyStage(animal)
        local milkStage = AAC.STAGE.GetAnimalMilkStage(animal)

        if pregnancyStage and pregnancyStage ~= "" then
            local showPregnancyTime = checkboxOptions['showPregnancyTime']

            if (showPregnancyStage or skillLvl > 2) then
                str = str ..
                    AAC.UTILS.FormatRichText(getText("IGUI_AAC_Animal_Pregnant"), pregnancyStage, false, nil,
                        { r = 0.8, g = 0.85, b = 1 })
            end

            if showPregnancyTime and pregnancyStage ~= getText("IGUI_No") then
                local pregnancyTime = AAC.STAGE.GetAnimalPregnancyTime(animal)
                str = str ..
                    AAC.UTILS.FormatRichText(getText("IGUI_AAC_Animal_Pregnancy_Time"), tostring(pregnancyTime), false,
                        nil,
                        { r = 0.8, g = 0.85, b = 1 })
            end
        end


        if milkStage and milkStage ~= "" and (showMilkStage or skillLvl > 2) then
            str = str ..
                AAC.UTILS.FormatRichText(getText("IGUI_AAC_Animal_Milk"), milkStage, false, nil,
                    { r = 1, g = 0.9, b = 0.6 })
        end

        if (showMatingSeason or skillLvl > 4) then
            local matingStatus = AAC.STAGE.GetAnimalMatingStatus(animal)

            if matingStatus then
                str = str ..
                    AAC.UTILS.FormatRichText(getText("IGUI_Animal_MatingSeason"), matingStatus, false, nil,
                        { r = 0.8, g = 0.85, b = 1 })
            end
        end
    else
        local showImpregnationReadiness = checkboxOptions['showImpregnationReadiness']

        if (showImpregnationReadiness or skillLvl > 3) then
            local matingStatus = AAC.STAGE.GetAnimalMaleImpregnateStatus(animal)

            if matingStatus then
                str = str ..
                    AAC.UTILS.FormatRichText(getText("IGUI_Animal_MatingSeason"), matingStatus, false, nil,
                        { r = 0.8, g = 0.85, b = 1 })
            end
        end
    end

    if animal:isFemale() then
        local startMonth, endMonth = AAC.STAGE.GetAnimalMonthPregnant(animal)

        if startMonth and endMonth then
            local data = {}

            for i = 1, #AAC.STAGE.CALENDAR, 1 do
                local month = i
                local highlightMonth = false

                if startMonth == 0 then
                    highlightMonth = true
                elseif startMonth <= endMonth then
                    highlightMonth = month >= startMonth and month <= endMonth
                else
                    highlightMonth = month >= startMonth or month <= endMonth
                end

                if highlightMonth then
                    data[#data + 1] = "<GREEN>" .. AAC.STAGE.CALENDAR[i]
                else
                    data[#data + 1] = "<RED>" .. AAC.STAGE.CALENDAR[i]
                end
            end

            local calendarLine = table.concat(data, " <SPACE><SPACE>")
            str = str .. " <LINE> <SETX:10> " .. calendarLine .. " <LEFT>"
        end
    end

    if animal:petTimerDone() then
        str = str ..
            " <BR> " ..
            AAC.UTILS.FormatRichText(getText("IGUI_AAC_Animal_CanBePet"), nil, true, nil, { r = 0.7, g = 0.9, b = 0.7 })
    else
        str = str ..
            " <BR> " ..
            AAC.UTILS.FormatRichText(getText("IGUI_AAC_Animal_CannotBePet"), nil, true, nil,
                { r = 0.9, g = 0.7, b = 0.7 })
    end

    return str
end

---create tooltip for animal in panel.
---@return ISToolTip
local function CreateAnimalTooltip()
    local tooltip = ISToolTip:new()

    tooltip:initialise()
    tooltip:instantiate()

    tooltip.followMouse = true

    tooltip:addToUIManager()
    tooltip:setVisible(false)

    return tooltip
end

local function BasePanel()
    local AnimalZoneUI = _G["ISDesignationZoneAnimalZoneUI"]

    if not AnimalZoneUI then return end

    local PanelInstance = _G["ISDesignationZoneAnimalZoneUI_AnimalsPanel"]

    if PanelInstance and not OriginalAnimalsPanelRender then
        OriginalAnimalsPanelRender = PanelInstance.render
        function PanelInstance:render()
            OriginalAnimalsPanelRender(self)

            local isMouseOver = self:isMouseOver()

            if isMouseOver and not ContextMenuOpen then
                local button, animal = GetAnimalFromButton(self)
                local isBody = instanceof(animal, "IsoDeadBody")

                SelectedAnimals = animal

                if not button or not animal or isBody then
                    if AnimalTooltip then
                        AnimalTooltip:setVisible(false)
                        AnimalTooltip:reset()
                    end
                else
                    local description = GetAnimalTooltipText(animal)

                    if not AnimalTooltip then
                        AnimalTooltip = CreateAnimalTooltip()
                    end

                    AnimalTooltip:setOwner(self)
                    AnimalTooltip:setDescription(description)
                    AnimalTooltip:setAlwaysOnTop(true)
                    AnimalTooltip:setVisible(true)
                end
            else
                if AnimalTooltip then
                    AnimalTooltip:setVisible(false)
                    AnimalTooltip:reset()
                    AnimalTooltip = nil
                end
            end
        end
    end

    if PanelInstance and not OriginalAnimalsPanelRightMouseUp then
        OriginalAnimalsPanelRightMouseUp = PanelInstance.onRightMouseUp
        function PanelInstance:onRightMouseUp(x, y)
            if OriginalAnimalsPanelRightMouseUp then
                OriginalAnimalsPanelRightMouseUp(self, x, y)
            end

            local button, animal = GetAnimalFromButton(self)

            if button and animal then
                local isBody = instanceof(animal, "IsoDeadBody")

                ContextMenuOpen = true
                AnimalsContextMenu(self.ui.playerNum, animal, isBody)
            end
        end
    end

    if not OriginalZoneUIRender then
        OriginalZoneUIRender = AnimalZoneUI.render
        function AnimalZoneUI:render()
            OriginalZoneUIRender(self)
            GetAnimalsInZone(self)
        end
    end

    if not OriginalZoneUIClose then
        OriginalZoneUIClose = AnimalZoneUI.close
        function AnimalZoneUI:close()
            if self.animalPanel and self.animalPanel.mouseOverAnimal then
                self.animalPanel.mouseOverAnimal:setOutlineHighlight(self.playerNum, false)
                self.animalPanel.mouseOverAnimal:setOutlineHlAttached(self.playerNum, false)
                self.animalPanel.mouseOverAnimal = nil
            end

            ClearAnimalsInZone(self)

            SelectedAnimals, ContextMenuOpen = nil, false

            if OriginalZoneUIClose then
                OriginalZoneUIClose(self)
            end
        end
    end
end

Events.OnGameStart.Add(function()
    BasePanel()
end)