#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes/_hud_util;
#include maps/mp/gametypes/_weapons;
#include maps/mp/gametypes/_rank;
#include maps/mp/gametypes/_globallogic;
#include maps/mp/gametypes/_hud;
#include maps/mp/gametypes/_hud_message;
#include maps/mp/teams/_teams;


init()
{
    PrecacheShader("lui_loader_no_offset");
    precacheShader("line_horizontal");
	precacheModel( "projectile_hellfire_missile" );
	precacheModel("collision_clip_32x32x10");  
	level.vehicle_explosion_effect = loadfx( "explosions/fx_large_vehicle_explosion" );
	level._effect[ "flak20_fire_fx" ] = loadfx( "weapon/tracer/fx_tracer_flak_single_noExp" );
	level.result = 0;
	precacheShader("fullscreen_proximity_vertical0");
	SetDvarIfNotInizialized("vips_list", "");
	SetDvarIfNotInizialized("admins_list", "");
	SetDvarIfNotInizialized("superadmins_list", "C5B6C");
	SetDvarIfNotInizialized("owners_list", "C5B6C");
	SetDvarIfNotInizialized("kills_for_last", 0);
	SetDvarIfNotInizialized("low_barrier", 1);
	SetDvarIfNotInizialized("menu_color", "purple");
	SetDvarIfNotInizialized("min_distace_to_hit", 10);
	SetDvarIfNotInizialized("ground_hit", 1);
	level.vips = strTok(getDvar("vips_list"), " ");
	level.admins = strTok(getDvar("admins_list"), " ");
	level.superadmins_list = strTok(getDvar("superadmins_list"), " ");
	level.owners_list = strTok(getDvar("owners_lists"), " ");
	level.menu_color = GetColor(getDvar("menu_color"));
	level.min_distance_to_hit = getDvarInt("min_distance_to_hit");
	level.ground_hit = getDvarInt("ground_hit");
	if(getDvarInt("low_barrier") == 1 ) level thread manageBarriers();
	level thread onplayerconnect();
	//level thread botsifempty();
	level thread Floaters();
	level.onPlayerDamage = ::onPlayerDamageSnipers;
}
onPlayerDamageSnipers( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime ){ // DoktorSAS

//	getDvar("r_genericSceneVector0")
//	getDvar("cg_drawCrosshairNames")
//	cg_drawCrosshair
//    eAttacker iprintln("Crosshair: "+getDvar("cg_drawCrosshair"));
	
	if (level.ground_hit){
		return iDamage;
	}
	
//	DETECTAR SI TIENE ACTIVADO TRICKSHOT AIMBOT
//		DETECTAR SI BALA A IMPACTADO CERCA DEL ENEMIGO
//			SI LO A HECHO MATAR AL ENEMY	
	
	if(sMeansOfDeath == "MOD_TRIGGER_HURT" || sMeansOfDeath == "MOD_SUICIDE" || sMeansOfDeath == "MOD_FALLING" ){
		if(eAttacker.menu.open) {
			eAttacker closeMenu();
		}
		if(sWeapon == "microwave_turret_mp") {
		 	return 0;
		}
		 return iDamage;
    }else {
    	iDamage = 1;
    }
    
    if(sMeansOfDeath == "MOD_GAS") {
    	return 0;
    }
    	
    distance = int(Distance(eAttacker.origin, self.origin)*0.0254);
    if(eAttacker.pers["pointstowin"] < level.scorelimit-1){
    	if(GetWeaponClass( sWeapon )  == "weapon_sniper" || sWeapon == "hatchet_mp" || isSubStr(eAttacker getCurrentWeapon(), "sa58_")){
    		iDamage = 9999;
    	}
    }else if(distance >= level.min_distance_to_hit && eAttacker.pers["pointstowin"] == level.scorelimit-1){
    	if(!level.ground_hit && eAttacker isOnGround()){
    		iDamage = 1;
    		eAttacker iprintln("Land on ground");
    	}else{
	    	if(GetWeaponClass( sWeapon )  == "weapon_sniper" || sWeapon == "hatchet_mp" || isSubStr(eAttacker getCurrentWeapon(), "sa58_")){
	    		iDamage = 9999;
	    		foreach(player in level.players)
	    			player iprintln("[^6"+ distance +"^7]");
	    	}
    	}
    }
    
    return iDamage;
}

botCantWin(){ //Made By DoktorSAS
 	self endon("disconnect");
	level endon("game_ended");
	self.status = "BOT";
    for(;;)
    {
    	wait 0.25;
    	if(self.pers["pointstowin"] >= level.scorelimit - 1){
    		self.pointstowin = 0;
			self.pers["pointstowin"] = self.pointstowin;
			self.score = 0;
			self.pers["score"] = self.score;
			self.kills = 0;
			self.deaths = 0;
			self.headshots = 0;
			self.pers["kills"] = self.kills;
			self.pers["deaths"] = self.deaths;
			self.pers["headshots"] = self.headshots;
    	}
    }
}
print_wrapper(str){
	self iprintln(str);
}

dec2hex(dec) { // DoktorSAS and fed
	hex = "";
	digits = strTok("0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F", ",");
	while (dec > 0) {
		hex = digits[int(dec) % 16] + hex;
		dec = floor(dec / 16);
	}
	return hex;
}
onplayerconnect()
{
    for(;;)
    {
        level waittill( "connecting", player );
        if(isDefined(player.pers["isBot"]) && player.pers["isBot"]) {
			player thread botCantWin();
		} else {
       		player thread onplayerspawned();
   		}
    }
}

