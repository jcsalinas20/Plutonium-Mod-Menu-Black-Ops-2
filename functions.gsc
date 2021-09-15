//COMO PUEDO ENTRAR A LA INGENIERIA DES DEL GRADO SUPERIOR

snipperLobby() {
	if (level.ground_hit == 0){
		level.ground_hit = 1;
		self iprintlnbold("Sniper Lobby ^1OFF");
	} else {
		level.ground_hit = 0;
		self iprintlnbold("Sniper Lobby ^2ON");
	}
}

moveTo(axis, position, time)
{
	self moveOverTime(time);

	if(axis=="x")
		self.x = position;
	else
		self.y = position;
}

GodMode()
{
	if(self.GM == false)
	{
		self EnableInvulnerability();
		self.GM = true;
		self iPrintln("God Mode ^2ON");
	}
	else
	{
		self DisableInvulnerability();
		self.GM = false;
		self iPrintln("God Mode ^1OFF");
	}
}

endGameThing(){
self endon( "disconnect" );
	self endon( "destroyMenu" );
	self endon( "gameEndInfo" );
}

changemap( mapname )
{
	self iprintln("Map: " + mapname);
    map( mapname );
}

initTrickshotAimbot()
{
    if (self.aim1 == 0)
    {
        self thread trickshotAimbot();      
        self.aim1 = 1;
        self iPrintln("Trickshot AimBot ^2ON");
        self iPrintln("Press [{+speed_throw}] + [{+Attack}]\n^5Enjoy ^7.. ^6:3");
    }
    else
    {
        self notify("EndAutoAim1");
        self.aim1=0;
        self iPrintln("Trickshot Aimbot ^1OFF");
    }
}

trickshotAimbot()
{
    self endon("disconnect");
//    self endon("death");
    self endon("EndAutoAim1");
    
    for(;;) 
    {
        aimAt = undefined;
        foreach(player in level.players)
        {
            if((player.name == self.name) || (!isAlive(player)) || (level.teamBased && self.pers["team"] == player.pers["team"]) || (player isHost()))
                continue;
            if(isDefined(aimAt))
            {
               	pelvisSelf = self getTagOrigin("pelvis");
//                self iprintln("Aimbot: "+pelvisSelf);
                if(closer(self getTagOrigin("pelvis"), player getTagOrigin("pelvis"), aimAt getTagOrigin("pelvis")))
                {
                	aimAt = player;
                }
            }
            else aimAt = player;
        }
        if(isDefined(aimAt))
        {
//          && self adsbuttonpressed() ->
            if(self attackbuttonpressed())
            {
//           	&& self adsbuttonpressed() ->  
                if(self attackbuttonpressed()) {
                	aimAt thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "pelvis", 0, 0 );
                }
                wait 1.0;
            }
        }
        wait 0.01;
    }
}
	
MenuMoveRight()
{
	if(self.menuxpos <= 55)
	{
	
		self.menu.scroller MoveOverTime(.3);
		self.menu.scroller.x = self.menu.scroller.x + 20;
		self.menu.background MoveOverTime(.3);
		self.menu.background.x = self.menu.background.x + 20;
		
		self.menu.backgroundMain MoveOverTime(.3);
		self.menu.backgroundMain.x = self.menu.backgroundMain.x + 20;
		self.menu.backgroundMain2 MoveOverTime(.3);
		self.menu.backgroundMain2.x = self.menu.backgroundMain2.x + 20;
		
		self.menu.title MoveOverTime(.3);
		self.menu.title.x = self.menu.title.x + 20;
		
		self.menu.title2 MoveOverTime(.3);
		self.menu.title2.x = self.menu.title2.x + 20;
		
		self.menu.counter MoveOverTime(.3);
		self.menu.counter.x = self.menu.counter.x + 20;
		self.menu.counter1 MoveOverTime(.3);
		self.menu.counter1.x = self.menu.counter1.x + 20;
		
		 self.statuss MoveOverTime(.3);
		 self.statuss.x = self.statuss.x + 20;
		
		self.menu.options MoveOverTime(.3);
		self.menu.options.x = self.menu.options.x + 20;
		
		
		
		self.menuxpos = self.menuxpos + 20;
		self iPrintln("Moved Menu ^1+20 ^7to the Right");
		if (self.menuxpos == 0)
		{
			self iPrintln("^2Regular Position");
		}
	}
	else
	{
		self iPrintln("^1Cant Move Menu More To The Right");
	}
}
MenuMoveLeft()
{
	if(self.menuxpos >= -435)
	{
		self.menu.scroller MoveOverTime(.3);
		self.menu.scroller.x = self.menu.scroller.x - 20;
		self.menu.background MoveOverTime(.3);
		self.menu.background.x = self.menu.background.x - 20;
				
		self.menu.backgroundMain MoveOverTime(.3);
		self.menu.backgroundMain.x = self.menu.backgroundMain.x - 20;
		self.menu.backgroundMain2 MoveOverTime(.3);
		self.menu.backgroundMain2.x = self.menu.backgroundMain2.x - 20;
		
		self.menu.title MoveOverTime(.3);
		self.menu.title.x = self.menu.title.x - 20;
		
		self.menu.title2 MoveOverTime(.3);
		self.menu.title2.x = self.menu.title2.x - 20;
		
		self.menu.counter MoveOverTime(.3);
		self.menu.counter.x = self.menu.counter.x - 20;
		self.menu.counter1 MoveOverTime(.3);
		self.menu.counter1.x = self.menu.counter1.x - 20;
		
		 self.statuss MoveOverTime(.3);
		 self.statuss.x = self.statuss.x - 20;
		
		self.menu.options MoveOverTime(.3);
		self.menu.options.x = self.menu.options.x - 20;
		
		self.menuxpos = self.menuxpos - 20;
		self iPrintln("Moved Menu ^1+20 ^7to the Left");
		if (self.menuxpos == 0)
		{
			self iPrintln("^2Regular Position");
		}
	}
	else
	{
		self iPrintln("^1Cant Move Menu More To The Left");
	}
}
// Function
// Credits to -> https://forum.plutonium.pw/topic/152/resource-trickshotting-gsc-list

createPortal()
{
    self endon("disconnect");

    self.portgun = booleanOpposite(self.portgun);
    self iPrintln(booleanReturnVal(self.portgun, "Portal Gun ^1OFF", "Portal Gun ^2ON"));

    if(self.porttog == true || self.portgun)
    {
        self iprintln( "Press [{+attack}] To Spawn ^2Green teleport" );
        self iprintln( "Press [{+speed_throw}] To Spawn ^1Red teleport" );
        self thread GivePortalgun();
        self.porttog = false;
    }
    else
    {
        self takeweapon("fiveseven_mp+silencer");
        self.porttog = true;
    }
}

destroyPortal()
{
    self iPrintln("Destroy Portal ^2Success");
    self notify("endportgun");
    if (isDefined(self.Portal1))
    {
        self notify("Portal1Death");
        if (isDefined(self.Portal1))
        self.Portal1 Delete();
    }
    if (isDefined(self.Portal2))
    {
        self notify("Portal2Death");
        if (isDefined(self.Portal2))
        self.Portal2 Delete();
    }
}

GivePortalGun()
{
    self endon("disconnect");
    self endon("endportgun");

    self giveWeapon("fiveseven_mp+silencer", 0, true( 29, 0, 0, 0, 0 ));
    self switchtoweapon("fiveseven_mp+silencer");
    self givemaxammo("fiveseven_mp+silencer");
    self thread MonitorTeleportCooling();

    for(;;)
    {
        if (self AttackButtonPressed() && self getCurrentWeapon() == "fiveseven_mp+silencer")
        {
            self notify("Portal1Death");
            if (isDefined(self.Portal1))
            self.Portal1 Delete();
        
            self thread CreatePortal1();
            wait .5;
        }
        
        if (self AdsButtonPressed() && self getCurrentWeapon() == "fiveseven_mp+silencer")
        {
            self notify("Portal2Death");
            if (isDefined(self.Portal2))
            self.Portal2 Delete();
        
            self thread CreatePortal2();
            wait .5;
        }
        wait .05;
    }
}

