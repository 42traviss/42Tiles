<img width="975" height="255" alt="obraz" src="https://github.com/user-attachments/assets/b27fe496-c16a-40df-acc9-028fe7125764" />

GameMaker **LTS 2026** IDE plugin (Windows).
An extension of the native autotile tools: tile groups, overload rules, faster autotile-set fill, and room paint that can pick variants from those groups.
Works with existing tilesets and tile layers.

Currently tested only on Windows (LTS 2026).

Source (not required to install): [42Tiles-dev](https://github.com/42piotrnycz/42Tiles-dev).

## Features

- **Auto-Assign** - fill a native 47-tile (blob) or 16-tile (cardinal) set from one start tile. Wrap width and **Skip first** sit under Auto Tile Templates. Wrap and Skip first are remembered per tileset.
- **Groups & Rules** - one window: **Rules** on the left, **Groups** on the right. Opens floating, or docked as a workspace tab (Preferences).
- **Tileset groups** - named bags of *any* tileset tiles. Left-click add/remove, Shift+click a range, right-click priority 1 / 2 / 3. Copy, Paste, and Copy to… move groups between tilesets.
- **Overload rules** - paint like GameMaker’s 47 or 16 autotile (from the set’s tile count). A slot can use a random tile from a group instead of the set tile.
- **Room paint** - **Auto Tile with Rules** next to native Auto Tile. Same brush size as the Tiles panel, with a hover preview. Native Auto Tile is unchanged.
- **Library badges** - red **R** on autotile sets that have rules; green **G** on tilesets (and their sets) that have groups. Same badges in the room Auto Tile Library.
- **Saved with the tileset** - groups, rules, wrap, Skip first, and Hide empty live in `Name.yyplugin` next to the tileset `.yy`. The native `.yy` is not edited.
- **Preferences** - **File → Preferences → 42Tiles** or **Plugins → 42Tiles**. Per-project defaults in `Name.yyplugin` next to the `.yyp`. Enable does not need an IDE restart.
- **Runtime groups** - generated script `__42Tiles` with `tile_group_get_all`, `tile_group_get_names`, and `tile_group_get`.

## How to use

### Auto-Assign

1. Open a tileset and switch to **Auto Tiling**.
2. Under Auto Tile Templates, set wrap width (tiles to the right before wrapping down). A new tileset uses the Preferences default until you change wrap here; after that this tileset keeps its own value.
3. Turn on **Skip first** if the strip starts with the empty tile and you want slot 0 to be the next one. Same as wrap: Preferences default, then remembered per tileset.
4. Click **Auto-Assign** → **Fill 47** or **Fill 16**, then click the start tile on the left Tiles panel.

<img width="869" height="480" alt="Auto-Assign under Auto Tile Templates" src="https://github.com/user-attachments/assets/23bdeec3-65f1-4a5e-9478-f66ca0d056fc" />

### Groups & Rules

1. Select an autotile set in the library. Click **Groups & Rules** (tileset Auto Tiling library, or Room Editor → Libraries → Auto Tile Library).

<img width="339" height="460" alt="Groups & Rules button in the Auto Tiling library" src="https://github.com/user-attachments/assets/45ceadc1-f937-484c-aa7c-bf96bb6c4135" />

2. **Right pane (Groups)**
   - **Add group**, name it, click tiles to include them.
   - Shift+click adds every shown tile from the last click to this one.
   - Right-click a selected tile to cycle priority 1 / 2 / 3.
   - **Hide empty tiles** hides blank cells. Remembered per tileset; Preferences is the default until you toggle it here.
   - **Copy** copies the selected group. Click the selected group again to clear the selection, then Copy copies all groups.
   - **Paste** inserts copies into this tileset (new ids, unique names).
   - **Copy to…** picks another tileset and pastes there. Tiles past the destination sheet are dropped.
   - **Refresh** reloads thumbs after you edit the tileset image.

3. **Left pane (Rules)**
   - **Add** an Overload rule.
   - For each autotile slot, click to cycle “set tile” → next group.
   - **Apply** saves the name; slot assignments save as you click.
   - **Remove** deletes the selected rule.

A 47-tile set paints as blob autotile; a 16-tile set paints as cardinal. No group on a slot means that slot keeps the set’s own tile.

<img width="1490" height="725" alt="Groups & Rules window" src="https://github.com/user-attachments/assets/59a6d188-c587-4cb5-868d-c65a7a06cbe4" />

### Paint in a room

1. Open a room, select a tile layer, and pick an autotile set that has rules (red **R**). Tilesets with groups show a green **G**.

<img width="315" height="245" alt="obraz" src="https://github.com/user-attachments/assets/eaad783b-58ca-45bb-96cd-4ca8cd770675" />

2. Click **Auto Tile with Rules** in the tile tools (next to native Auto Tile). Choosing a native tool exits Rules.

<img width="740" height="247" alt="Auto Tile with Rules tool" src="https://github.com/user-attachments/assets/16abe60f-f77b-4385-917a-92f8243fb23f" />

3. Paint or erase. Brush size matches the Tiles panel. Hover shows a preview of the stamp.

<img width="812" height="620" alt="Rules paint with hover preview" src="https://github.com/user-attachments/assets/99ac7199-02db-48da-a0c5-2cf335ec7b49" />

### Groups in GML

42Tiles adds (and writes to) a script named `__42Tiles`. 
Do not edit it. After you change groups, save the project or keep the Groups window open; the script updates automatically.

```gml
var _all = tile_group_get_all(ts_ground);
// _all[$ "grass"].tiles / .priorities
var _names = tile_group_get_names(ts_ground);
var _group = tile_group_get(ts_ground, "grass");
// _group.tiles        - tile indices in the group
// _group.priorities   - 1 often / 2 medium / 3 rare, parallel to tiles
```

Missing tileset or group name returns `{}` / `[]` / `undefined`.

### Preferences

**File → Preferences → 42Tiles**, or **Plugins → 42Tiles**. Settings are per project (`Name.yyplugin` next to the `.yyp`). Apply or OK writes them; Enable does not need a GameMaker restart.

| Option | What it does |
|---|---|
| **Enable 42Tiles** | Turns Auto-Assign, Groups & Rules, and room paint off for this project. |
| **Default wrap width** | Auto-Assign wrap on a tileset that has no wrap saved yet. |
| **Hide empty tiles by default** | New Groups & Rules windows, until you change it for that tileset. |
| **Skip first by default** | New Auto-Assign bars, until you change it for that tileset. |
| **Open Groups & Rules docked** | Workspace tab when on, floating window when off. Applies the next time you open the window. |

Changing wrap, Skip first, or Hide empty in a tileset editor writes that tileset’s sidecar and does not change these project defaults.

<img width="631" height="415" alt="File → Preferences → 42Tiles" src="https://github.com/user-attachments/assets/a61cc25c-0258-4efa-8de8-e50326e87bb1" />

## Install

## ⚠️ WARNING! Save your work and, preferably, make a backup before installation!
The instalation process requires GameMaker to be closed, and the script closes
GM on it's own!

Requires [GameMaker LTS 2026](https://gamemaker.io/).

1. Download this repository (**Code → Download ZIP**) or a [release](https://github.com/42piotrnycz/42Tiles/releases).
2. Close GameMaker.
3. Run `build\manual-install.ps1`:

```powershell
powershell -ExecutionPolicy Bypass -File build\manual-install.ps1
```

4. Launch GameMaker LTS 2026.

The `build\` folder has `42Tiles.dll` and `42Tiles.gmplugin` next to the installer.

## Uninstall

```powershell
powershell -ExecutionPolicy Bypass -File build\manual-uninstall.ps1
```

## AI disclosure

This plugin was created with the help of AI.
There is currently no official pipeline to create GameMaker plugins, so it can (and probably will) break with major IDE updates.
Nonetheless, it's a powerful tool, and progress made with it should still carry over, even after the plugin breaks/is uninstalled.

Not affiliated with, endorsed by, or maintained by YoYo Games. Report bugs on [this repository’s issues](https://github.com/42piotrnycz/42Tiles/issues), never to YoYo Games.

## License

MIT - see [LICENSE](LICENSE).