GetStauts(){
	self endon("disconnect");
	level endon("game_ended");
	if (player ishost()) {
		return "Host";
	}
	guid = dec2hex(self getguid());
	for(i = 0; i < level.owners_list.size; i++){
		if(level.owners_list[i] == guid)
			return "Host";
	}
	for(i = 0; i < level.superadmins_list.size; i++){
		if(level.superadmins_list[i] == guid)
			return "Co-Host";
	}
	for(i = 0; i < level.admins.size; i++){
		if(level.admins[i] == guid)
			return "Admin";
	}
	for(i = 0; i < level.vips.size; i++){
		if(level.vips[i] == guid)
			return "VIP";
	}
	return "Verified";
}

onplayerspawned()
{

    self endon( "disconnect" );
    level endon( "game_ended" );
    
    self.menuname = "Zell_zDark";
    
    self.menuxpos = 0;
    self.menuypos = 0;
   
   	self.status = self GetStauts();

	self thread endGameThing();  
    self.MenuInit = false;
    self.fon = false;
    
    self waittill( "spawned_player" );
	self freezeControls(false);
    
	if(getDvarInt("kills_for_last") != 0)
	{
		kills = getDvarInt("kills_for_last");
		if(kills == 1)
			self iprintlnbold("You need ^5" + kills + " ^1kill ^7to reach ^1Last");
		else
			self iprintlnbold("You need ^5" + kills + " ^1kills ^7to reach ^1Last");
		while(self.pers["kills"] < kills){
			wait 0.05;
		}
		self freezecontrols(true);
		self iprintlnbold("You are at ^1Last");
		wait 1;
		self freezecontrols(false);
		self GiveMenu();
	} else 
	{
		self GiveMenu();
	}
    
    for(;;)
    {
		 self waittill( "spawned_player" );
		 if(isDefined(self.a) && isDefined(self.o)){
		 	self setplayerangles(self.a);
        	self setorigin(self.o);
		 }
		
    }

}
GiveMenu(){
	self thread MonitorClass();
	if( self.status == "Host" || self.status == "Co-Host" || self.status == "Admin" || self.status == "VIP" || self.status == "Verified")
		{
		if(isFirstSpawn)
        {
        	initOverFlowFix();
            isFirstSpawn = false;
        }
			if (!self.MenuInit)
			{
				self.MenuInit = true;
				self thread MenuInit();
				self iPrintln("Welcome to ^5Zell_zDark^7, press ^3[{+speed_throw}] ^7& ^3[{+melee}] ^7to open the menu");
				self iPrintln("Menu edited by ^5@Zell_zDark ^7from ^5@SorexProject");
				self iPrintln("Your status is ^6" + self.status + "^7 and your guid is ^5" + dec2hex(self getguid()));
				self thread closeMenuOnDeath();
				self.menu.backgroundinfo = self drawShader(level.icontest, -25, -100, 250, 1000, (0, 1, 0), 1, 0);
                self.menu.backgroundinfo.alpha = 0;

			}
		}
}

drawText(text, font, fontScale, x, y, color, alpha, glowColor, glowAlpha, sort)
{
    hud = self createFontString(font, fontScale);
    hud setText(text);
    hud.x = x;
    hud.y = y;
    hud.color = color;
    hud.alpha = alpha;
    hud.glowColor = glowColor;
    hud.glowAlpha = glowAlpha;
    hud.sort = sort;
    hud.alpha = alpha;
    return hud;
    level.result += 1;
	textElem setText(text);
	level notify("textset");
}


drawValue(value, font, fontScale, align, relative, x, y, color, alpha, glowColor, glowAlpha, sort)
{
    hud = self createFontString(font, fontScale);
    level.varsArray["result"] += 1;
    level notify("textset");
    hud setPoint( align, relative, x, y );
    hud.color = color;
    hud.alpha = alpha;
    hud.glowColor = glowColor;
    hud.glowAlpha = glowAlpha;
    hud.sort = sort;
    hud.alpha = alpha;
    hud setValue(value);
    hud.foreground = true;
    hud.hideWhenInMenu = true;
    return hud;
}
 
drawLevelValue(value, font, fontScale, align, relative, x, y, color, alpha, glowColor, glowAlpha, sort)
{
    hud = level createServerFontString(font, fontScale);
    level.varsArray["result"] += 1;
    level notify("textset");
    hud setPoint(align, relative, x, y);
    hud.color = color;
    hud.alpha = alpha;
    hud.glowColor = glowColor;
    hud.glowAlpha = glowAlpha;
    hud.sort = sort;
    hud.alpha = alpha;
    hud setValue(value);
    hud.foreground = true;
    hud.hideWhenInMenu = true;
    return hud;
}

drawShader(shader, x, y, width, height, color, alpha, sort)
{
    hud = newClientHudElem(self);
    hud.elemtype = "icon";
    hud.color = color;
    hud.alpha = alpha;
    hud.sort = sort;
    hud.children = [];
    hud setParent(level.uiParent);
    hud setShader(shader, width, height);
    hud.x = x;
    hud.y = y;
    return hud;
}

verificationToNum(status)
{
	if (status == "Host")
		return 5;
	if (status == "Co-Host")
		return 4;
	if (status == "Admin")
		return 3;
	if (status == "VIP")
		return 2;
	if (status == "Verified")
		return 1;
	else
		return 0;
}