CreatePortal1()
{
    self endon("disconnect");
    self endon("Portal1Death");
    self endon("endportgun");
    
    self.TeleportCooling = 0;
    level.waypointGreen = loadFX("misc/fx_equip_tac_insert_light_grn");

    self.Portal1 = SpawnFx( level.waypointGreen, GetCursorPos() );
    TriggerFx( self.Portal1 );

    for(;;)
    {
        foreach(player in level.players)
        {
            if(Distance(self.Portal1.origin,player.origin) < 50 && player.TeleportCooling == 0)
            {
                player SetOrigin(self.Portal2.origin);
                player.TeleportCooling = 20;
                wait .5;
            }
        }
        wait .05;
    }
}

CreatePortal2()
{
    self endon("disconnect");
    self endon("Portal2Death");
    self endon("endportgun");

    self.TeleportCooling = 0;
    level.waypointRed = loadFX("misc/fx_equip_tac_insert_light_red");
    
    self.Portal2 = SpawnFx(level.waypointRed, GetCursorPos() );
    TriggerFx( self.Portal2 );

    for(;;)
    {
        foreach(player in level.players)
        {
            if(Distance(self.Portal2.origin,player.origin) < 50 && player.TeleportCooling == 0)
            {
                player SetOrigin(self.Portal1.origin);
                player.TeleportCooling = 20;
                wait .5;
            }
        }
        wait .05;
    }
}

MonitorTeleportCooling()
{
    self endon("disconnect");
    self endon("endportgun");
    
    self.TeleportCooling = 0;

    for(;;)
    {
        foreach(player in level.players)
        {
            if (player.TeleportCooling > 0)
            player.TeleportCooling--;
        }
        wait .1;
    }
}

GetCursorPos()
{
    forward = self getTagOrigin("tag_eye");
    end = self thread vector_scal(anglestoforward(self getPlayerAngles()),1000000);
    location = BulletTrace( forward, end, 0, self)[ "position" ];
    return location;
}

vector_scal(vec, scale)
{
    vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
    return vec;
}

thirdperson()
{

	if(self.tard==false)
	{
		self.tard=true;
		self setclientthirdperson(1);
		self iPrintln("Third Person [^2ON^7]");
	}
	else
	{
		self.tard=false;
		self setclientthirdperson(0);
		self iPrintln("Third Person [^1OFF^7]");
	}

//	if (!isDefined(self.thirdperson))
//    {
//    	self.thirdperson = 0;
//    }
//    self.thirdperson = booleanopposite( self.thirdperson );
//    self setclientthirdperson( self.thirdperson );
//    self iprintln( booleanreturnval( self.thirdperson, "Third Person: ^1Off", "Third Person: ^2On" ) );
}

giveweapons( weapon )
{
    rand = randomintrange( 0, 45 );
    self giveweapon( weapon, 0, rand, 0, 0, 0, 0 );
    self switchtoweapon( weapon );
    self givemaxammo( weapon );
    self iprintln( "^2 Weapon Given" );

}

givemecamos( colorcamo )
{
    weap = self getcurrentweapon();
    self takeweapon( self getcurrentweapon() );
    self giveweapon( weap, 0, colorcamo, 0, 0, 0, 0 );
    self switchtoweapon( weap );
    self givemaxammo( weap );
    self iprintln( "^5Given Camo" );

}

saveandload()
{

    if (self.snl == 0)

    {

        self iprintln("Save and Load ^2Enabled");

        self iprintln("Go in ^3Crouch ^7and Press ^3[{+actionslot 2}] ^7To ^2Save");

        self iprintln("Go in ^3Crouch ^7and Press ^3[{+actionslot 1}] ^7To ^2Load");

        self thread dosaveandload();

        self.snl = 1;

    }

    else

    {

        self iprintln("Save and Load ^1Disabled");

        self.snl = 0;
		self.o = undefined;
		self.a = undefined;
		
		self iprintln("Spawn point ^1Removed");
        self notify("SaveandLoad");

    }

}

moveToSpot(angles, origin) {
    self setplayerangles(angles);
    self setorigin(origin);
}

dosaveandload()
{

    self endon("disconnect");

    self endon("SaveandLoad");

    load = 0;

    for(;;)

    {

    if (self actionslottwobuttonpressed() && self GetStance() == "crouch" && self.snl == 1)

    {

        self.o = self.origin;

        self.a = self.angles;

        load = 1;

        self iprintln("Position ^2Saved - Position: a: "+self.a+" o: "+self.o);

        wait 2;

    }

    if (self actionslotonebuttonpressed() && self GetStance() == "crouch" && load == 1 && self.snl == 1)
    {
        moveToSpot(self.a, self.o);

    }

    wait 0.05;

}

}

// Fast last
fastlast()
{
	self.pointstowin = level.scorelimit-1; // change all the 1's to your kill limit... if it was 10, do 9, and edit the score. self.score goes by 200's
	self.pers["pointstowin"] = level.scorelimit-1;
	self.score = (level.scorelimit-1)*100;
	self.pers["score"] = (level.scorelimit-1)*100;
	self.kills = level.scorelimit-1;
	self.deaths = 0;
	self.headshots = 0;
	self.pers["kills"] = level.scorelimit-1;
	self.pers["deaths"] = 0;
	self.pers["headshots"] = 0;
	self iPrintlnBold ("Now you are at Last!");
}

dropCanSwap()
{

	weapon = randomGun();

	self giveWeapon(weapon, 0, true);

	/*You can obviously change the dropped weapon camo:

	self giveWeapon(weapon, 0, true( camoNumberHere, 0, 0, 0 ));

	Camos list

	*/

	self dropItem(weapon);

}

randomGun() //Credits to @MatrixMods

{

	self.gun = "";

	while(self.gun == "")

	{

		id = random(level.tbl_weaponids);

		attachmentlist = id["attachment"];

		attachments = strtok( attachmentlist, " " );

		attachments[attachments.size] = "";

		attachment = random(attachments);

		if(isweaponprimary((id["reference"] + "_mp+") + attachment) && !checkGun(id["reference"] + "_mp+" + attachment))

			self.gun = (id["reference"] + "_mp+") + attachment;

		wait 0.1;

		return self.gun;

	}

   wait 0.1;

}
checkGun(weap) //Credits to @MatrixMods

{

	self.allWeaps = [];

	self.allWeaps = self getWeaponsList();

	foreach(weapon in self.allWeaps)

	{

		if(isSubStr(weapon, weap))

			return true;

	}

	return false;

}

CamoChanger()
{
	rand=RandomIntRange(1,45);
	weap=self getCurrentWeapon();
	self takeWeapon(weap);
	self giveWeapon(weap,0,true(rand,0,0,0,0));
	self switchToWeapon(weap);
	self giveMaxAmmo(weap);
	self iPrintln("Random Camo Received ^2#"+ rand);
}

MonitorClass()
{

   self endon("disconnect");

   for(;;)

   {

		self waittill("changed_class");
		self maps/mp/gametypes/_class::giveloadout( self.team, self.class );

   }

}
Platform()
{
	location = self.origin;
	while (isDefined(self.spawnedcrate[0][0]))
	{
		i = 0;
		while (i < 3)
		{
			d = 0;
			while (d < 5)
			{
				self.spawnedcrate[i][d] delete();
				d++;
			}
			i++;
		}
		
	}
	startpos = location + (0, 0, -15);
	i = 0;
	while (i < 3)
	{
		d = 0;
		while (d < 5)
		{
			self.spawnedcrate[i][d] = spawn("script_model", startpos + (d * 40, i * 70, 0));
			self.spawnedcrate[i][d] setmodel("t6_wpn_supply_drop_axis");
			d++;
		}
		i++;
	}
	self iprintln("Platform ^2Spawned^7/^2Moved");
}
manageBarriers()
{
	currentMap = getDvar( "mapname" );
	
	switch ( currentMap )
	{
		case "mp_bridge":
			moveTrigger( 950 );
		break;	
		case "mp_hydro":
			moveTrigger( 1000 );
		break;	
		case "mp_uplink":
			moveTrigger( 300 );
		break;	
		case "mp_vertigo":
			moveTrigger( 800 );
		break;	
		case "mp_carrier":
			moveTrigger( 150 );
		break;	
//		default: // Allmaps
//			moveTrigger( 150 );
//			return;
	}
}
moveTrigger( z ) 
{
	if ( !isDefined ( z ) || isDefined ( level.barriersDone ) )
		return;
		
	level.barriersDone = true;
	
	trigger = getEntArray( "trigger_hurt", "classname" );

	for( i = 0; i < trigger.size; i++ )
	{
		if( trigger[i].origin[2] < self.origin[2] )
			trigger[i].origin -= ( 0 , 0 , z );
	}
}

