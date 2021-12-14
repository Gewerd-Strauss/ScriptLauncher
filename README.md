# ScriptLauncher - First startup

A simple, no fuss launcher for AutoHotKey-Scripts.

At startup, you will be asked to edit an ini-file containing the entire configuration of this script.
By default, you will encounter this template:

    [Insert Folders to INCLUDE below]
    [Insert Script-Names of Scripts in added Folders to Exclude below]
    [Insert Paths to Scripts to INCLUDE below]
    [Script Behaviour Settings]
    bShowTooltips=1
    bHideOnLaunchScript=0
    bHideOnEditScript=1
    bHideOnOpenFolder=1
    bHideOnKillScript=0
    bHideOnSettingsOpened=1
    bBetaVersionSuspend=1

Each section has its own behaviour.
Every entry must be on its own line, regardless of section.

### 1. "Insert Folders to INCLUDE below"

Pretty self-explanatory. All `.ahk`-files in any folder path you add below are added to the gui. Entries are sorted alphabetically.

### 2. "Insert Script-Names of Scripts in added Folders to Exclude below"

If there are specific scripts in the folders added above that you don't want to add, add their names here.

### 3. "Insert Paths to Scripts to INCLUDE below"

Insert any script path to a specific script to include, even if you don't want to include the entire directory.

### 4. "Script Behaviour Settings"

| Setting| Meaning | Default |
   | :-----------------|:-------------:|:-----:|
   | bShowTooltips | Display Tooltips on meaning of any button | 1/On
   | bHideOnLaunchScript | Hide Launcher at scriptstart | 0/Off
   | bHideOnEditScript | Hide Launcher when opening the launcher in editor | 1
   | bHideOnOpenFolder | Hide Launcher when showing any script in folder | 1/On
   | bHideOnKillScript | Hide Launcher when stopping any script | 0
   | bHideOnSettingsOpened | Hide Launcher when opening the settings file | 1
   | bAddSuspendButtons | Add "Suspend [ScriptName]"-buttons for each script | 1
   
   
   
   # Known Bugs
   
   - when disabling Suspend-Buttons, currently the wrong buttons get disabled when disabling buttons belonging to scripts which are not running. Keep the settings at default until I've fixed this.
   
   
 MISSING IN DOCUMENTATION:
   
* Bottom Buttons explanation
