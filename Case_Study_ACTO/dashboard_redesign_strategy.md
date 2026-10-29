# Performance Insights Dashboard: End-to-End UX/UI Redesign Guide

As a Visualization & Tableau expert of 15 years, transforming a cluttered dashboard into an executive-ready analytics experience requires establishing a clean grid hierarchy, eliminating visual noise, and adopting modern layout patterns (like collapsible filter drawers).

Below is the complete, end-to-end master strategy and blueprint for redesigning the **Performance Insights** dashboard in Tableau Desktop.

---

## Phase 1: Grid Layout, Spacing & Container Hierarchy

To eliminate visual clutter and create a modern "card" layout, we use a dual-layer color system and strict padding rules.

### 1. Canvas & Container Setup
* **Set Fixed Canvas Size:** In the Dashboard pane, change **Size** to **Fixed Size** (e.g., `1440 x 900` or `1920 x 1080`). Avoid "Automatic" as it distorts padding on different screens. - done
* **Set Canvas Background Color:** Go to **Format > Dashboard Shading** and set the **Default Dashboard Background** to a light cool gray (`#F1F5F9`). This gray will form the gutters between your chart cards. - done
* **Build the Row Hierarchy:** Drag a main **Vertical Container** onto the canvas. Inside it, drop **Horizontal Containers** for each visual row:
  * **Row 0 (Header/Title Row):** A dedicated horizontal container (`Height: 60px`) placed at the very top.
    * Left: `ACTO Logo` + `Show/Hide Filter Toggle Button` (`[ ≡ Filters ]`)
    * Center: `Performance Insights` Title (Bold 20pt, centered) - done (used 28 font)
    * Right: Lightbulb/Insight Icon (`💡`) + optional Last Refresh Date text - done (not needed)
  * **Row 1:** *Sales Quota Trend* | *Rep Sales Quota & Training Score* | *Coach Sales Quota & Training Score* -done -skip for now since still building layout
  * **Row 2:** *Sales Quota By Territory & Team* | *Sales Quota By Product* | *Sales Quota By Experience* | *Sales Quota Experience Distribution* -done -skip for now since still building layout

### 2. Formatting Charts into Modern "Cards"
For every worksheet in your layout:
1. Select the worksheet and open the **Layout** tab on the left sidebar.
2. Change **Background** to solid **White (`#FFFFFF`)**.
3. Set **Outer Padding** to **8px** (locked). This creates uniform gray spacing/gutters around every visual widget.
4. Set **Inner Padding** to **6px** (locked). This prevents text, axis titles, and numbers from touching the border edges.

---

## Phase 2: Building the Grouped Vertical Filter Sidebar

Instead of crowding 9 individual dropdowns across the top header row, move them into a single, floating side panel toggled by a show/hide button.

### 1. Construct the Floating Sidebar Container
1. Drag a **Floating Vertical Container** onto your dashboard canvas.
2. In the **Layout** tab, set its precise positioning:
   * **X:** `0`
   * **Y:** `0`
   * **Width:** `260px`
   * **Height:** Match full canvas height (e.g., `900px`).
3. Set its **Background** color to dark slate (`#1E293B`) or a clean light gray (`#E2E8F0`) to distinguish it from the main workspace.

### 2. Group the 9 Filters with Section Headers
Inside the floating container, stack your 9 filters sequentially, separated by **Text Objects** functioning as category headers:

```text
┌─────────────────────────────────────────────────┐
│ [ ✕ CLOSE FILTERS ]                             │
├─────────────────────────────────────────────────┤
│ DASHBOARD SCOPE                                 │  <-- Text Object (Bold 10pt)
│ ─────────────────────────────────────────────── │  <-- 1px Blank Container (Line)
│ • Year                 [ (All)              ▼ ] │
│ • Quarter              [ (All)              ▼ ] │
│                                                 │
│ GEOGRAPHY & TEAM                                │  <-- Text Object (Bold 10pt)
│ ─────────────────────────────────────────────── │
│ • Territory            [ (All)              ▼ ] │
│ • Team                 [ (All)              ▼ ] │
│ • Manager Name         [ (All)              ▼ ] │
│ • Name                 [ Search Rep...      ▼ ] │
│                                                 │
│ SEGMENTATION                                    │  <-- Text Object (Bold 10pt)
│ ─────────────────────────────────────────────── │
│ • Experience Bands     [ (All)              ▼ ] │
│ • Status               [ Active             ▼ ] │
│ • Assigned Product     [ (All)              ▼ ] │
│                                                 │
├─────────────────────────────────────────────────┤
│ [ 🔄 RESET ALL FILTERS ]                        │  <-- Worksheet Button at Bottom
└─────────────────────────────────────────────────┘
```