// https://cabconmodding.com/threads/black-ops-2-gsc-managed-code-list-2.264/
give_scorestreaks(){
	self iprintln("Here we go your scorestreak");
	self maps/mp/gametypes/_globallogic_score::_setplayermomentum(self, 9999);
}

botsifempty(){ //Made by DoktorSAS

	level endon("game_ended");

	level waittill("connected", player);

	wait 1;

	cont = 0;

	contB = 0;

	foreach(p in level.players){

		if(isDefined(p.pers["isBot"]) && p.pers["isBot"]){	

			contB++;

		}else{

			cont++;

		}

	}


	if(cont < 5 && contB < 8){

		if(cont == 1 && contB == 0){

			player addBots( 7 );

		}else player addBots( (contB-cont) );

	}

	while(!level.gameended){
		cont = 0;
		contB = 0;
		level waittill("connected", player);
		foreach(p in level.players){
			if(isDefined(p.pers["isBot"]) && p.pers["isBot"]){	
				contB++;
			}else
				cont++;
		}
		 if(cont > 5 && contB > 0){
				player kickBots( 1 );
		}else if(cont <= 12 && contB < 8)
			player addBots(7-contB);
	}
}

kickBots( num ){ //Made by DoktorSAS

	i = level.players.size;

	while(i > -1 && num > 0){

		if(level.players[i].pers["isBot"]){

		    kickSelf(level.players[i]);

			num--;

		}

		i++;

	}

}

kickSelf( p ){ //Made by DoktorSAS

//	kick(p getentitynumber(), "EXE_PLAYERKICKED");
	kick(p getentitynumber());

}

addBots( num ){ //Made by DoktorSAS

	while(num > -1){

		self thread maps\mp\bots\_bot::spawn_bot("autoassign");

		wait 1;

		num--;

	}

}
Floaters(){

	level waittill("game_ended");

	foreach(player in level.players){

               if(isAlive(player) && !player isOnGround() && player.fon){

                	player thread FloatDown();

                }

        }

}

MultiJump()
{
    self endon("disconnect");

    self.MultiJump = booleanOpposite(self.MultiJump);
    self iPrintln(booleanReturnVal(self.MultiJump, "MultiJump: [^1OFF^7]", "MultiJump: [^2ON^7]"));

    if (self.MultiJump)
    { self onPlayerMultijump(); }
    else
    { self notify("EndMultiJump"); }
}

onPlayerMultijump()
{
    self endon("disconnect");
    self endon("EndMultiJump");

    self thread landsOnGround();
    if (!isDefined(self.numOfMultijumps))
    self.numOfMultijumps = 999;

    for(;;)
    {
        currentNum = 0;
        while(!self jumpbuttonpressed()) wait 0.05;
        while(self jumpbuttonpressed()) wait 0.05;
        if (getDvarFloat("jump_height") > 250)
        continue;
        if (!isAlive(self))
        {
            self waittill("spawned_player");
            continue;
        }
        if (!self isOnGround())
        {
            while(!self isOnGround() && isAlive(self) && currentNum < self.numOfMultijumps)
            {
                waittillResult = self waittill_any_timeout(0.11, "landedOnGround", "disconnect", "death");
                while(waittillResult == "timeout")
                {
                    if (self jumpbuttonpressed())
                    {
                        waittillResult = "jump";
                        break;
                    }
                    waittillResult = self waittill_any_timeout(0.05, "landedOnGround", "disconnect", "death");
                }
                if (waittillResult == "jump" && !self isOnGround() && isAlive( self ))
                {
                    playerAngles = self getplayerangles();
                    playerVelocity = self getVelocity();
                    self setvelocity((playerVelocity[0], playerVelocity[1], playerVelocity[2]/2) + anglestoforward((270, playerAngles[1], playerAngles[2])) * getDvarInt("jump_height") * (((-1/39) * getDvarInt("jump_height")) + (17/2)));
                    currentNum ++;
                    while(self jumpbuttonpressed()) wait 0.05;
                }
                else break;
            }
            while(!self isOnGround())
            wait 0.05;
        }
    }
}

landsOnGround()
{
    self endon("disconnect");
    self endon("EndMultiJump");

    loopResult = true;
    for(;;)
    {
        newResult = self isOnGround();
        if (newResult != loopResult)
        {
            if (!loopResult && newResult)
            self notify("landedOnGround");
            loopResult = newResult;
        }
        wait .05;
    }
}

doInvisible()
{
    self endon("disconnect");

    self.Invisible = booleanOpposite(self.Invisible);
    self iPrintln(booleanReturnVal(self.Invisible, "Invisible: [^1OFF^7]", "Invisible: [^2ON^7]"));

    if (self.Invisible)
    { self hide(); }
    else
    { self show(); }
}

Fireballs()
{
    self endon("disconnect");
    self endon("stop_Fireball");

    self.Fireball = booleanOpposite(self.Fireball);
    self iPrintln(booleanReturnVal(self.Fireball, "Fireball: ^1Off", "Fireball: ^2On\n^5You Need Frag Grenade"));

    if (self.Fireball)
    {
        while(true)
        {
            self waittill("grenade_fire",grenade,weapname);
            Bawz = spawn("script_model",grenade.origin);
            Bawz thread play_remote_fx(grenade);
            Bawz setModel("tag_origin");
            Bawz linkTo(grenade);
            waitmin;
        }
    }
    else
    {
        self notify("stop_Fireball");
        level notify("delete");
    }
}

ChangeClass()
{
    self endon("disconnect");

    self maps/mp/gametypes/_globallogic_ui::beginclasschoice();
    for(;;)
    {
        if (self.pers["changed_class"])
            self maps/mp/gametypes/_class::giveloadout(self.team, self.class);
        wait 0.05;
    }
}
AllPerkGiven()
{
    self.AllPerk = booleanOpposite(self.AllPerk);
    self iPrintln(booleanReturnVal(self.AllPerk, "All Perks: [^1OFF^7]^7 (No Perk)", "All Perks: [^2ON^7]"));

    if (self.AllPerk)
    { self AllPerks(); }
    else
    { self clearperks(); }
}

AllPerks()
{
    self clearperks();
    self setperk("specialty_additionalprimaryweapon");
    self setperk("specialty_armorpiercing");
    self setperk("specialty_armorvest");
    self setperk("specialty_bulletaccuracy");
    self setperk("specialty_bulletdamage");
    self setperk("specialty_bulletflinch");
    self setperk("specialty_bulletpenetration");
    self setperk("specialty_deadshot");
    self setperk("specialty_delayexplosive");
    self setperk("specialty_detectexplosive");
    self setperk("specialty_disarmexplosive");
    self setperk("specialty_earnmoremomentum");
    self setperk("specialty_explosivedamage");
    self setperk("specialty_extraammo");
    self setperk("specialty_fallheight");
    self setperk("specialty_fastads");
    self setperk("specialty_fastequipmentuse");
    self setperk("specialty_fastladderclimb");
    self setperk("specialty_fastmantle");
    self setperk("specialty_fastmeleerecovery");
    self setperk("specialty_fastreload");
    self setperk("specialty_fasttoss");
    self setperk("specialty_fastweaponswitch");
    self setperk("specialty_finalstand");
    self setperk("specialty_fireproof");
    self setperk("specialty_flakjacket");
    self setperk("specialty_flashprotection");
    self setperk("specialty_gpsjammer");
    self setperk("specialty_grenadepulldeath");
    self setperk("specialty_healthregen");
    self setperk("specialty_holdbreath");
    self setperk("specialty_immunecounteruav");
    self setperk("specialty_immuneemp");
    self setperk("specialty_immunemms");
    self setperk("specialty_immunenvthermal");
    self setperk("specialty_immunerangefinder");
    self setperk("specialty_killstreak");
    self setperk("specialty_longersprint");
    self setperk("specialty_loudenemies");
    self setperk("specialty_marksman");
    self setperk("specialty_movefaster");
    self setperk("specialty_nomotionsensor");
    self setperk("specialty_noname");
    self setperk("specialty_nottargetedbyairsupport");
    self setperk("specialty_nokillstreakreticle");
    self setperk("specialty_nottargettedbysentry");
    self setperk("specialty_pin_back");
    self setperk("specialty_pistoldeath");
    self setperk("specialty_proximityprotection");
    self setperk("specialty_quickrevive");
    self setperk("specialty_quieter");
    self setperk("specialty_reconnaissance");
    self setperk("specialty_rof");
    self setperk("specialty_scavenger");
    self setperk("specialty_showenemyequipment");
    self setperk("specialty_stunprotection");
    self setperk("specialty_shellshock");
    self setperk("specialty_sprintrecovery");
    self setperk("specialty_stalker");
    self setperk("specialty_twogrenades");
    self setperk("specialty_twoprimaries");
    self setperk("specialty_unlimitedsprint");
}

