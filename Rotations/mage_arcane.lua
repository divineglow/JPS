function mage_arcane(self)
   
if UnitCanAttack("player","target")~=1 or UnitIsDeadOrGhost("target")==1 then return end

local atBuffed = jps.buff("alter time","player")
local apBuffed = jps.buff("Arcane Power", "player")
local stacks = jps.debuffStacks("arcane charge","player")
local aDuration = jps.debuffDuration("arcane charge","player")
local manaGemCharges = GetItemCount("mana gem",0,1) 
local playerMana = UnitMana("player")/UnitManaMax("player")  

local spellTable =
{

	-- 5.2 Section.  This is based on early Noxxic suggestions.  
	
  
  -- Kick Somethings Ass Real Quick
  { "arcane blast",          IsLeftControlKeyDown() ~= nil },
  
  {"Incanter's Ward",		 not jps.buff("Incanter's Ward", "player")},
  
  -- Lets Go Ahead and Make a Rune at the Top
  { "Rune of Power",      	 IsShiftKeyDown() ~= nil },
  
  -- Forget your Buffs ?  Silly Rabbit
  { "Mage Armor",            not jps.buff("Mage Armor","player") },
  { "Arcane Brilliance",     not jps.buff("Arcane Brilliance","player") },
  
  -- Oh Shit, We are About to Die
  { "Ice Block",             ((UnitHealth("player") / UnitHealthMax("player")) < 0.10 ) and not jps.buff("Ice Block","player") },
   
  --CDs 5.2
  { "Mirror Image",          jps.UseCDs and apBuffed},
  { "arcane power",      	 jps.buffStacks("arcane missiles!","player") == 2 and jps.UseCDs and not atBuffed and stacks == 4 },
  { { "macro","/use 10"},    jps.glovesCooldown() == 0 and jps.UseCDs},
  { jps.useTrinket(1),       jps.UseCDs and apBuffed },
  { jps.useTrinket(2),       jps.UseCDs and apBuffed },
  { jps.DPSRacial,           jps.UseCDs },
  { "Nether Tempest",        not jps.debuff("Nether Tempest") },
  { "alter time",            not jps.buff("Alter Time", "player") and jps.UseCDs and apBuffed },
  

  -- Lets Spellsteal if We Can!
 -- {"Spellsteal", 			 },
  
  -- Moving 5.2
  { "Arcane Barrage",     	 stacks == 4 }, -- jps.Moving and aDuration < 3 },
  -- Need to Review Changes  { "Fire Blast",         jps.Moving and jps.debuff("Living Bomb") },
  { "Fire Blast",            jps.Moving }, -- not Mana usefull anymore ?
  { "Ice Lance",          	 jps.Moving },
  
  -- Interupts 5.2 
  { "Counterspell",          jps.Interrupts and jps.shouldKick("target") },
  
  -- Mana Regen 5.2
  { {"macro","/use Brilliant Mana Gem"}, IsUsableItem(81901)==1 and jps.itemCooldown(81901)==0 and jps.mana("player") <= 0.85  },
  
  
  -- Main DPS Rotation 5.2
  { "arcane missiles",   	 jps.buffStacks("arcane missiles!","player") == 2 },
  { "Arcane Barrage",        jps.Moving and aDuration < 3 }, 
  { "arcane blast",       	  },
  --{ "Scorch",                jps.mana() < 0.90 },
  
  
  
  
  
  
  
  
  
  
  
  

  --CDs
  --{ "Mirror Image",          jps.UseCDs },
  --{ { "macro","/use 10"},    jps.glovesCooldown() == 0 and jps.UseCDs},
 -- { jps.useTrinket(1),       jps.UseCDs },
 -- { jps.useTrinket(2),       jps.UseCDs },
--  { jps.DPSRacial,           jps.UseCDs },
 -- { "arcane power",      	 jps.UseCDs and not atBuffed and stacks == 6 },
  
  -- Arcane Blast to quickly kick somethings ass
 -- { "arcane blast",          IsLeftControlKeyDown() ~= nil },
 -- { "arcane blast",          atBuffed }, -- Makes sure when Alter Time is Running 
   -- { "alter time",         jps.UseCDs and jps.buff("arcane power", "player") and jps.buffStacks("arcane missiles!","player") == 2 and stacks == 6 and jps.mana() >= 90 },
--  { "alter time",           not jps.buff("Alter Time", "player") and jps.UseCDs and apBuffed and stacks == 6 and jps.buffStacks("arcane missiles!","player") == 2 }, 
  
  --interrupt
  --{ "Counterspell",          jps.Interrupts and jps.shouldKick("target") },

  --buffs

 -- { "Living Bomb",           not jps.debuff("Living Bomb") },

  --aoe
 -- { "arcane explosion",      CheckInteractDistance("target", 3) == 1 and jps.MultiTarget },

  --aoeFireBlastGlyph
 -- { "fire blast",            jps.debuff("Living Bomb")}, -- jps.Moving and 

  --mana
 -- { {"macro","/use Mana Gem"},   jps.mana("player") <= 0.84 and not atBuffed },

  --HolyShitSaveMe   
-- { "Ice Block",             ((UnitHealth("player") / UnitHealthMax("player")) < 0.10 ) and not jps.buff("Ice Block","player") },



  --{ "Rune of Power",      IsShiftKeyDown() ~= nil },

  --moving
--  { "Arcane Barrage",     jps.Moving and aDuration < 3 },
--  { "Fire Blast",         jps.Moving and jps.debuff("Living Bomb") },
--  { "Scorch",             jps.Moving },
--  { "Ice Lance",          jps.Moving },

  --rotation
 
 
  --{ "arcane missiles",    atBuffed or jps.buffStacks("arcane missiles!","player") == 2 },
  

  --{ "arcane blast",       jps.mana() >= 0.90 },
  --{ "Scorch",             jps.mana() < 0.90 },

}

 local spell,target = parseSpellTable(spellTable)
 if spell == "Rune of Power" then
   jps.Cast( spell )
   jps.groundClick()
 end

 jps.Target = target
 return spell
end