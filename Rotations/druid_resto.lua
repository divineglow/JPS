function druid_resto(self)
	-- INFO --
	-- Shift-key to cast Tree of Life
	-- jps.MultiTarget to Wild Regrowth
	-- Use Innervate and Tranquility manually

	--healer
	local playerMana = UnitMana("player")/UnitManaMax("player") * 100
	local tank = nil
	local me = "player"

	-- Tank is focus.
	tank = jps.findMeATank()

    -- Check if we should cleanse
    local cleanseTarget = nil
    local hasSacredCleansingTalent = 0
    _,_,_,_,hasSacredCleansingTalent = 1 -- GetTalentInfo(1,14) JPTODO: find the resto talent
    if hasSacredCleansingTalent == 1 then
      cleanseTarget = jps.FindMeADispelTarget({"Poison"},{"Curse"},{"Magic"})
    else
      cleanseTarget = jps.FindMeADispelTarget({"Poison"},{"Curse"})
    end

	--Default to healing lowest partymember
	local defaultTarget = jps.lowestInRaidStatus()

	--Check that the tank isn't going critical, and that I'm not about to die
    if jps.canHeal(tank) and jps.hpInc(tank) <= 0.2 then defaultTarget = tank end
	if jps.hpInc(me) < 0.2 then	defaultTarget = me end

	--Get the health of our decided target
	local defaultHP = jps.hpInc(defaultTarget)
	
	local spellTable =
	{
		-- rebirth Ctrl-key + mouseover
		--{ "rebirth", 			IsControlKeyDown() ~= nil and UnitIsDeadOrGhost("mouseover") ~= nil and IsSpellInRange("rebirth", "mouseover"), "mouseover" },
		
		-- CDs 
		{ "nature's swiftness", defaultHP < 0.40 },
		{ "Nature's Vigil", jps.UseCDs},
		{ "lifebloom",			(jps.buffDuration("lifebloom",tank) < 1.5 or jps.buffStacks("lifebloom",tank) < 3) and jps.hpInc(tank) <= 0.99, tank },
		{ "barkskin",			jps.hp() < 0.50 },
		{ "tree of life",		IsShiftKeyDown() ~= nil and GetCurrentKeyBoardFocus() == nil },

		--Decurse
		{ "remove corruption",	cleanseTarget~=nil, cleanseTarget },

		{ "regrowth",			defaultHP < 0.50 or (jps.buff("clearcasting") and defaultHP < 0.78), defaultTarget },
		{ "healing touch", 		(jps.buff("nature's swiftness") or not jps.Moving) and defaultHP < 0.45, defaultTarget },
		{ "swiftmend",			defaultHP < 0.75 and (jps.buff("rejuvenation",defaultTarget) or jps.buff("regrowth",defaultTarget)), defaultTarget },
		{ "swiftmend",		    jps.hpInc(tank) <= 0.95 and (jps.buff("rejuvenation",tank) or jps.buffDuration("rejuvenation",tank) < 2), tank },

		--Mana
		{ "Innervate", 			playerMana < 50, me },

		{ "wild growth",		defaultHP < 0.95 and jps.MultiTarget, defaultTarget },

		{ "rejuvenation",		defaultHP < 0.80 and (not jps.buff("rejuvenation",defaultTarget) or jps.buffDuration("rejuvenation",defaultTarget) < 2), defaultTarget },
		{ "rejuvenation",		defaultHP < 0.80 and not (jps.buff("rejuvenation",defaultTarget)), defaultTarget },
		{ "rejuvenation",		jps.hpInc(tank) <= 0.90 and (not jps.buff("rejuvenation",tank) or jps.buffDuration("rejuvenation",tank) < 2), tank },
	
		{ "nourish",			defaultHP < 0.70, defaultTarget or (jps.buffDuration("rejuvenation",defaultTarget) < 2) and defaultHP < 0.85, defaultTarget },
		{ "nourish",			jps.hpInc(tank) < 0.65 and jps.buffDuration("lifebloom",tank) < 3, tank },
		
	}

	local spell,target = parseSpellTable(spellTable)
	jps.Target = target
	return spell
	
end