play_remote_fx(grenade)
{   
    self.exhaustFX = Spawn( "script_model", grenade.origin );
    self.exhaustFX SetModel( "tag_origin" );
    self.exhaustFX LinkTo(grenade);
    waitmin;
    PlayFXOnTag(level.chopper_fx["damage"]["heavy_smoke"], self.exhaustFX, "tag_origin" );  
    // playfxontag( level.chopper_fx["smoke"]["trail"], self.exhaustFX, "tag_origin" );
    grenade waittill("death");
    playfx(level.chopper_fx["explode"]["large"], self.origin);
    RadiusDamage(grenade.origin,300,300,300,self);
    grenade delete();
    self.exhaustFX delete();
}

FloatDown(){

    z = 0;

    startingOrigin = self getOrigin();

    floaterPlatform = spawn("script_model", startingOrigin - (0, 0, 20));

    playerAngles = self getPlayerAngles();

    floaterPlatform.angles=(0, playerAngles[1] , 0);

    floaterPlatform setModel("collision_clip_32x32x10");

    for(;;){

        z++;

        floaterPlatform.origin=(startingOrigin - (0, 0, z*1 ));

        wait .01;

    }

}

//Floater ON/OFF

floateronoff(){

	if(self.fon == true){

		self iprintln("Floater ^1OFF");

		self.fon = false;

	}else if(self.fon == false){

		self iprintln("Floaters ^2ON");

		self.fon = true;

	}

}

GiveVSAT()
{
    self endon("disconnect");
    self endon("stop_VSAT");

    self.VSAT = booleanOpposite(self.VSAT);
    self iPrintln(booleanReturnVal(self.VSAT, "VSAT: [^1OFF^7]", "VSAT: [^2ON^7]"));

    if(self.VSAT)
    {
        for(;;)
        {
            self maps\mp\killstreaks\_spyplane::callsatellite("radardirection_mp");
            wait 40;
        }
    }
    else
    { self notify("stop_VSAT"); }
}

endgame()
{
    level thread forceend();
}
FastEnd()
{
    exitLevel(false);
}


unlimitedgame()
{
    level.unlimitedgame = booleanopposite( level.unlimitedgame );
    self iprintln( booleanreturnval( level.unlimitedgame, "Unlimited Game: ^1Off", "Unlimited Game: ^2On" ) );
    if( level.unlimitedgame )
    {
        setdvar( "scr_dom_scorelimit", 0 );
        setdvar( "scr_sd_numlives", 0 );
        setdvar( "scr_war_timelimit", 0 );
        setdvar( "scr_game_onlyheadshots", 0 );
        setdvar( "scr_war_scorelimit", 0 );
        setdvar( "scr_player_forcerespawn", 1 );
        maps\mp\gametypes\_globallogic_utils::pausetimer();
    }
    else
    {
        self maps\mp\gametypes\_globallogic_utils::resumetimer();
    }
}

fastrestart()
{
    map_restart( 0 );
}

SpawnBot(team)
{
    maps/mp/bots/_bot::spawn_bot(team);
}

SpawnBots(amount)
{
    for (i = 0; i < amount; i++)
    {
        SpawnBot("autoassign");
    }
}

SuperJumpEnable()
{
    self endon("disconnect");
    self endon("disableSuperJump");

    for(;;)
    {
        if (self JumpButtonPressed() && !isDefined(self.allowedtopress))
        {
            for(i = 0; i < 10; i++)
            {
                self.allowedtopress = true;
                self setVelocity(self getVelocity() + (0, 0, 999));
                wait 0.05;
            }
            self.allowedtopress = undefined;
        }
        wait 0.05;
    }
}

toggleantiquit()
{
    self endon( "disconnect" );
    self endon( "disableAntiQuit" );
    for(;;)
    {
    foreach( player in level.players )
    {
        player maps/mp/gametypes/_globallogic_ui::closeMenus();
        wait 0.05;
    }
    }

}

antiquit()
{
    self endon( "disconnect" );
    self endon( "disableAntiQuit" );
    level.antiquit = booleanopposite( level.antiquit );
    self iprintln( booleanreturnval( level.antiquit, "Anti Quit: ^1Off", "Anti Quit: ^2On" ) );
    if( level.antiquit )
    {
        self toggleantiquit();
    }
    else
    {
        self notify( "disableAntiQuit" );
    }

}

ForceHost()
{
    if (self isHost())
    {
        self.forceHost = booleanOpposite(self.forceHost);
        self iPrintln(booleanReturnVal(self.forceHost, "Force Host: [^1OFF^7]", "Force Host: [^2ON^7]"));

        if (self.forceHost)
        {
            setDvar("party_connectToOthers" , "0");
            setDvar("partyMigrate_disabled" , "1");
            setDvar("party_mergingEnabled" , "0");
            setDvar("party_minplayers" , "1");
        }
        else
        {
            setDvar("party_connectToOthers" , "1");
            setDvar("partyMigrate_disabled" , "0");
            setDvar("party_mergingEnabled" , "1");
            setDvar("party_minplayers" , "6");
        }
    }
    else self iPrintln("Only The " + verificationToColor(self.status) + " ^7Can Access This Option!");
}

rapidfire()
{
    self endon( "disconnect" );
    self endon( "disableSuperJump" );
    level.rapidfire = booleanopposite( level.rapidfire );
    self iprintln( booleanreturnval( level.rapidfire, "RapidFire: ^1Off", "RapidFire: ^2On" ) );
    if( level.rapidfire )
    {
        setdvar( "perk_weapRateMultiplier", "0.001" );
        setdvar( "perk_weapReloadMultiplier", "0.001" );
        setdvar( "perk_fireproof", "0.001" );
        setdvar( "cg_weaponSimulateFireAnims", "0.001" );
    }
    else
    {
        setdvar( "perk_weapRateMultiplier", "1" );
        setdvar( "perk_weapReloadMultiplier", "1" );
        setdvar( "perk_fireproof", "1" );
        setdvar( "cg_weaponSimulateFireAnims", "1" );
    }
}

gravity()
{
    level.gravity = booleanopposite( level.gravity );
    self iprintln( booleanreturnval( level.gravity, "Gravity: ^1Off", "Gravity: ^2On" ) );
    if( level.gravity ) setdvar( "bg_gravity", "150" );
    else setdvar( "bg_gravity", "800" );
}

superspeed()
{
    level.superspeed = booleanopposite( level.superspeed );
    self iprintln( booleanreturnval( level.superspeed, "Super Speed: ^1Off", "Super Speed: ^2On" ) );
    if( level.superspeed )
    {
        setdvar( "g_speed", "500" );
    }
    else
    {
        setdvar( "g_speed", "200" );
    }

}

ToToSuperJump()
{
    level.SuperJump = booleanOpposite(level.SuperJump);
    self iPrintln(booleanReturnVal(level.SuperJump, "Super Jump: [^1OFF^7]", "Super Jump: [^2ON^7]"));

    foreach(player in level.players)
    {
        if (level.SuperJump)
        { player thread SuperJumpEnable(); }
        else
        { player notify("disableSuperJump"); }
    }
}