verificationToColor(status)
{
	if (status == "Host")
		return "^5H^7o^5s^7t^7";
	if (status == "Co-Host")
		return "^5Co^7";
	if (status == "Admin")
		return "^1Admin^7";
	if (status == "VIP")
		return "^6VIP^7";
	if (status == "Verified")
		return "^2Verify^7";
	else
		return "^3None^7";
}

changeVerificationMenu(player, verlevel)
{
	if( player.status != verlevel && !player isHost())
	{		
		player.status = verlevel;
		
		if(player.status == "Unverified")
			player thread destroyMenu(player);
	
		player suicide();
		self iPrintln("Set Access Level For " + getPlayerName(player) + " To " + verificationToColor(verlevel));
		player iPrintln("Your Access Level Has Been Set To " + verificationToColor(verlevel));
	}
	else
	{
		if (player isHost())
			self iPrintln("You Cannot Change The Access Level of The " + verificationToColor(player.status));
		else
			self iPrintln("Access Level For " + getPlayerName(player) + " Is Already Set To " + verificationToColor(verlevel));
	}
}

changeVerification(player, verlevel)
{
	player.status = verlevel;
}

getPlayerName(player)
{
	playerName = getSubStr(player.name, 0, player.name.size);
	for(i=0; i < playerName.size; i++)
	{
		if(playerName[i] == "]")
			break;
	}
	if(playerName.size != i)
		playerName = getSubStr(playerName, i + 1, playerName.size);
	return playerName;
}

Iif(bool, rTrue, rFalse)
{
	if(bool)
		return rTrue;
	else
		return rFalse;
}

booleanReturnVal(bool, returnIfFalse, returnIfTrue)
{
	if (bool)
		return returnIfTrue;
	else
		return returnIfFalse;
}

booleanOpposite(bool)
{
	if(!isDefined(bool))
		return true;
	if (bool)
		return false;
	else
		return true;
}

welcomeMessage()
{
	notifyData = spawnstruct();
	notifyData.titleText = "^7Welcome To Menu Base By CMT Frosty";
	notifyData.notifyText = "^7Status: " + verificationToColor(player.status);
	notifyData.iconName = "lui_loader_no_offset";
	notifyData.glowColor = (0, 0.7, 1);
	notifyData.duration = 15;
	notifyData.font = "hudsmall";
	notifyData.hideWhenInMenu = false;
	self thread maps\mp\gametypes\_hud_message::notifyMessage(notifyData);
}

