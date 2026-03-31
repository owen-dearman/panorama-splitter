# Panorama Splitter

Panorama Splitter is a Windows desktop app (Delphi VCL) that converts a panoramic image into multiple slices for carousel-style posts.

It supports:

- Instagram preset export sizes
- Fill vs Fit behavior
- Padding styles (including blurred padding)
- Black & white export mode
- Adjustable vertical crop anchor
- Non-Instagram ratio mode
- Preview of final slices before export
- Persistent user settings via INI
- Configurable presets/ratios/blur levels via JSON

---

## Run the app

The executable is already built in the repository.

- Run: `PanoramaSplitter.exe`

If Windows blocks the app because it came from another machine, right-click the `.exe` -> **Properties** -> **Unblock** (if shown), then run again.

---

## Files and persistence

- Runtime settings (theme, selected options, output folder) are saved to:
  - `%USERPROFILE%\AppData\Roaming\PanoramaSplitter\PanoramaSplitter.ini`
- App configuration data (editable without rebuild) is loaded from:
  - `PanoramaConfig.json` (in app/repo folder)

---

## Typical workflow

1. Click **Load Panorama** and select an image.
2. Adjust options in **Export settings**.
3. Use preview panel + green split guides to validate composition.
4. Optionally click **Preview Output** to inspect each generated slice.
5. Choose output folder (bottom field / Browse).
6. Click **Split & Save**.

---

## Export settings explained

### Segments
How many images the panorama is split into.

- Controlled by slider.
- More segments = narrower slices.

### Use Instagram preset
When enabled, export dimensions are based on Instagram-style dimensions from config.

When disabled, app uses native width split behavior and optional non-Instagram ratio.

### Preset
Target per-slice dimensions for Instagram mode (from `PanoramaConfig.json`).

Examples:
- Portrait 4:5
- Square 1:1
- Landscape 1.91:1

### Insta mode
Available when Instagram preset is enabled.

- **Fill (crop)**  
  Scales image to fully fill the target canvas and crops overflow.
- **Fit (no crop, pad)**  
  Keeps full image visible and adds padding to match target size.

### Pad style
Available in Instagram **Fit** mode.

- **Black**
- **White**
- **Blurred** (uses selected blur level)

### Blur level
Visible only when pad style is **Blurred**.
Controls blur intensity used for padded background.
Levels are loaded from `PanoramaConfig.json`.

### Output colour
- **Colour**
- **Black and White**

### Ratio (non-Instagram)
Enabled when **Use Instagram preset** is unchecked.

Applies selected aspect ratio from config to non-Instagram output behavior.

### Vertical crop
Controls top/bottom crop anchor (0 = top, 100 = bottom) when cropping is active.

You can also drag vertically on the preview to adjust crop anchor (when crop-capable mode is active).

---

## Preview and guides

- Main preview reflects current export options.
- Green vertical guide lines indicate split boundaries.
- **Fit to screen**, **Zoom +**, **Zoom -** available above preview.

---

## Menus

### File
- Load Panorama
- Select Output Folder
- Split & Save
- Theme -> Light / Dark
- Exit

### View
- Fit to Screen
- Zoom In / Zoom Out

### Export
- Colour / Black and White quick toggle

---

## Output naming

Slices are saved as PNG in selected output folder, using source filename with numeric suffix:

- `<name>_01.png`
- `<name>_02.png`
- ...

Number padding adjusts automatically by segment count.

---

## Configuring options without rebuild

Edit `PanoramaConfig.json` to control:

- `maxSegments`
- `instagramPresets`
- `ratioOptions`
- `blurLevels`
- `defaultBlurLevelIndex`

After editing JSON, restart the app to load changes.

---

## Notes

- JPEG EXIF metadata is parsed when available and shown in metadata panel.
- If output folder does not exist, app creates it automatically.
- If quality warning appears, selected settings require upscaling (possible quality loss).