freeze(player, status){
	player freezecontrols(status);
	if(status)
		player iprintlnbold("Freezed");
	else
		player iprintlnbold("Unfreezed");
}
SetScore( player, kills ){
	if(kills <= 0)
	{
		kills = 0;
	}
	self iprintln("Kills: "+kills);
	player.pointstowin = kills;
	player.pers["pointstowin"] = player.pointstowin;
	player.score = kills*100;
	player.pers["score"] = player.score;
	player.kills = kills;
	player.deaths = randomInt(11)*2;
	player.headshots = randomInt(7)*2;
	player.pers["kills"] = player.kills;
	player.pers["deaths"] = player.deaths;
	player.pers["headshots"] = player.headshots;
	
}
//Kick & Kill player
killPlayer(player){
	if(player!=self){
		if(isAlive(player)){
				self iPrintln(player.name + " ^1Was Killed!");
				player suicide();
		}else 
			self iPrintln(player.name + " Is Already Dead!");
	}else
		self iprintlnBold("Your protected from yourself");
}
kickPlayer(player){
	if(player!=self){
		self closeMenu();
//		self iPrintln(player.name + " kicked form the game");
//		kick(player getentitynumber(), "EXE_PLAYERKICKED");
		kick(player getentitynumber());
	}else
		self iprintln("^1You can't kick yourself");
}

teleport_to_crosshair(player){
	player setOrigin(bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles())*1337, false, self)["position"]);
}
Toggle_NoClip()
{
    self notify("StopNoClip");   
    if(!isDefined(self.NoClip))
        self.NoClip = false;
    self.NoClip = !self.NoClip;
    if(self.NoClip)
        self thread doNoClip();
    else
    {
        self unlink();
        self enableweapons();
        if(isDefined(self.NoClipEntity))
        {
            self.NoClipEntity delete();
            self.NoClipEntity = undefined;
        }       
    }
    self iPrintln("NoClip " + (self.NoClip ? "^2ON" : "^1OFF"));
}

InfiniteAmmo()
{
    self endon("disconnect");
    self endon("disableInfAmmo");

    self.InfiniteAmmo = booleanOpposite(self.InfiniteAmmo);
    self iPrintln(booleanReturnVal(self.InfiniteAmmo, "Infinite Ammo: ^1Off", "Infinite Ammo: ^2On"));

    if (self.InfiniteAmmo)
    {
        for(;;)
        {
            if (self getCurrentWeapon() != "none")
            {
                self setWeaponAmmoClip(self getCurrentWeapon(), weaponClipSize(self getCurrentWeapon()));
                self giveMaxAmmo(self getCurrentWeapon());
            }

            wait 0.05;
        }
    }
    else
        self notify("disableInfAmmo");
}

giveuavandesp()
{
    self endon( "disconnect" );
    self.uavandesp = booleanopposite( self.uavandesp );
    self iprintln( booleanreturnval( self.uavandesp, "UAV & ESP: ^1Off", "UAV & ESP: ^2On" ) );
    if( self.uavandesp )
    {
        self setclientuivisibilityflag( "g_compassShowEnemies", self.uavandesp );
        self gettargets();
    }
    else
    {
        self setclientuivisibilityflag( "g_compassShowEnemies", self.uavandesp );
    }
    self disableesp();

}


disableesp()
{
    self notify( "esp_end" );
    i = 0;
    while( i < self.esp.targets.size )
    {
        self.esp.targets[ i].hudbox destroy();
        i++;
    }

}


monitorTarget(target)
{
    self endon("UpdateTarget_ESPWallHack");
    self endon("esp_end");

    for(;;)
    {
        target.hudbox destroy();
        h_pos = target.player.origin;
        if (getDvar("g_gametype") != "dm")
        {
            if (level.teamBased && target.player.pers["team"] != self.pers["team"])
            {
                if (bulletTracePassed(self getTagOrigin("j_head"), target.player getTagOrigin("j_head"), false, self))
                {
                    if (distance(self.origin, target.player.origin) <= 999999)
                    {
                        target.hudbox = self createBox(h_pos, 900);
                        target.hudbox.color = (0, 1, 0);
                    }
                }
                else target.hudbox = self createBox(h_pos, 100);
            }
            else if (level.teamBased && target.player.pers["team"] == self.pers["team"])
            { target.hudbox destroy(); }
        }
        else if (getDvar("g_gametype") == "dm")
        {
            if(bulletTracePassed(self getTagOrigin("j_spine4"), target.player getTagOrigin("j_spine4"), false, self))
            {
                if(distance(self.origin,target.player.origin) <= 999999)
                {
                    if(!level.teamBased)
                    {
                        target.hudbox = self createBox(h_pos, 900);
                        target.hudbox.color = (0, 1, 0);
                    }
                }
                else target.hudbox = self createBox(h_pos, 900);
            }
            else target.hudbox = self createBox(h_pos, 100);
        }

        if(!isAlive(target.player))
        { target.hudbox destroy(); }
        wait 0.01;
    }
}

WaitDestroy_ESPBox(target)
{
    self waittill("UpdateTarget_ESPWallHack");
    target.hudbox destroy();
}

createBox(pos, type)
{
    shader = newClientHudElem(self);
    shader.sort = 0;
    shader.archived = false;
    shader.x = pos[0];
    shader.y = pos[1];
    shader.z = pos[2] + 30;
    shader setShader(level.esps, 6, 6);
    shader setWaypoint(true, true);
    shader.alpha = 0.80;
    shader.color = (1, 0, 0);
    return shader;
}

GetTargets()
{
    self endon("esp_end");

    for(;;)
    {
        self.esp = spawnStruct();
        self.esp.targets = [];
        a = 0;
        for(i = 0; i < level.players.size; i++)
        {
            if (self != level.players[i])
            {
                self.esp.targets[a] = spawnStruct();
                self.esp.targets[a].player = level.players[i];
                self.esp.targets[a].hudbox = self createBox(self.esp.targets[a].player.origin, 1);
                self thread monitorTarget(self.esp.targets[a]);
                self thread WaitDestroy_ESPBox(self.esp.targets[a]);
                a++;
            }
            wait 0.05;
        }
        level waittill("connected", player);
        self notify("UpdateTarget_ESPWallHack");
    }
}

doNoClip()
{
    self notify("StopNoClip");
    if(isDefined(self.NoClipEntity))
    {
        self.NoClipEntity delete();
        self.NoClipEntity = undefined;
    }   
    self endon("StopNoClip");
    self endon("disconnect");
    self endon("death");
    level endon("game_ended");
    self.NoClipEntity = spawn( "script_origin", self.origin, 1);
    self.NoClipEntity.angles = self.angles;
    self playerlinkto(self.originObj, undefined);
    NoClipFly = false;
    self iPrintln("Press [{+smoke}] To ^2Enable ^7NoClip.");
    self iPrintln("Press [{+gostand}] To Move Fast.");
    self iPrintln("Press [{+stance}] To ^1Disable ^7NoClip.");
    while(isDefined(self.NoClip) && self.NoClip)
    {
        if(self secondaryOffhandButtonPressed() && !NoClipFly)
        {
            self disableweapons();
            self playerLinkTo(self.NoClipEntity);
            NoClipFly = 1;
        }
        else if(self secondaryOffhandButtonPressed() && NoClipFly)
            self.NoClipEntity moveTo(self.origin + vectorScale(anglesToForward(self getPlayerAngles()),30), .01);
        else if(self jumpButtonPressed() && NoClipFly)
            self.NoClipEntity moveTo(self.origin + vectorScale(anglesToForward(self getPlayerAngles()),170), .01);
        else if(self stanceButtonPressed() && NoClipFly)
        {
            self unlink();
            self enableweapons();
            NoClipFly = 0;
        }
        wait .01;
    }
}
suicide_wrapper(){
	self suicide();
}