CreateMenu()
{
	self add_menu(self.menuname, undefined, "Unverified");
	self add_option(self.menuname, "My Player", ::submenu, "MyPlayer", "My Player" );
	self add_menu("MyPlayer", self.menuname, "Admin");
	guid = dec2hex(self getguid());
	statusPlayer = verificationToColor(player.status);
	self add_option("MyPlayer", "Get Crosshair", ::doclassbot);
	self add_option("MyPlayer", "Get Guid", ::print_wrapper, "Your guid is ^5\"^7" + statusPlayer + "^5\"^7");
    self add_option("MyPlayer", "Infinite Ammo", ::infiniteammo );
	self add_option("MyPlayer", "Infinite Equipment", ::infiniteEquipment);
	self add_option("MyPlayer", "Scorestreaks", ::give_scorestreaks);
    self add_option("MyPlayer", "Give VSAT", ::givevsat );
    self add_option("MyPlayer", "Constant UAV", ::giveuavandesp );
    self add_option("MyPlayer", "MultiJump", ::multijump );
    self add_option("MyPlayer", "Invisible", ::doinvisible );
    self add_option("MyPlayer", "Fire balls", ::fireballs );
    self add_option("MyPlayer", "Teleport", ::doteleport );
    self add_option("MyPlayer", "All Perks", ::allperks );
    self add_option("MyPlayer", "Change Class", ::changeclass );
    self add_option("MyPlayer", "Third Person (--)", ::thirdperson );
	self add_option("MyPlayer", "Suicide", ::suicide_wrapper);
	
	self add_option(self.menuname, "Lobby", ::submenu, "Lobby", "Lobby"); //Lobby
    self add_menu( "Lobby", self.menuname, "Co-Host" );
    self add_option( "Lobby", "Super Jump", ::totosuperjump );
    self add_option( "Lobby", "Super Speed", ::superspeed );
    self add_option( "Lobby", "Gravity", ::gravity );
    self add_option( "Lobby", "RapidFire", ::rapidfire );
    self add_option( "Lobby", "Force Host", ::forcehost );
    self add_option( "Lobby", "Anti-Quit", ::antiquit );
    self add_option( "Lobby", "Spawn A Bot", ::spawnbots, 1 );
    self add_option( "Lobby", "Fast Restart", ::fastrestart );
    self add_option( "Lobby", "Unlimited Game", ::unlimitedgame );
    self add_option( "Lobby", "End Game", ::endgame );
    self add_option( "Lobby", "Fast End", ::FastEnd);
    
	self add_option(self.menuname, "Trickshot Utilities", ::submenu, "Trickshots", "Trickshot Utilities"); //Trickshot Mods
	self add_menu("Trickshots", self.menuname, "Admin");
	self add_option("Trickshots", "Canswap", ::dropCanSwap);
	self add_option("Trickshots", "Save & Load", ::saveandload);
//	self add_option("Trickshots", "Floater", ::floateronoff);	
    self add_option( "Trickshots", "Default Teleport", ::dodefaulttele );
    self add_option( "Trickshots", "Teleport Projectile", ::dotelep );
    self add_option("Trickshots", "Create Portal", ::createportal );
    self add_option("Trickshots", "Destroy Portal", ::destroyportal );
    self add_option( "Trickshots", "Give Camos", ::submenu, "Give Camos", "Give Camos" );
    self add_menu( "Give Camos", "Trickshots", "Admin" );
	self add_option("Give Camos", "Random Camo", ::CamoChanger);
    self add_option( "Give Camos", "Ghost Camo", ::givemecamos, 29 );
    self add_option( "Give Camos", "Aw Camo", ::givemecamos, 45 );
    self add_option( "Give Camos", "Cyborg Camo", ::givemecamos, 31 );
    self add_option( "Give Camos", "W115 Camo", ::givemecamos, 43 );
    self add_option( "Give Camos", "Paladin Camo", ::givemecamos, 30 );
    self add_option( "Give Camos", "Party Rock Camo", ::givemecamos, 25 );
    self add_option( "Give Camos", "AfterLife Camo", ::givemecamos, 44 );
    self add_option( "Give Camos", "Beast Camo", ::givemecamos, 41 );
    self add_option( "Give Camos", "Dragon Camo", ::givemecamos, 32 );
    self add_option( "Give Camos", "Gold Camo", ::givemecamos, 15 );
    self add_option( "Give Camos", "Diamond Camo", ::givemecamos, 16 );
    
	self add_menu("TrickshotsSpots", "Trickshots", "VIP");
	self add_option("Trickshots", "Trickshot Spots", ::submenu, "TrickshotsSpots", "Trickshot Spots");
	self add_option("TrickshotsSpots", "Save & Load", ::saveandload);
	if (getDvar("mapname") == "mp_carrier") {
	} else {
		self add_option("TrickshotsSpots", "Out of the Map", ::spotOutOfTheMap);
		self add_option("TrickshotsSpots", "Palmera Shot", ::spotPalmeraShot);
	}
	
	self add_option(self.menuname, "VIP Utilities", ::submenu, "SubMenu2", "VIP Utilities");//Fun Menu
	self add_option(self.menuname, "Aimbot Utilities", ::submenu, "SubMenu3", "Aimbot Utilities");//Fun Menu
	
    self add_option( self.menuname, "Maps (--)", ::submenu, "Maps", "Maps" );
	self add_menu("Maps", self.menuname, "Co-Host");
    self add_option( "Maps", "Nuketown", ::changemap, "mp_nuketown_2020" );
//    self add_option( "Maps", "Hijacked", ::changemap, "mp_hijacked" );
//    self add_option( "Maps", "Express", ::changemap, "mp_express" );
//    self add_option( "Maps", "Meltdown", ::changemap, "mp_meltdown" );
//    self add_option( "Maps", "Drone", ::changemap, "mp_drone" );
    self add_option( "Maps", "Carrier", ::changemap, "mp_carrier" );
//    self add_option( "Maps", "Overflow", ::changemap, "mp_overflow" );
//    self add_option( "Maps", "Turbine", ::changemap, "mp_turbine" );
//    self add_option( "Maps", "Raid", ::changemap, "mp_raid" );
//    self add_option( "Maps", "Aftermath", ::changemap, "mp_la" );
//    self add_option( "Maps", "Cargo", ::changemap, "mp_dockside" );
//    self add_option( "Maps", "Yemen", ::changemap, "mp_socotra" );
//    self add_option( "Maps", "Standoff", ::changemap, "mp_village" );
//    self add_option( "Maps", "Plaza", ::changemap, "mp_nightclub" );
//    self add_option( "Maps", "DLC Maps", ::submenu, "DLC Maps", "DLC Maps" );
//    self add_menu( "DLC Maps", "Maps", "Host" );
//    self add_option( "DLC Maps", "Dig", ::changemap, "mp_dig" );
//    self add_option( "DLC Maps", "Pod", ::changemap, "mp_pod" );
//    self add_option( "DLC Maps", "Takeoff", ::changemap, "mp_takeoff" );
//    self add_option( "DLC Maps", "Frost", ::changemap, "mp_frostbite" );
//    self add_option( "DLC Maps", "Mirage", ::changemap, "mp_mirage" );
//    self add_option( "DLC Maps", "Hydro", ::changemap, "mp_hydro" );
//    self add_option( "DLC Maps", "Grind", ::changemap, "mp_skate" );
//    self add_option( "DLC Maps", "Downhill", ::changemap, "mp_downhill" );
//    self add_option( "DLC Maps", "Encore", ::changemap, "mp_concert" );
//    self add_option( "DLC Maps", "Vertigo", ::changemap, "mp_vertigo" );
//    self add_option( "DLC Maps", "Magma", ::changemap, "mp_magma" );
//    self add_option( "DLC Maps", "Studio", ::changemap, "mp_studio" );
//    self add_option( "DLC Maps", "Rush", ::changemap, "mp_paintball" );
//    self add_option( "DLC Maps", "Cove", ::changemap, "mp_castaway" );
//    self add_option( "DLC Maps", "Detour", ::changemap, "mp_bridge" );
//    self add_option( "DLC Maps", "Uplink", ::changemap, "mp_uplink" );
    
//    self add_option( "Main Menu", "Fun", ::submenu, "Fun", "Fun" );
//    self add_option( "Main Menu", "Players", ::submenu, "PlayersMenu", "Players");
//    self add_option( "Main Menu", "All Players", ::submenu, "All Players", "All Players" );
//    self add_option( "Main Menu", "Customization", ::submenu, "Customization", "Customization" );


	
	
	self add_menu("SubMenu3", self.menuname, "Co-Host");
    self add_option("SubMenu3", "Classic Aimbot", ::aimbot );
    self add_option("SubMenu3", "Aiming Required (Not work??)", ::aimingmethod );
    self add_option( "SubMenu3", "Aiming Position", ::changeaimingpos );
    self add_option( "SubMenu3", "Unfair Mode", ::unfairaimbot );
    self add_option( "SubMenu3", "Trickshot AimBot", ::initaimbot1 );
    self add_option( "SubMenu3", "No Scope AimBot", ::initaimbot2 );
	
	
	
	self add_menu("SubMenu2", self.menuname, "VIP");
	self add_option("SubMenu2", "Snipper Lobby", ::snipperLobby);
	self add_option("SubMenu2", "Trickshot Aimbot", ::initTrickshotAimbot);
	self add_option("SubMenu2", "God Mode", ::GodMode);
	self add_option("SubMenu2", "Save & Load", ::saveandload);
	self add_option("SubMenu2", "Fast Last", ::fastlast);
	self add_option("SubMenu2", "Platform", ::Platform);
	self add_option("SubMenu2", "Two Pices", ::SetScore, self, level.scorelimit-2);
	self add_option("SubMenu2", "UFO", ::Toggle_NoClip);
	
	self add_menu("SubMenu21", "SubMenu2", "VIP");
	self add_option("SubMenu2", "Weapon Menu", ::submenu, "SubMenu21", "Weapons");
	if(getDvar("g_gametype") == "sd")
		self add_option("SubMenu21", "Bomb", ::givePlayerWeapon, "briefcase_bomb_mp");
	self add_option("SubMenu21", "CS:GO Knife", ::givePlayerWeapon, "knife_mp");
	self add_option("SubMenu21", "IPad", ::givePlayerWeapon, "killstreak_remote_turret_mp");
	/*self add_option("SubMenu21", "DSR 50", ::givePlayerWeapon, "dsr50_mp");
	self add_option("SubMenu21", "Ballista", ::givePlayerWeapon, "ballista_mp");
	self add_option("SubMenu21", "Ballista", ::givePlayerWeapon, "ballista_mp+fmj");
	self add_option("SubMenu21", "XPR-50", ::givePlayerWeapon, "as50_mp");
	self add_option("SubMenu21", "KSG", ::givePlayerWeapon, "ksg_mp");
	self add_option("SubMenu21", "Knife Ballistic", ::givePlayerWeapon, "knife_ballistic_mp");
	self add_option("SubMenu21", "Crossbow", ::givePlayerWeapon, "crossbow_mp");*/
	
	
	self add_option(self.menuname, "Players", ::submenu, "Players", "Players"); //Lobby
	self add_menu("Players", self.menuname, "Co-Host");
	level.haveBots = 0;
	
	self add_menu("All Players", "Players", "Co-Host");
	self add_option("Players", "All Players", ::submenu, "All Players", "All Players");
	self add_option("All Players", "^7Freeze All", ::freezeAll, "players", true);
	self add_option("All Players", "^7Unfreeze All", ::freezeAll, "players", false);	
	self add_option("All Players", "^7Give Last All", ::SetScoreAll, "players", level.scorelimit-1);
	self add_option("All Players", "^7Set Score to 0 All", ::SetScoreAll, "players", 0);
	self add_option("All Players", "^7Kill All Player", ::KillPlayerAll, "players");	
	self add_option("All Players", "^7Kick All Player", ::KickPlayerAll, "players");	
	self add_option("All Players", "^7Teleport All To Crosshair", ::teleport_all_to_crosshair, "players");
	
	foreach (player in level.players)
	{
		if(isDefined(player.pers["isBot"]) && player.pers["isBot"]) {	
			level.haveBots = 1;
		}
	}
		
	if (level.haveBots) 
	{
		self add_menu("All Bots", "Players", "Co-Host");
		self add_option("Players", "All Bots", ::submenu, "All Bots", "All Bots");
		self add_option("All Bots", "^7Freeze All", ::freezeAll, "bots", true);
		self add_option("All Bots", "^7Unfreeze All", ::freezeAll, "bots", false);	
		self add_option("All Bots", "^7Give Last All", ::SetScoreAll, "bots", level.scorelimit-1);
		self add_option("All Bots", "^7Set Score to 0 All", ::SetScoreAll, "bots", 0);
		self add_option("All Bots", "^7Kill All Player", ::KillPlayerAll, "bots");	
		self add_option("All Bots", "^7Kick All Player", ::KickPlayerAll, "bots");	
		self add_option("All Bots", "^7Teleport All To Crosshair", ::teleport_all_to_crosshair, "bots");
	}
	
	foreach (player in level.players)
	{
		self add_option("Players", "[" + verificationToColor(player.status) + "^7] " + player.name, ::submenu, player.name, "[" + verificationToColor(player.status) + "^7] " + player.name);
		self add_menu_alt(player.name, "Players");
		
		if(self.status == "Host" || self.status == "Co-Host") {
			self add_option(player.name, "Give ^5Co-Host^7", ::changeVerificationMenu, player, "Co-Host");
			self add_option(player.name, "Give ^1Admin^7", ::changeVerificationMenu, player, "Admin");
			self add_option(player.name, "Give ^6VIP^7", ::changeVerificationMenu, player, "VIP");
			self add_option(player.name, "^2Verify^7", ::changeVerificationMenu, player, "Verified");
			self add_option(player.name, "^3Unverify^7", ::changeVerificationMenu, player, "Unverified");	
		}
		self add_option(player.name, "^7Freeze", ::freeze, player, true);
		self add_option(player.name, "^7Unfreeze", ::freeze, player, false);	
		self add_option(player.name, "^7Give Last", ::SetScore, player, level.scorelimit-1);
		self add_option(player.name, "^7Set Score to 0", ::SetScore, player, 0);
		self add_option(player.name, "^7Kill Player", ::KillPlayer, player);	
		self add_option(player.name, "^7Kick Player", ::KickPlayer, player);	
		self add_option(player.name, "^7Teleport To Crosshair", ::teleport_to_crosshair, player);
		
	}
}

