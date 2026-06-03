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
- `mouseOverColor`:mouse hovers over a line in the ranch panel
- `pregnancyColor `: pregnant animal

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
- calendar for breeding season

Some tooltip information is shown only when the player has sufficient Breeding skill or when the related display option is enabled.

### Context Menu Support

Right-clicking an animal or dead body entry in the animal panel opens the standard in-game animal context menu while hiding the tooltip appropriately.

## Configuration

The mod adds options to the mod settings menu:

- customizable colors:
  - base animal color
  - dead animal color
  - warning animal color
  - mouseover animal color
  - pregnancy animal color
- optional display settings:
  - show pregnancy stage
  - show milk stage
  - show breeding season
  - show impregnation readiness
  - show remaining gestation period

## Metadata

- Name: Advanced Animals Care
- ID: advancedanimalscare
- Version: 1.3.2
- Compatible from: 42.17 +

**Steam workshop link** [Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=3730587949).