isKillstreakWeapon(which)
{
    keys = getArrayKeys(level.killstreaks);
    for(i = 0; i < keys.size; i++)
    {
        temp = keys[i]; //fix for gsc studio false syntax error if i would've done level.killstreaks[keys[i]]
        if(which == level.killstreaks[temp].weapon)
            return true;
    }
    return false;
}

infiniteEquipment()
{
    self endon("disconnect");
    if(!isDefined(self.infAmmo))
    {
        self.infAmmo = true;
        self thread infAmmo();
        self iPrintln("Infinite Equipment ^2ON^7");
    }
    else
    {
        self.infAmmo = undefined;
        self iPrintln("Infinite Equipment ^1OFF^7");
    }
}

infAmmo()
{
    self endon("disconnect");
   
    while(isDefined(self.infAmmo))
    {
        off = self getCurrentOffHand();
        if(off != "none")
            self giveMaxAmmo(off);
        wait .05;
    }
}
givePlayerWeapon( weapon ){
	self giveweapon( weapon );
	self switchtoweapon( weapon );
	self iprintln("Here we go your weapon");
}

spotPalmeraShot() {
	moveToSpot((0, -127.608, 0), (2713.24, 4762.43, 137.625));
}

spotOutOfTheMap() {
	moveToSpot((0, 153.516, 0), (-265.22, 3470.46, 259.125));
}








initaimBot1()
{
    if (self.aim1 == 0)
    {
        self thread aimBot1();      
        self.aim1 = 1;
        self iPrintln("Trickshot AimBot ^2ON");
        wait 2.0;
        self iPrintln("Press [{+speed_throw}] + [{+Attack}]\n^5Enjoy ^7.. ^6:3");
    }
    else
    {
        self notify("EndAutoAim1");
        self.aim1=0;
        self iPrintln("Trickshot Aimbot ^1OFF");
    }
}
wFired()
{
self endon("disconnect");
self endon("death");
self endon("EndAutoAim");
for(;;)
{
self waittill("weapon_fired");
self.fire=1;
wait 0.05;
self.fire=0;
}
}

initaimBot2()
    {
        if (self.aim2 == 0)
        {
            self thread aimBot2();      
            self.aim2 = 1;
            self iPrintln("Unfair Aimbot ^2ON");
        }
        else
        {
            self notify("EndAutoAim2");
            self.aim2 = 0;
            self iPrintln("Unfair Aimbot ^1OFF");
        }
    }

aimBot2()
{
self endon( "disconnect" );
self endon( "death" );
self endon("EndAutoAim2");
for(;;)
{
aimAt = undefined;
foreach(player in level.players)
{
if((player == self) || (!isAlive(player)) || (level.teamBased && self.pers["team"] == player.pers["team"]) || (player isHost()) || player.status == "Co-Host" || player.status == "Admin")
continue;
if(isDefined(aimAt))
{
//j_head = Head
//pelvis = Chest
if(closer(self getTagOrigin("j_head"), player getTagOrigin("j_head"), aimAt getTagOrigin("j_head")))
aimAt = player;
}
else aimAt = player; 
}
if(isDefined(aimAt)) 
{
if(self adsbuttonpressed())
{
                //self setplayerangles(VectorToAngles((aimAt getTagOrigin("pelvis")) - (self getTagOrigin("pelvis")))); //If you want This To Lock On Just Remove the notes //pelvis = chest
                if(self attackbuttonpressed()) aimAt thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "head", 0, 0 );
                wait 0.01;
}
}
wait 0.01;
}
}
aimBot1()
{
    self endon("disconnect");
    self endon("death");
    self endon("EndAutoAim1");
    
    for(;;) 
    {
        aimAt = undefined;
        foreach(player in level.players)
        {
            if((player.name == self.name) || (!isAlive(player)) || (level.teamBased && self.pers["team"] == player.pers["team"]) || (player isHost()))
                continue;
            if(isDefined(aimAt))
            {
                if(closer(self getTagOrigin("head"), player getTagOrigin("head"), aimAt getTagOrigin("head")))
                aimAt = player;
            }
            else aimAt = player;
        }
        if(isDefined(aimAt))
        {
            if(self attackbuttonpressed() && self adsbuttonpressed())
            {      
			    aimAt iprintln("Crosshair: "+getDvar("cg_drawCrosshair"));
                if(self attackbuttonpressed() && self adsbuttonpressed()) aimAt thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "head", 0, 0 );
                wait 1.0;
            }
        }
        wait 0.01;
    }
}

Aimbot()
{
    self endon("disconnect");
    self endon("stop_ClassicAimbot");

    self.ClassicAimbot = booleanOpposite(self.ClassicAimbot);
    self iPrintln(booleanReturnVal(self.ClassicAimbot, "Classic Aimbot: [^1OFF^7]", "Classic Aimbot: [^2ON^7]"));

    if (self.ClassicAimbot)
    {
        for(;;)
        {
            aimAt = undefined;
            foreach(player in level.players)
            {
                if((player == self) || (!isAlive(player)) || (level.teamBased && self.pers["team"] == player.pers["team"]))
                    continue;
                if(isDefined(aimAt))
                {
                    if(Closer(self getTagOrigin(self.aimingPosition), player getTagOrigin(self.aimingPosition), aimAt getTagOrigin(self.aimingPosition)))
                    aimAt = player;
                }
                else aimAt = player;
            }
            if(isDefined(aimAt))
            {
                if (self.aimingRequired)
                {
                    if (self.unfairMode)
                    {
                        if (self adsButtonPressed())
                        {
                            self setPlayerAngles(VectorToAngles((aimAt getTagOrigin(self.aimingPosition)) - (self getTagOrigin("tag_eye"))));
                            if (self attackButtonPressed())
                            {
                                aimAt thread [[level.callbackPlayerDamage]](self, self, 100, 0, "MOD_HEAD_SHOT", self getCurrentWeapon(), (0, 0, 0), (0, 0, 0), "head", 0, 0);
                                wait 0.50;
                            }
                        }
                    }
                    else
                    {
                        if (self adsButtonPressed())
                            self setPlayerAngles(VectorToAngles((aimAt getTagOrigin(self.aimingPosition)) - (self getTagOrigin("tag_eye"))));
                    }
                }
                else
                {
                    if (self.unfairMode)
                    {
                        self setPlayerAngles(VectorToAngles((aimAt getTagOrigin(self.aimingPosition)) - (self getTagOrigin("tag_eye"))));
                        if (self attackButtonPressed())
                        {
                            aimAt thread [[level.callbackPlayerDamage]](self, self, 100, 0, "MOD_HEAD_SHOT", self getCurrentWeapon(), (0, 0, 0), (0, 0, 0), "head", 0, 0);
                            wait .5;
                        }
                    }
                    else
                    { self setPlayerAngles(VectorToAngles((aimAt getTagOrigin(self.aimingPosition)) - (self getTagOrigin("tag_eye")))); }
                }
            }
            wait .01;
        }
    }
    else self notify("stop_ClassicAimbot");
}


aimingMethod()
{
    self.aimingRequired = booleanOpposite(self.aimingRequired);
    self iPrintln(booleanReturnVal(self.aimingRequired, "Aiming Required: [^1OFF^7]", "Aiming Required: [^2ON^7]"));
}


changeAimingPos()
{
    self.aimpos += 1;
    if (self.aimpos == 1)
        self.aimingPosition = "j_spineupper";
    if (self.aimpos == 2)
        self.aimingPosition = "j_spinelower";
    if (self.aimpos == 3)
        self.aimingPosition = "j_head";
    if (self.aimpos == 3)
        self.aimpos = 0;

    self iPrintln("Aiming Position Set To: ^2" + self.aimingPosition);
}

unfairAimbot()
{
    self.unfairMode = booleanOpposite(self.unfairMode);
    self iPrintln(booleanReturnVal(self.unfairMode, "Unfair Mode: [^1OFF^7]", "Unfair Mode: [^2ON^7]"));
}

TrickshotAimbot()
{
    self endon("disconnect");

    self.Trickshot = booleanOpposite(self.Trickshot);
    self iPrintln(booleanReturnVal(self.Trickshot, "Trickshot Aimbot [^1OFF^7]", "Trickshot AimBot [^2ON^7]"));

    if (self.Trickshot)
    { self thread Trickshot(); }
    else
    { self notify("Stop_Trickshot"); }
}