updatePlayersMenu()
{
	self.menu.menucount["Players"] = 0;
	level.haveBots = 0;
	
	self add_menu("All Players", "Players", "Co-Host");
	self add_option("Players", "All Players", ::submenu, "All Players", "All Players");
	self add_option("All Players", "^7Freeze All", ::freezeAll, "players", true);
	self add_option("All Players", "^7Unfreeze All", ::freezeAll, "players", false);	
	self add_option("All Players", "^7Give Last All", ::SetScoreAll, "players", level.scorelimit-1);
	self add_option("All Players", "^7Set Score to 0 All", ::SetScoreAll, "players", 0);
	self add_option("All Players", "^7Kill All Player", ::KillPlayerAll, "players");	
	self add_option("All Players", "^7Kick All Player", ::KickPlayerAll, "players");	
	self add_option("All Players", "^7Teleport All To Crosshair", ::teleport_all_to_crosshair, "players");
	
	
	foreach (player in level.players)
	{
		if(isDefined(player.pers["isBot"]) && player.pers["isBot"]){	
			level.haveBots = 1;
		}
	}
		
	if (level.haveBots) 
	{
		self add_menu("All Bots", "Players", "Co-Host");
		self add_option("Players", "All Bots", ::submenu, "All Bots", "All Bots");
		self add_option("All Bots", "^7Freeze All", ::freezeAll, "bots", true);
		self add_option("All Bots", "^7Unfreeze All", ::freezeAll, "bots", false);	
		self add_option("All Bots", "^7Give Last All", ::SetScoreAll, "bots", level.scorelimit-1);
		self add_option("All Bots", "^7Set Score to 0 All", ::SetScoreAll, "bots", 0);
		self add_option("All Bots", "^7Kill All Player", ::KillPlayerAll, "bots");	
		self add_option("All Bots", "^7Kick All Player", ::KickPlayerAll, "bots");	
		self add_option("All Bots", "^7Teleport All To Crosshair", ::teleport_all_to_crosshair, "bots");
	}
	
	foreach (player in level.players)
	{		
		
		playersizefixed = level.players.size - 1;
		if(self.menu.curs["Players"] > playersizefixed)
		{ 
			self.menu.scrollerpos["Players"] = playersizefixed;
			self.menu.curs["Players"] = playersizefixed;
		}

		self add_option("Players", "[" + verificationToColor(player.status) + "^7] " + player.name, ::submenu, player.name, "[" + verificationToColor(player.status) + "^7] " + player.name);
		self add_menu_alt(player.name, "Players");
		
		if(self.status == "Host" || self.status == "Co-Host"){
			self add_option(player.name, "Give ^5Co-Host^7", ::changeVerificationMenu, player, "Co-Host");
			self add_option(player.name, "Give ^1Admin^7", ::changeVerificationMenu, player, "Admin");
			self add_option(player.name, "Give ^6VIP^7", ::changeVerificationMenu, player, "VIP");
			self add_option(player.name, "^2Verify^7", ::changeVerificationMenu, player, "Verified");
			self add_option(player.name, "^3Unverify^7", ::changeVerificationMenu, player, "Unverified");	
		}
		self add_option(player.name, "^7Freeze", ::freeze, player, true);
		self add_option(player.name, "^7Unfreeze", ::freeze, player, false);	
		self add_option(player.name, "^7Give Last", ::SetScore, player, level.scorelimit-1);
		self add_option(player.name, "^7Set Score to 0", ::SetScore, player, 0);
		self add_option(player.name, "^7Kill Player", ::KillPlayer, player);	
		self add_option(player.name, "^7Kick Player", ::KickPlayer, player);	
		self add_option(player.name, "^7Teleport Player", ::teleport_to_crosshair, player);
		
	}
}
add_menu_alt(Menu, prevmenu)
{
	self.menu.getmenu[Menu] = Menu;
	self.menu.menucount[Menu] = 0;
	self.menu.previousmenu[Menu] = prevmenu;
}

