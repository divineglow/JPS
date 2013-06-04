
function priest_holy(self)

if UnitCanAttack("player","target")~=1 or UnitIsDeadOrGhost("target")==1 then return end 

local spell = nil
local playerhealth_pct = UnitHealth("player") / UnitHealthMax("player")

------------------------
-- SPELL TABLE ---------
------------------------

local spellTable =
{
    { "Inner Fire",             not ub("player", "Inner Fire") , "player" },
    { "Power Word: Fortitude",  not ub("player", "Power Word: Fortitude") , "player" },
    { "Chakra",                 not ub("player","Chakra") and not ub("player","Chakra: Chastise"), "player" },
    { "Mind Sear",                  IsShiftKeyDown() == 1 },
    { "Halo",                   jps.UseCDs  },
    { "Shadow Word: Pain",      not jps.debuff("Shadow Word: Pain") },
    { "Shadow Word: Death",     },
    { "Mindbender",            jps.UseCDs  },
    { "Holy Fire",              }, 
    { "Smite",                  }, -- SpellStopCasting()
    { "Fade",                   UnitThreatSituation("player")==3, "player" },
}

	local spell,target = parseSpellTable(spellTable)
	jps.Target = target
	return spell
end