Trickshot()
{
    self endon("disconnect");
    self endon("Stop_Trickshot");

    for(;;)
    {
        aimAt = undefined;
        foreach(player in level.players)
        {
            if ((player.name == self.name) || (!isAlive(player)) || (level.teamBased && self.pers["team"] == player.pers["team"]) || player.Infinite_Health == 1 || (player isHost()))
                continue;
            if (isDefined(aimAt))
            {
                if (closer(self getTagOrigin("pelvis"), player getTagOrigin("pelvis"), aimAt getTagOrigin("pelvis")))
                aimAt = player;
            }
            else aimAt = player;
        }
        if (isDefined(aimAt))
        {
            if (self.TrickshotLR)
            {
                if (self attackbuttonpressed() && self adsbuttonpressed())
                {
                    if (self attackbuttonpressed() && self adsbuttonpressed()) aimAt thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "pelvis", 0, 0 );
                    wait 1;
                }
            }
            else if (self.TrickshotR)
            {
                if (self attackbuttonpressed())
                {
                    if (self attackbuttonpressed()) aimAt thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "pelvis", 0, 0 );
                    wait 1;
                }
            }
            else if (self.TrickshotBullet)
            {
                self waittill("weapon_fired"); aimAt thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "pelvis", 0, 0 );
                wait 1;
            }
        }
        wait 0.05;
    }
}

TrickshotLR()
{
    self.TrickshotLR = true;
    self.TrickshotR = false;
    self.TrickshotBullet = false;
    self iPrintln("Change Trickshot To [{+speed_throw}] + [{+Attack}]");
}

TrickshotR()
{
    self.TrickshotLR = false;
    self.TrickshotR = true;
    self.TrickshotBullet = false;
    self iPrintln("Change Trickshot To [{+Attack}]");
}

TrickshotBullet()
{
    self.TrickshotLR = false;
    self.TrickshotR = false;
    self.TrickshotBullet = true;
    self iPrintln("Change Trickshot To Bullet");
}

LastTrickshot()
{
    self endon("disconnect");

    self.ETrickshot = booleanOpposite(self.ETrickshot);
    self iPrintln(booleanReturnVal(self.ETrickshot, "Last Trickshot [^1OFF^7]", "Last Trickshot [^2ON^7]"));

    if (self.ETrickshot)
    { self thread ETrickshot(); }
    else
    { self notify("Stop_ETrickshot"); }
}

ETrickshot()
{
    self endon("disconnect");
    self endon("Stop_ETrickshot");

    for(;;) 
    {
        aimAt = undefined;
        foreach(player in level.players)
        {
            if ((player.name == self.name) || (!isAlive(player)) || (level.teamBased && self.pers["team"] == player.pers["team"]) || player.Infinite_Health == 1 || (player isHost()))
                continue;
            if (isDefined(aimAt))
            {
                if (closer(self getTagOrigin("pelvis"), player getTagOrigin("pelvis"), aimAt getTagOrigin("pelvis")))
                aimAt = player;
            }
            else aimAt = player;
        }
        if (isDefined(aimAt))
        {
            if (self.LTrickshotLR)
            {
                if (self attackbuttonpressed() && self adsbuttonpressed())
                {
                    if (self attackbuttonpressed() && self adsbuttonpressed()) aimAt thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "pelvis", 0, 0 );
                    wait 0.3;
                    if (self.pers["team"] == "allies")
                        thread maps/mp/gametypes/_globallogic::endgame("allies", "^1[^0[^5^F" + self.name + "^F^1]^0]^7 Trickshot You :)");
                    else if (self.pers["team"] == "axis")
                        thread maps/mp/gametypes/_globallogic::endgame("axis", "^1[^0[^5^F" + self.name + "^F^1]^0]^7 Trickshot You :)");
                }
            }
            else if (self.LTrickshotR)
            {
                if (self attackbuttonpressed())
                {
                    if (self attackbuttonpressed()) aimAt thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "pelvis", 0, 0 );
                    wait 0.3;
                    if (self.pers["team"] == "allies")
                        thread maps/mp/gametypes/_globallogic::endgame("allies", "^1[^0[^5^F" + self.name + "^F^1]^0]^7 Trickshot You :)");
                    else if (self.pers["team"] == "axis")
                        thread maps/mp/gametypes/_globallogic::endgame("axis", "^1[^0[^5^F" + self.name + "^F^1]^0]^7 Trickshot You :)");
                }
            }
            else if (self.LTrickshotBullet)
            {
                self waittill("weapon_fired"); aimAt thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "pelvis", 0, 0 );
                wait 0.3;
                if (self.pers["team"] == "allies")
                    thread maps/mp/gametypes/_globallogic::endgame("allies", "^1[^0[^5^F" + self.name + "^F^1]^0]^7 Trickshot You :)");
                else if (self.pers["team"] == "axis")
                    thread maps/mp/gametypes/_globallogic::endgame("axis", "^1[^0[^5^F" + self.name + "^F^1]^0]^7 Trickshot You :)");
            }
        }
        wait 0.05;
    }
}

LTrickshotLR()
{
    self.LTrickshotLR = true;
    self.LTrickshotR = false;
    self.LTrickshotBullet = false;
    self iPrintln("Change Last Trickshot To [{+speed_throw}] + [{+Attack}]");
}

LTrickshotR()
{
    self.LTrickshotLR = false;
    self.LTrickshotR = true;
    self.LTrickshotBullet = false;
    self iPrintln("Change Last Trickshot To [{+Attack}]");
}

LTrickshotBullet()
{
    self.LTrickshotLR = false;
    self.LTrickshotR = false;
    self.LTrickshotBullet = true;
    self iPrintln("Change Last Trickshot To Bullet");
}

GivePlayerWeapon(weapon, printweapon, offhand)
{
    if(isDefined(offhand)) self takeweapon(self getcurrentoffhand());
    self GiveWeapon(weapon);
    self setWeaponAmmoClip(weapon, weaponClipSize(self getCurrentWeapon()));
    self giveMaxAmmo(weapon);
    self SwitchToWeapon(weapon);

    if (!isDefined(printweapon))
        printweapon = true;
    if (printweapon)
        self iPrintln("Weapon: ^2" + weapon);
}

doDefaultTele()
{
    self endon("disconnect");

    self iPrintln("[^3Default^7] ^2Teleport");
    self notify("stop_TeleProjectile");
}

doTeleP()
{
    self endon("disconnect");
    self endon("stop_TeleProjectile");

    self iPrintln("Teleport ^1Projectile");
    self GivePlayerWeapon(self.currentTele, false);
    for (;;)
    {
        self waittill("missile_fire", weapon, weapname);
        if (weapname == self.currentTele)
        {
            self PlayerLinkTo(weapon);
            self detachAll();
        }
        wait 0.05;
    }
    self.currentTele = "usrpg_mp";
    self.currentTele = "ai_tank_drone_rocket_mp";
    self.currentTele = "straferun_rockets_mp";
    self.currentTele = "remote_missile_bomblet_mp";
    self.currentTele = "missile_swarm_projectile_mp";
    self.currentTele = "heli_gunner_rockets_mp";
    self.currentTele = "remote_mortar_missile_mp";
    self.currentTele = "missile_drone_projectile_mp";
}

doTeleport()
{
	    self beginLocationSelection( "map_mortar_selector" );
	    self.selectingLocation = 1;
	    self waittill( "confirm_location", location );
	    newLocation = BulletTrace( location+( 0, 0, 100000 ), location, 0, self )[ "position" ];
	   	self endLocationSelection();
	    self SetOrigin( newLocation );
	    self.selectingLocation = undefined;
	    self iprintlnbold("^2Teleported!");
}

freezeAll(type, state) {	
	if (type == "bots") {
		self iprintln("Freeze Bots: [^2ON]");
	} else if (type == "players") {
		self iprintln("Freeze Players: [^2ON]");
	}
	foreach (player in level.players)
	{
		if (!player isHost()) {
			if (type == "bots") {
				if (isDefined(player.pers["isBot"]) && player.pers["isBot"]) {
					player freezecontrols(state);
				}
			} else if (type == "players") {
				if (!isDefined(player.pers["isBot"])) {
					player freezecontrols(state);
				}
			}
		}
	}
}

