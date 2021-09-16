# Plutonium Mod Menu Black Ops 2

## Installation

### 1. Install the Mod Menu

  * Install Black Ops 2 Plutonium
    * Download [Plutonium](https://plutonium.pw/docs/install/)
    * Download [Black Ops 2](https://drive.google.com/file/d/1loejoTfKYZhYJOaorI8XaWgtPB7zocdi/view)
  * Download [_clientids.gsc](https://github.com/jcsalinas20/Plutonium-Mod-Menu-Black-Ops-2/releases/)
  * Open the folder `{BlackOps2_folder}\t6r\data\maps\mp\gametypes\`
  * Paste the `_clientids.gsc` in the folder

### 2. Get your GUID

  * Play Black Ops 2 and start a custom game
  * Open the Mod Menu with:
    * PC: `Right click in mouse + V`
    * PlayStation: `L2 + R3`
    * Xbox: `?? + ??`
  * Go to `My Player > Get GUID` and note the green text
  
  ![imagen](http://imgfz.com/i/FsiyQDY.png)

### 3. Put the GUID in the code

  * Download and install [GSC Studio](https://github.com/jcsalinas20/GSC-Studio-BO2-Documentation/blob/main/z-setup-gscstudio.exe)
  * Download the [Project Code](https://github.com/jcsalinas20/Plutonium-Mod-Menu-Black-Ops-2/archive/refs/heads/main.zip) and unzip the project
  * Open the project in GSC Studio `EDITOR > Open project`
  * Go to the `main.gsc` file and change the line
  ```c++
  24. SetDvarIfNotInizialized("superadmins_list", "Your GUID");
  25. SetDvarIfNotInizialized("owners_list", "Your GUID");
  ```

### 4. Final instalation

  * Now export the project in `EDITOR > Export the project to a compiled script file...`
  * Then select `PC` and `Export now`
  * Go to `{BlackOps2_folder}\t6r\data\maps\mp\gametypes\` and replace the file `_clientids.gsc`
  * Now you can play with the Mod Menu

## Documentation

  [Documentation Link](https://github.com/jcsalinas20/GSC-Studio-BO2-Documentation)
  
## Controls

  * Open: `Right click in mouse + V`
  * Select: `Space`
  * Go back and Close: `F`
  * Up: `1`
  * Down: `2`