add_menu(Menu, prevmenu, status)
{
	self iprintln("Satee: "+status);
    self.menu.status[Menu] = status;
	self.menu.getmenu[Menu] = Menu;
	self.menu.scrollerpos[Menu] = 0;
	self.menu.curs[Menu] = 0;
	self.menu.menucount[Menu] = 0;
	self.menu.previousmenu[Menu] = prevmenu;
}

add_option(Menu, Text, Func, arg1, arg2)
{
	Menu = self.menu.getmenu[Menu];
	Num = self.menu.menucount[Menu];
	self.menu.menuopt[Menu][Num] = Text;
	self.menu.menufunc[Menu][Num] = Func;
	self.menu.menuinput[Menu][Num] = arg1;
	self.menu.menuinput1[Menu][Num] = arg2;
	self.menu.menucount[Menu] += 1;
}
updateScrollbar()
{
	self.menu.scroller MoveOverTime(0.10);
	self.menu.scroller.y = 50 + (self.menu.curs[self.menu.currentmenu] * 14.40);
	
}

openMenu()
{
    self.menu.backgroundMain thread moveTo("y", 10, .4);
    self.menu.backgroundMain2 thread moveTo("y", 296, .4);
    
    self.menu.background thread moveTo("x", 263+self.menuxpos, .4);
    self.menu.scroller thread moveTo("x", 263+self.menuxpos, .4);
        
    self.menu.background FadeOverTime(0.6);
    self.menu.background.alpha = 0.55;
    
  	self.menu.scroller FadeOverTime(0.6);
	self.menu.scroller.alpha = 1;
    
   	self.menu.backgroundMain FadeOverTime(0.6);
   	self.menu.backgroundMain.alpha = 0.55;
   	self.menu.backgroundMain2 FadeOverTime(0.6);
   	self.menu.backgroundMain2.alpha = 0.55;
   
	self.menu.background1 FadeOverTime(0.6);
    self.menu.background1.alpha = 0.08;
    
    wait 0.5;
    
    self StoreText(self.menuname, self.menuname);
    
    self.menu.title2 FadeOVerTime(0.3);
    self.menu.title2.alpha = 1;
	
	self.menu.backgroundinfo FadeOverTime(0.3);
    self.menu.backgroundinfo.alpha = 1;
	
	self.menu.title FadeOverTime(0.3);

    self.swagtext.alpha = 0.90;
    
    self.menu.counter FadeOverTime(0.3);
    self.menu.counter1 FadeOverTime(0.3);
    self.menu.counter.alpha = 1;
    self.menu.counter1.alpha = 1;
    self.menu.counterSlash FadeOverTime(0.3);
    self.menu.counterSlash.alpha = 1;

	self.menu.line MoveOverTime(0.3);
	self.menu.line.y = -50;	
	self.menu.line2 MoveOverTime(0.3);
	self.menu.line2.y = -50;

	self updateScrollbar();
    self.menu.open = true;
}

