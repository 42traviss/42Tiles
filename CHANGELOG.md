# Changelog

## v0.2.1 - 2026-09-09

### Added

- Groups & Rules is four columns: **Select**, **Rules**, **Tile Groups**, and **Tile List**. Columns use native Auto Tiling collapsible, resizable splitters. File → Preferences → 42Tiles stores an opening width for each column (defaults 200 / 200 / 200 / 520).
- **Tilesets** picker in the Select column. Library and picker rows show the first tile that has graphics.
- **Show Guide Overlay** in the Rules column (native Auto Tiling guide icon). When on, each slot shows the set tile beside that index's guide cell.
- Tile List **Highlight** and **Highlight current autotile library element**.
- Groups can be **Local** to one autotile library element or shared on the tileset. **Show only local** filters the list. **Keep tileset order** (default on) lists tiles by index; with **Hide empty tiles**, only fully empty sprite rows are omitted so columns stay aligned.
- Groups & Rules opens on the **current Workspace**: it pans with the workspace and can be docked next to Workspaces. Uncheck the prefs option to float.
- Runtime script `__42TilesData` (`__42tiles_data()`). Groups **Save** rewrites only that script.
- **Auto Tile with Rules** sits in its own dock next to the native pencil strip, on the far right of the room bar, and only when a tile layer is selected.
- Plugins menu lists 42Tiles first, then a separator. The Preferences category sorts to the bottom. Disclaimer and issues link on the 42Tiles prefs page.

### Changed

- Tile previews stay inside a scroll panel and no longer draw over Add / Delete / Copy / Paste / Refresh / Save. The grid uses the tileset sprite's own column count; the pane scrolls if that is wider than the window.
- Adding a group no longer writes GML. Use **Save** on the tiles column, or save the project.
- `__42Tiles` is created only if it is missing, or rewritten once if it still defines `__42tiles_data` (the 0.2.0 combined file). `__42TilesData` writes atomically. Rules are stored by autotile set index and name, so two sets with the same name no longer share a rule bag.

### Fixed

- Room editor no longer hitchs on large rooms while Rules paint is unused.
- Starting the IDE with a room already open in another workspace no longer hitchs the whole IDE.
- Ctrl+Z undoes an Auto Tile with Rules stroke.
- Clicking a library element or tileset keeps the latest bind. The overlay toggle and Tile List reuse existing gadgets instead of rebuilding the window.

### Known issues

- **Auto Tile with Rules** does not appear in File → Preferences → Redefine Keys. The default **Q** shortcut does not select the tool. Use the room tile-tool button instead.

## v0.2.0

- 42Tiles for GameMaker LTS 2026 (Windows).
- Auto-Assign fills a native 47- or 16-tile autotile set from one start tile.
- Groups & Rules window, with Copy / Paste / Copy to… between tilesets.
- Auto Tile with Rules in the room editor, with brush size and hover preview.
- Groups and rules saved in the tileset `Name.yyplugin` sidecar.
- Preferences under File → Preferences → 42Tiles (or Plugins → 42Tiles).
- Enable / Skip first / Hide empty tiles are per project (`Name.yyplugin` next to the `.yyp`).
- Generated `__42Tiles` GML script with `tile_group_get_all` / `tile_group_get_names` / `tile_group_get`.
- Default wrap width, Hide empty / Skip first as defaults for new tilesets; wrap, Skip first, and Hide empty are then remembered per tileset.
- Open Groups & Rules docked vs floating. Shift+click range-add in the group tile grid. Green **G** library badge when a tileset has groups.
