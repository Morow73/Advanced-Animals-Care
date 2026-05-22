local originalZoneUIRender
local originalZoneUIUpdateAnimals
local originalAnimalsPanelRender
local originalAnimalsPanelRightMouseUp

---round a number to a specified number of decimal places
---@param value number
---@param decimals integer | nil
---@return number
local function round(value, decimals)
    decimals = decimals or 0
    local mult = 10 ^ decimals
    return math.floor(value * mult + 0.5) / mult
end

---HighlightAnimal
---@param animal IsoAnimal
---@param playerNum integer
local function HighlightAnimal(animal, playerNum)
    if not animal or not playerNum then return end

    local color = nil
    local isdead = animal:isDead()
    local stress = round(animal:getStress())
    local health = animal:getHealth() * 100
    local hunger = round(animal:getHunger(), 2)
    local thirst = round(animal:getThirst(), 2)
    local basecolor, deadcolor, warningcolor = GetColorOptions()

    if not isdead then
        if (stress >= 25.0 or hunger > 0.10 or thirst > 0.10 or health < 80.0) then
            color = { r = warningcolor.r, g = warningcolor.g, b = warningcolor.b, a = warningcolor.a }
        else
            color = { r = basecolor.r, g = basecolor.g, b = basecolor.b, a = basecolor.a }
        end
    else
        color = { r = deadcolor.r, g = deadcolor.g, b = deadcolor.b, a = deadcolor.a }
    end

    if color then
        animal:setOutlineHighlight(playerNum, true)
        animal:setOutlineHighlightCol(playerNum, color.r, color.g, color.b, color.a)
        animal:setOutlineHlAttached(playerNum, true)
        animal:setOutlineThickness(0.5)
    end
end

---@param ui table
local function GetAnimalsInZone(ui)
    if not ui or not ui.zone then return end
    local playerNum = ui.playerNum
    local animals = ui.zone:getAnimalsConnected()

    if animals then
        for i = 1, animals:size() do
            HighlightAnimal(animals:get(i - 1), playerNum)
        end
    end

    --[[
    local hutches = ui.zone:getHutchsConnected()
    if hutches then
        for i = 1, hutches:size() do
            local hutch = hutches:get(i - 1)
            if hutch and hutch.getAnimalInside then
                local inside = hutch:getAnimalInside()
                if inside then
                    local values = inside:values()
                    for j = 1, values:size() do
                        HighlightAnimal(values:get(j - 1), playerNum)
                    end
                end
            end
        end
    end]]
end

---draw to ranch panel.
---@param self table
local function AddDrawToPanel(self)
    if not self.ui or not self.ui.animalbuttons then return end

    self:setStencilRect(0, 0, self:getWidth(), self:getHeight())

    for _, button in ipairs(self.ui.animalbuttons) do
        local animal = button.animal

        if animal and button.isVisible and button:isVisible() then
            if not animal.getData then return end

            local def = ""
            local y = button:getY() + (button:getHeight() - getTextManager():getFontHeight(UIFont.Small)) / 2
            local baseX = button:getRight() + 8
            local healthX = baseX
            local pregnancyX = baseX + 100
            local petX = baseX + 220
            local healthTxt = animal:getHealthText(false, 5)

            if healthTxt and healthTxt ~= "" then
                self:drawText(healthTxt, healthX, y, 1, 1, 1, 1, UIFont.Small)
            end

            if animal.isFemale and animal:isFemale() then
                local status = GetAnimalPregnancyStage(animal)
                if status and status ~= "" then
                    self:drawText(status, pregnancyX, y, 1, 1, 1, 1, UIFont.Small)
                end
            end

            if animal:petTimerDone() then
                def = getText("IGUI_AAC_Animal_CanBePet")
            else
                def = getText("IGUI_AAC_Animal_CannotBePet")
            end

            if def ~= "" then
                local defWidth = getTextManager():MeasureStringX(UIFont.Small, def)
                local defX = math.min(petX, self:getWidth() - defWidth - 12)
                self:drawText(def, defX, y, 1, 1, 1, 1, UIFont.Small)
            end
        end
    end

    self:clearStencilRect()
end

---animal context menu on right click.
---@param self table
local function AnimalsContextMenu(self)
    if not self or not self.ui then return end
    local animalButtons = self.ui.animalbuttons
    local itemHeight = self.ui.itemHgt
    local playerNum = self.ui.playerNum
    if not animalButtons or not itemHeight or itemHeight <= 0 or not playerNum then return end

    local row = math.floor(self:getMouseY() / itemHeight) + 1
    if row < 1 or row > #animalButtons then return end

    local button = animalButtons[row]
    if not button or not button.animal then return end

    local context = ISContextMenu.get(playerNum, getMouseX(), getMouseY())
    if not context then return end

    AnimalContextMenu.doMenu(playerNum, context, button.animal)
end

local function BasePanel()
    local AnimalZoneUI = _G["ISDesignationZoneAnimalZoneUI"]
    local PanelInstance = _G["ISDesignationZoneAnimalZoneUI_AnimalsPanel"]

    if not AnimalZoneUI then return end

    if PanelInstance and not originalAnimalsPanelRender then
        originalAnimalsPanelRender = PanelInstance.render
        function PanelInstance:render()
            originalAnimalsPanelRender(self)
            AddDrawToPanel(self)
        end
    end

    if PanelInstance and not originalAnimalsPanelRightMouseUp then
        originalAnimalsPanelRightMouseUp = PanelInstance.onRightMouseUp
        function PanelInstance:onRightMouseUp(x, y)
            if originalAnimalsPanelRightMouseUp then
                originalAnimalsPanelRightMouseUp(self, x, y)
            end
            AnimalsContextMenu(self)
        end
    end

    --[[if not originalZoneUIInitialise then
        originalZoneUIInitialise = AnimalZoneUI.initialise
        function AnimalZoneUI:initialise()
            originalZoneUIInitialise(self)
            highlightZoneAnimals(self)
        end
    end

    if not originalZoneUIPreRender then
        originalZoneUIPreRender = AnimalZoneUI.prerender
        function AnimalZoneUI:prerender()
            originalZoneUIPreRender(self)
            highlightZoneAnimals(self)
        end
    end]]

    if not originalZoneUIRender then
        originalZoneUIRender = AnimalZoneUI.render
        function AnimalZoneUI:render()
            originalZoneUIRender(self)
            GetAnimalsInZone(self)
        end
    end

    if not originalZoneUIUpdateAnimals then
        originalZoneUIUpdateAnimals = AnimalZoneUI.updateAnimals
        function AnimalZoneUI:updateAnimals()
            originalZoneUIUpdateAnimals(self)
            GetAnimalsInZone(self)
        end
    end
end

Events.OnGameStart.Add(BasePanel)
Events.OnInitWorld.Add(BasePanel)
Events.OnGameStart.Add(function()
end)
