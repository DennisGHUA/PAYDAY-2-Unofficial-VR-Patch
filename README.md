**Recommended to be used with the updated version of the payday2-vr-improvements / vrplus:**  
https://github.com/DennisGHUA/payday2-vr-improvements

This version is a continuation of the following repository:  
Version 1.4 (2020)  
https://modworkshop.net/mod/27138  
https://github.com/Lolnoobwut1/PAYDAY-2-Unofficial-VR-Patch

# PAYDAY-2-Unofficial-VR-Patch
Unofficial patch for the VR version of PAYDAY 2

This mod aims to fix longstanding issues with the mostly-neglected VR version of the game.  
I've been working on it occasionally for the past year or so, and it's still a work-in-progress until I manage to iron out most (if not all) of the VR bugs in the vanilla game.  

The full list of changes can be found below:  

Additions:
* Enabled the following weapons for VR usage: Light Crossbow, Heavy Crossbow, Pistol Crossbow, Little Friend (The Grenade Launcher is unusable)
* Added proper reload animations and sounds (reload timelines) for the Light Crossbow, Heavy Crossbow, and Pistol Crossbow

Tweaks:
* Improved partial reloading; you can only grab the magazine if it contains more ammo than your current magazine (prevents cases of grabbing a magazine that restores 0 rounds)

Fixes:
* Removed faulty hit-point code for the Tactical Flashlight that made it hard to hit enemies
* Weapons with reload animations built into the base weapon unit now play correctly (ex. Claire 12G)
* Fixed non-functional and incorrect reload timeline for the Claire 12G Shotgun
* The Airbow now displays arrows on its held 'magazine' model
* Fixed silent reloads for the M13 Pistol (+ Akimbo), Federales Pack weapons, the Akimbo Signature SMGs, and the HOLT 9mm Pistol (+ Akimbo)
* Implemented missing tweakdata for the MA-17 Flamethrower, M60 Light Machine Gun, and the R700 Sniper Rifle. You can now reload and two-hand them properly.
* Disabled visual recoil on the MA-17 Flamethrower so it matches the Flamethrower Mk.1
* Held/dropped magazines now display the actual amount of rounds they have in them (instead of always appearing full)

Planned Changes (not yet implemented):
* Fixing the non-functional belt resizing
* Akimbo weapons no longer playing empty magazine animations/sounds before they're actually empty
* Show full HUD while in custody
* Fix for not teleporting back if you fall out of the map
* Adjusted player spawns for some heists
* Tweaks to the melee damage penalty
* Fixes for non functional skills (Counter Strike, Stockholm Syndrome)
  
Requires BeardLib and SuperBLT.  
  
Unzip to mods.  