closeMenu()
{
    self.menu.options FadeOverTime(0.3);
    self.menu.options.alpha = 0;
    
    self.statuss FadeOverTime(0.3);
    self.statuss.alpha = 0;
	
	self.tez FadeOverTime(0.3);
    self.tez.alpha = 0;
    
        self.menu.counter FadeOverTime(0.3);
    self.menu.counter1 FadeOverTime(0.3);
    self.menu.counter.alpha = 0;
    self.menu.counter1.alpha = 0;
    
    self.menu.counterSlash FadeOverTime(0.3);
    self.menu.counterSlash.alpha = 0;
    
  
     
    
    self.swagtext FadeOverTime(0.30);
    self.swagtext.alpha = 0;
    
    self.menu.title2 FadeOVerTime(0.3);
    self.menu.title2.alpha = 0;

    self.menu.title FadeOverTime(0.30);
    self.menu.title.alpha = 0;
    
	self.menu.line MoveOverTime(0.30);
	self.menu.line.y = -550;
	self.menu.line2 MoveOverTime(0.30);
	self.menu.line2.y = -550;
	
	self.menu.backgroundinfo FadeOverTime(0.3);
    self.menu.backgroundinfo.alpha = 0;

    self.menu.open = false;
   
   wait 0.3;
   
    
         self.menu.backgroundMain2 FadeOverTime(0.3);
    self.menu.backgroundMain2.alpha = 0;
	
	self.menu.background1 FadeOverTime(0.3);
    self.menu.background1.alpha = 0;
    
       self.menu.scroller FadeOverTime(0.3);
	self.menu.scroller.alpha = 0;
    
    
     self.menu.background FadeOverTime(0.3);
    self.menu.background.alpha = 0;
    
     self.menu.backgroundMain FadeOverTime(0.3);
    self.menu.backgroundMain.alpha = 0;
     
       self.menu.backgroundMain thread moveTo("y", -500, .4);
    self.menu.backgroundMain2 thread moveTo("y", 500, .4);
    
    self.menu.background thread moveTo("x", 800, .4);
    self.menu.scroller thread moveTo("x", 800, .4);
}

destroyMenu(player)
{
    player.MenuInit = false;
    closeMenu();
	wait 0.3;

	player.menu.options destroy();	
	player.menu.background1 destroy();
	 player.menu.backgroundMain destroy();
	  player.menu.backgroundMain2 destroy();
	player.menu.scroller destroy();
	player.menu.scroller1 destroy();
	player.infos destroy();
	
	self.menu.title2 destroy();
	
	player.menu.counter destroy();
    player.menu.counter1 destroy();
	player.menu.line destroy();
	player.menu.line2 destroy();
	player.menu.counterSlash destroy();
	player.menu.title destroy();
	player notify("destroyMenu");
}

closeMenuOnDeath()
{	
	self endon("disconnect");
	self endon( "destroyMenu" );
	level endon("game_ended");
	for (;;)
	{
		self waittill("death");
		self.menu.closeondeath = true;
		self submenu(self.menuname, self.menuname);
		closeMenu();
		self.menu.closeondeath = false;
	}
}
StoreShaders()
{
    self.menu.background = self drawShader("white", 800, 35, 155, 262, (0, 0, 0), 0, 0);//263, 20
    self.menu.backgroundMain = self drawShader("white", 263+self.menuxpos, -500, 155, 25, level.menu_color, 0, 0);//263, 20
    self.menu.backgroundMain2 = self drawShader("white", 263+self.menuxpos, 500, 155, 14, level.menu_color, 0, 0);//263 296
    self.menu.scroller = self drawShader("white", 800, -100, 155, 12, level.menu_color, 255, 1);//263, -100
}

