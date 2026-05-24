# Advanced Animals Care

Advanced Animals Care is a quality-of-life mod for Project Zomboid that improves the animal management interface for ranches and pens.

## Overview

This mod enhances the animal zone user interface by providing:

- visual highlighting for animals and corpses within the animal zone
- a detailed tooltip for each animal in the animal panel
- improved behavior for the animal context menu on right-click

## Features

### Animal Highlighting

Animals connected to the animal zone are highlighted with different colors based on their state:

- `baseColor`: normal animal
- `warningColor`: stressed, hungry, thirsty, or low-health animal
- `deadColor`: dead animal / corpse

These highlights are applied automatically during UI rendering and zone updates, and removed when the animal zone UI closes.

### Enhanced Animal Tooltip

Hovering over an animal entry in the panel shows a tooltip with additional information, including:

- stress
- health
- pregnancy stage (for females)
- milk stage / udder status
- mating season status
- impregnation readiness or male fertilization status
- whether the animal can be petted

Some tooltip information is shown only when the player has sufficient Husbandry skill or when the related display option is enabled.

### Context Menu Support

Right-clicking an animal or dead body entry in the animal panel opens the standard in-game animal context menu while hiding the tooltip appropriately.

## Configuration

The mod adds options to the mod settings menu:

- customizable colors:
  - base animal color
  - dead animal color
  - warning animal color
- optional display settings:
  - show pregnancy stage
  - show milk stage
  - show mating season
  - show impregnation readiness

## Metadata

- Name: Advanced Animals Care
- ID: advancedanimalscare
- Version: 1.1
- Compatible from: 42.17 +

**Steam workshop link** [Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=3730587949).

![Screenshot](https://cdn.discordapp.com/attachments/930064411035590699/1507309639857999883/image.png?ex=6a116efe&is=6a101d7e&hm=3857435e6dbb0144a8bcfd49915f3a083767502940748d3ca0620a5a5349ac38&)