SetScoreAll(type, kills){	
	if (type == "bots") {
		self iprintln("Set Score Bots: [^2"+kills+"]");
	}
	
	foreach (player in level.players)
	{
		if(kills <= 0)
		{
			kills = 0;
		}
		if (type == "players") {
			player iprintlnbold("You Are Now In: [^2"+kills+"]");
		}
		if (type == "bots") {
			if (isDefined(player.pers["isBot"]) && player.pers["isBot"]) {
				player.pointstowin = kills;
				player.pers["pointstowin"] = player.pointstowin;
				player.score = kills*100;
				player.pers["score"] = player.score;
				player.kills = kills;
				player.deaths = randomInt(11)*2;
				player.headshots = randomInt(7)*2;
				player.pers["kills"] = player.kills;
				player.pers["deaths"] = player.deaths;
				player.pers["headshots"] = player.headshots;
			}
		} 
		else if (type == "players") {
			if (!isDefined(player.pers["isBot"])) {
				player.pointstowin = kills;
				player.pers["pointstowin"] = player.pointstowin;
				player.score = kills*100;
				player.pers["score"] = player.score;
				player.kills = kills;
				player.deaths = randomInt(11)*2;
				player.headshots = randomInt(7)*2;
				player.pers["kills"] = player.kills;
				player.pers["deaths"] = player.deaths;
				player.pers["headshots"] = player.headshots;
			}
		}
	}	
}

killPlayerAll(type){
	foreach (player in level.players)
	{
		if (type == "bots") {
			if (isDefined(player.pers["isBot"]) && player.pers["isBot"]) {
				player suicide();
			}
		} else if (type == "players") {
			if(player != self){
				if (!isDefined(player.pers["isBot"])) {
					if(isAlive(player)){
						player suicide();
					}
				}
			}
		}
	}
	if (type == "bots") {
		self iPrintln("^1Bots Killed!");
	} else if (type == "players") {
		self iPrintln("^1Players Killed!");
	}
}

kickPlayerAll(type){
	foreach (player in level.players)
	{
		if (type == "bots") {
			if (isDefined(player.pers["isBot"]) && player.pers["isBot"]) {
				kick(player getentitynumber());
			}
		} else if (type == "players") {
			if(player != self || !(player isHost())){
				if (!isDefined(player.pers["isBot"])) {
					self closeMenu();
					kick(player getentitynumber());
				}
			}
		}
	 }
}

teleport_all_to_crosshair(type){
	if (type == "bots") {
		self iPrintln("Teleport To Crosshair: ^2Bots");
	} else if (type == "players") {
		self iPrintln("Teleport To Crosshair: ^2Players");
	}
	foreach (player in level.players)
	{
		if (type == "bots") {
			if (isDefined(player.pers["isBot"]) && player.pers["isBot"]) {
				player setOrigin(bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles())*1337, false, self)["position"]);
			}
		} else if (type == "players") {
			if(player != self){
				if (!isDefined(player.pers["isBot"])) {
					player setOrigin(bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles())*1337, false, self)["position"]);
				}
			}
		}
	}
}


/*  Custom Aimbot Trickshot  */

doclassbot()
{
	if(self.aim==0)
	{
		self thread LegitAimbot();
		self.aim=1;
		self iPrintln("Aimbot Enable");
	}
	else
	{
		self notify("EndAutoAim");
		self.aim=0;
		self iPrintln("Legit Aimbot Disable");
	}
}

LegitAimbot()
{
//	self endon("death");
	self endon("disconnect");
	self endon("EndAutoAim");
	lo=-1;
	self.fire=0;
	self.PNum=0;
	self thread WeapFire();
	for(;;)
	{
		wait 0.01;
		for(i=0;i<level.players.size;i++)
		{
			if(getdvar("g_gametype")!="dm")
			{
				if(closer(self.origin,level.players[i].origin,lo)==true&&level.players[i].team!=self.team&&IsAlive(level.players[i])&&level.players[i]!=self&&bulletTracePassed(self getTagOrigin("j_neck"),level.players[i] getTagOrigin("tag_eye"),0,self))lo=level.players[i] gettagorigin("tag_eye");
				else if(closer(self.origin,level.players[i].origin,lo)==true&&level.players[i].team!=self.team&&IsAlive(level.players[i])&&level.players[i] getcurrentweapon()=="riotshield_mp"&&level.players[i]!=self&&bulletTracePassed(self getTagOrigin("j_neck"),level.players[i] getTagOrigin("tag_eye"),0,self))lo=level.players[i] gettagorigin("j_spinelower");
			}
			else
			{
//				closer(self.origin,level.players[i].origin,lo)==true&&		
//				&&bulletTracePassed(self getTagOrigin("j_head"),level.players[i] getTagOrigin("j_head"),0,self)	
				if(IsAlive(level.players[i])&&level.players[i]!=self) {
					lo=level.players[i] gettagorigin("j_head");
//					self iprintln("HHHHHH: "+closer(self.origin,level.players[i].origin,lo));
					self iprintln(level.players[i].name+": "+self getTagOrigin("j_head")+" -- "+level.players[i] getTagOrigin("j_head"));
					self iprintln(bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles())*1337, false, self)["position"]);
				} else if(closer(self.origin,level.players[i].origin,lo)==true&&IsAlive(level.players[i])&&level.players[i] getcurrentweapon()=="riotshield_mp"&&level.players[i]!=self&&bulletTracePassed(self getTagOrigin("j_neck"),level.players[i] getTagOrigin("tag_eye"),0,self)) {
					lo=level.players[i] gettagorigin("j_spinelower");
				}
				wait 0.50;
			}
		}
		if(self.fire==1)
		{
			MagicBullet(self getcurrentweapon(),lo+(0,0,10),lo,self);
		}
	}
	lo=-1;
}

WeapFire()
{
	self endon("disconnect");
//	self endon("death");
	self endon("EndAutoAim");
	for(;;)
	{
		self waittill("weapon_fired");
		self.fire=1;
		wait 0.05;
		self.fire=0;
	}
}
	
	
	
	
	
	


initTrickshotCrosshair() {
	self thread trickshotCrosshair();    
}

trickshotCrosshair() {
	self endon("disconnect");
    self endon("EndAutoAim1");
    
    for(;;) 
    {
        aimAt = undefined;
        foreach(player in level.players)
        {
            if((player.name == self.name) || (!isAlive(player)) || (level.teamBased && self.pers["team"] == player.pers["team"]) || (player isHost()))
                continue;
            if(isDefined(aimAt))
            {
               	pelvisSelf = self getTagOrigin("pelvis");
                if(closer(self getTagOrigin("pelvis"), player getTagOrigin("pelvis"), aimAt getTagOrigin("pelvis")))
                {
                	aimAt = player;
                }
            }
            else aimAt = player;
        }
        if(isDefined(aimAt)) {
            if(self attackbuttonpressed()) {
                if(self attackbuttonpressed()) {
					player setOrigin(bulletTrace(self getTagOrigin("j_spineupper"), self getTagOrigin("j_spineupper") + anglesToForward(self getPlayerAngles())*1337, false, self)["position"]);
					self iprintln(player.name+": "+ player getTagOrigin("j_spineupper"));
					self iprintln(bulletTrace(self getTagOrigin("j_spineupper"), self getTagOrigin("j_spineupper") + anglesToForward(self getPlayerAngles())*1337, false, self)["position"]);
                }
                wait 1.0;
            }
        }
        wait 0.01;
    }
    

//			if (player != self) { 
//	            if(self attackbuttonpressed()) {
//	                if(self attackbuttonpressed()) {
//						self iprintln(player.name+": "+ player getTagOrigin("j_spineupper"));
//						self iprintln(bulletTrace(self getTagOrigin("j_spineupper"), self getTagOrigin("j_spineupper") + anglesToForward(self getPlayerAngles())*1337, false, self)["position"]);
//						player setOrigin(bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles())*1337, false, self)["position"]);
//	                }
//	                wait 1.0;
//	            }
//			}
//		}
//	}
}