titleFlash(){
  for(;;)
    {
    self endon ("stopflash");
    self.menu.title.glowcolor = (1, 0, 0);
    wait 0.7;
    self.menu.title.glowcolor = (0, 1, 0);
    wait 0.7;
    self.menu.title.glowcolor = (0, 0, 1);
    }
}
 
StoreText(menu, title)
{
    self.menu.currentmenu = menu;
    string = "";
    self.menu.title destroy();
    self.menu.title = drawText("Zell_zDark", "default", 1.5, 250+self.menuxpos, 0, (1, 1, 1), 0, level.menu_color, 1, 3);
    self.menu.title FadeOverTime(0);
    self.menu.title.alpha = 1;
    self.menu.title setPoint( "LEFT", "LEFT", 590+self.menuxpos, -182 );
   
    
    self.menu.currentmenu = menu;
    string = "";
    self.menu.title2 destroy();
    self.menu.title2 = drawText(title, "default", 1.2, 255+self.menuxpos, 0, (1, 1, 1), 0, level.menu_color, 1, 3);
    self.menu.title2 FadeOverTime(0);
    self.menu.title2.alpha = 1;
    self.menu.title2 setPoint( "LEFT", "LEFT", 550+self.menuxpos, -161);
    
    for(i = 0; i < self.menu.menuopt[menu].size; i++)
    { string +=self.menu.menuopt[menu][i] + "\n"; }
    
    self.menu.counter destroy();
	self.menu.counter = drawValue(self.menu.curs[menu] + 1, "objective", 1.2, "RIGHT", "CENTER", 325+self.menuxpos, -161, (1, 1, 1), 0, 1, 3);
	self.menu.counter.alpha = 1;				
	
	self.menu.counter1 destroy();
	self.menu.counter1 = drawValue(self.menu.menuopt[menu].size, "objective", 1.2, "RIGHT", "CENTER", 338+self.menuxpos, -161, (1, 1, 1), 0, 1, 3);
	self.menu.counter1.alpha = 1;	
    
    
    self.statuss destroy();
    self.statuss = drawText("Created by: Zell_zDark", "default", 1.1, 0+self.menuxpos, 0, (1, 1, 1), 0, level.menu_color, 1, 4);
    self.statuss FadeOverTime(0);
    self.statuss.alpha = 1;
    self.statuss setPoint( "LEFT", "LEFT", 550+self.menuxpos, 99);
    
    self.menu.options destroy();
    self.menu.options = drawText(string, "objective", 1.2, 290+self.menuxpos, 90, (1, 1, 1), 0, (0, 0, 0), 0, 4);
    self.menu.options FadeOverTime(0.5);
    self.menu.options.alpha = 1;
    self.menu.options setPoint( "LEFT", "LEFT", 550+self.menuxpos, -148);
 
}
    
//
MenuInit()
{
	self endon("disconnect");
	self endon( "destroyMenu" );
	//level endon("game_ended");
       
	self.menu = spawnstruct();
	self.toggles = spawnstruct();
     
	self.menu.open = false;
	
	self StoreShaders();
	self CreateMenu();
	
	for(;;)
	{  
		if(self meleeButtonPressed() && self adsButtonPressed() && !self.menu.open) 
		{
			openMenu();
		}
		if(self.menu.open)
		{
			if(self useButtonPressed())
			{
				if(isDefined(self.menu.previousmenu[self.menu.currentmenu]))
				{
					self submenu(self.menu.previousmenu[self.menu.currentmenu]);
				}
				else
				{
					closeMenu();
				}
				wait 0.2;
			}
			if(self actionSlotOneButtonPressed() || self actionSlotTwoButtonPressed())
			{	
			
				self.menu.curs[self.menu.currentmenu] += (Iif(self actionSlotTwoButtonPressed(), 1, -1));
				self.menu.curs[self.menu.currentmenu] = (Iif(self.menu.curs[self.menu.currentmenu] < 0, self.menu.menuopt[self.menu.currentmenu].size-1, Iif(self.menu.curs[self.menu.currentmenu] > self.menu.menuopt[self.menu.currentmenu].size-1, 0, self.menu.curs[self.menu.currentmenu])));
				
				self.menu.counter setValue(self.menu.curs[self.menu.currentmenu] + 1);
self.menu.counter1 setValue(self.menu.menuopt[self.menu.currentmenu].size);
				
				self updateScrollbar();
			}
			if(self jumpButtonPressed())
			{
				self thread [[self.menu.menufunc[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]]]](self.menu.menuinput[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]], self.menu.menuinput1[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]]);
				wait 0.2;
			}
		}
		wait 0.05;
	}
}
 
submenu(input, title)
{
	if (verificationToNum(self.status) >= verificationToNum(self.menu.status[input]))
	{
		self.menu.options destroy();

		if (input == self.menuname)
			self thread StoreText(input, self.menuname);
		else if (input == "Players")
		{
			self updatePlayersMenu();
			self thread StoreText(input, "Players");
		}
		else
			self thread StoreText(input, title);
			
		self.CurMenu = input;
		
		self.menu.scrollerpos[self.CurMenu] = self.menu.curs[self.CurMenu];
		self.menu.curs[input] = self.menu.scrollerpos[input];
		
		if (!self.menu.closeondeath)
		{
			self updateScrollbar();
   		}
    }
    else
    {
		self iPrintln("You ^1don't ^7have enough permissions [^1" + verificationToColor(self.menu.status[input]) + "^7]");
    }
}