### 3. Add the Show/Hide Toggle Button
1. Click the top border handle of the sidebar container, click its drop-down arrow ($\blacktriangledown$), and select **Add Show/Hide Button**.
2. Position the generated button inside the **Row 0 Header Container** right next to the **ACTO** logo.
3. **Button Settings:**
   * **Shown State (Panel Open):** Set image/icon to a clean `"✕ Close"` icon.
   * **Hidden State (Panel Closed):** Set image/icon to a styled `"Filters 💽"` button.

---

## Phase 3: Building the "Reset All Filters" Button

Because users can easily get lost when making multiple selections across 9 filters, build a dedicated 1-click reset button at the bottom of the sidebar panel.

### Step 1: Create the Reset Button Sheet
1. Open a new worksheet tab and name it `Reset Button`.
2. Create a Calculated Field named `Reset Label` with the formula: `"🔄 Reset All Filters"`.
3. Drag `Reset Label` to the **Text** mark card.
4. Format the worksheet: Center the text, set a subtle rounded border/background color, hide headers, and clear all gridlines.

### Step 2: Add to Sidebar
Drag the `Reset Button` worksheet to the **very bottom of your floating vertical sidebar container**.

### Step 3: Configure Dashboard Action
1. On your main dashboard, go to **Dashboard > Actions > Add Action > Filter**.
2. Name it **Reset All Filters Action**.
3. **Source Sheet:** Check only `Reset Button` (Run action on: **Select**).
4. **Target Sheets:** Check all main visual worksheets (*Sales Quota Trend*, *Rep Sales Quota & Training Score*, *Sales Quota By Territory & Team*, etc.).
5. **Target Filters:** Select **All Fields**.
6. **Clearing Selection:** Set to **Show all values**.

---

## Phase 4: Final Workspace Visual Flow

When implemented, your dashboard operates in two distinct, high-performance states:

### State 1: Sidebar Closed (Maximum Canvas Real Estate)
```text
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│ [ACTO LOGO]  [ ≡ Filters ]        P E R F O R M A N C E   I N S I G H T S          💡   │  <-- Row 0 Header
├─────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                         │
│  ┌──────────────────────────────┐  ┌─────────────────────────────────────────────────┐  │
│  │ Sales Quota Trend            │  │ Rep Sales Quota & Training Score                │  │
│  │ [ White Card ]               │  │ [ White Card - Docked, No Floating Border ]     │  │
│  └──────────────────────────────┘  └─────────────────────────────────────────────────┘  │
│                                                                                         │
│  ┌───────────────┐  ┌───────────────┐  ┌───────────────────────┐  ┌──────────────────┐  │
│  │ Quota Territory│  │ Quota Product │  │ Quota Experience      │  │ Experience Dist. │  │
│  │ [ Heatmap ]   │  │ [ Treemap ]   │  │ [ Sorted Bar Chart ]  │  │ [ Box Plot ]     │  │
│  └───────────────┘  └───────────────┘  └───────────────────────┘  └──────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────────────────┘
```

### State 2: Sidebar Open (Focused, Grouped Filtering Drawer)
```text
┌───────────────────────────┬─────────────────────────────────────────────────────────────┐
│ [ ✕ CLOSE ]               │ [ACTO LOGO]        P E R F O R M A N C E   I N S I G H T S  │
├───────────────────────────┼─────────────────────────────────────────────────────────────┤
│ DASHBOARD SCOPE           │                                                             │
│ • Year / Quarter          │  ┌──────────────────────────────┐  ┌──────────────────────┐ │
│                           │  │ Sales Quota Trend            │  │ Rep Sales Quota...   │ │
│ GEOGRAPHY & TEAM          │  └──────────────────────────────┘  └──────────────────────┘ │
│ • Territory / Team        │                                                             │
│ • Manager / Name          │  ┌───────────────┐  ┌───────────────┐  ┌──────────────────┐ │
│                           │  │ Quota Territory│  │ Quota Product │  │ Experience Dist. │ │
│ SEGMENTATION              │  └───────────────┘  └───────────────┘  └──────────────────┘ │
│ • Experience / Status...  │                                                             │
│                           │                                                             │
│ [ 🔄 RESET ALL FILTERS ]  │                                                             │
└───────────────────────────┴─────────────────────────────────────────────────────────────┘
```

---

## Summary of Improvements Achieved

1. **Structured Header (Row 0):** Establishes a clean top bar housing the logo, toggle button, dashboard title, and quick-insight indicator in an aligned horizontal row.
2. **Reclaimed Height:** Eliminates the horizontal 9-dropdown header block, freeing up ~120px of vertical height for your visual charts.
3. **Cognitive Organization:** Groups 9 filters into 3 logical categories (**Scope**, **Geography & Team**, **Segmentation**) so users can find specific parameters in seconds.
4. **Card Aesthetic:** Light gray background + white cards + 8px outer padding creates clear visual separation between charts without adding heavy border lines.
5. **Error Recovery:** A single action-wired reset button restores all views instantly.