function warrior_prot(self)
-- Gocargo
   if UnitCanAttack("player","target")~=1 or UnitIsDeadOrGhost("target")==1 then return end
   
   local spell = nil
   local playerHealth = UnitHealth("player")/UnitHealthMax("player")
   local nRage = UnitBuff("player","Berserker Rage")
   local nPower = UnitPower("Player",1)
   local stackWeakened = jps.debuffStacks("Weakened Armor")


   local spellTable = 
   {
      --Rage Generation
      { "Battle Shout" ,         not jps.buff("Battle Shout") and not jps.buff("Roar of Courage") and not jps.buff("Horn of Winter") and not jps.buff("Strength of earth totem") },
      { "Berserker Rage" ,       not nRage , "player" },
      
      --Active Mitigation
      { "Shield Wall" ,          playerHealth < 0.39 , "player" },
      { "Last Stand" ,           playerHealth < 0.35  and not jps.buff("Shield Wall"), "player" },
      { "Impending Victory" ,    playerHealth < 0.9 },
      { jps.DPSRacial,           jps.UseCDs },
      { jps.useTrinket(1),       jps.UseCDs and playerHealth < 0.9 },
      { jps.useTrinket(2),       jps.UseCDs and jps.buff("Shield Block") and playerHealth < 0.85 and not jps.Buff("Protection of the Celestials") },
      { "Lifeblood" ,            playerHealth < 0.75 , "player" },
      { "Shield Barrier" ,       ((GetNumSubgroupMembers() > 3 and nPower > 60) or (playerHealth < 0.91 and nPower > 70) or (playerHealth < 0.74 and nPower > 40) or playerHealth < 0.55) and jps.Defensive },
      { "Shield Block" ,         nPower > 60 and ((UnitThreatSituation("player","target") == 3 or UnitThreatSituation("player","target") == 2) and not jps.buff("Shield Block")) and not jps.Defesnive, "player" },
      { "Shield Barrier" ,       (UnitThreatSituation("player","target") == 3 or playerHealth < .95 ) and (nPower == 120 or (nPower >= 95 and jps.buff("Sword and Board") and jps.cd("Shield Block") > 1) or (nPower >= 100 and jps.cd("Battle Shout") < jps.cd("Shield Block")) or (nPower >= 105 and jps.cd("Revenge") < jps.cd("Shield Block")) or (nPower >= 110 and jps.cd("Berserker Rage") < jps.cd("Shield Block"))) },
      { "Demoralizing Shout" ,   ((playerHealth < 0.95 and not (jps.buff("Shield Block") or jps.buff("Shield Barrier")) and UnitThreatSituation("player","target") == 3 ) or (playerHealth < 0.70 and UnitThreatSituation("player","target") == 3)) and IsSpellInRange("Shield Slam", "target")==1 },
 
      --Misc
      { "Enraged Regeneration" , nRage and playerHealth < 0.80 , "player" },   
      { "Charge" ,               jps.UseCDs , "target" },
 --   { "Taunt" ,                UnitThreatSituation("player","target")~=3 , "target" },
      --{ "Heroic Leap",           IsShiftKeyDown() ~= nil and GetCurrentKeyBoardFocus() == nil },
      { "Mocking Banner",        IsShiftKeyDown() ~= nil and GetCurrentKeyBoardFocus() == nil },
      
      --Interrupts
      { "Pummel",                jps.shouldKick("target") and jps.Interrupts and (jps.castTimeLeft("target") <= 1) },
      { "Disrupting Shout",      jps.shouldKick("target") and jps.Interrupts and (jps.LastCast ~= "Pummel") and (jps.castTimeLeft("target") <= .4) },
      { "Pummel",                jps.shouldKick("focus") and jps.Interrupts and (jps.castTimeLeft("focus") <= 1), "focus" },
      { "Disrupting Shout",      jps.shouldKick("focus") and jps.Interrupts and (jps.LastCast ~= "Pummel") and (jps.castTimeLeft("focus") <= .4), "focus" },
      { "Spell Reflection" ,     UnitThreatSituation("player","target") == 3 and (UnitCastingInfo("target") or UnitChannelInfo("target")), "target" },
      
      --Damage CDs
      { "Avatar" ,               jps.UseCDs and IsSpellInRange("Shield Slam", "target") == 1 },
      { "Bloodbath" ,            jps.UseCDs and jps.cd("Shield Slam") < 1 and IsSpellInRange("Shield Slam", "target") == 1 },
      { "Recklessness" ,         jps.UseCDs and jps.buff ("Bloodbath") and IsSpellInRange("Shield Slam", "target") == 1 },
      { "Skull Banner" ,         jps.UseCDs and jps.buff("Recklessness","player") and not jps.buff("Demoralizing Banner") and IsSpellInRange("Shield Slam", "target") == 1 },

      --Damage
      --{ "Heroic Leap",           IsAltKeyDown() ~= nil and GetCurrentKeyBoardFocus() == nil },
      { "Shield Slam" ,          },
      { "Revenge" ,              not jps.MultiTarget },
      { "Victory Rush" ,         nVictory, "target" },
      
         --MultiTarget
         { "Shockwave" ,            jps.MultiTarget and IsSpellInRange("Shield Slam", "target") == 1 },
         { "Thunder Clap" ,         jps.MultiTarget and IsSpellInRange("Shield Slam", "target") == 1 },
         { "Dragon Roar" ,          jps.MultiTarget and IsSpellInRange("Shield Slam", "target") == 1 },
         { "Revenge" ,              jps.MultiTarget },
         { "Cleave" ,               jps.MultiTarget and (jps.buff("Ultimatum") or jps.buff("Incite")) },    

      --Single
      { "Heroic Strike" ,        (jps.buff("Ultimatum") or jps.buff("Incite")) and not jps.MultiTarget },
      { "Thunder Clap" ,         not jps.debuff("Weakened Blows") and IsSpellInRange("Shield Slam", "target") == 1 },        
      { "Devastate" ,            stackWeakened < 3 or jps.debuffDuration("Weakened Armor") < 2 },
      { "Battle Shout",          nPower < 100 },
      { "Dragon Roar" ,          jps.buff ("Bloodbath") and IsSpellInRange("Shield Slam", "target") == 1 },
      { "Execute" ,              playerHealth >= .78 },
      { "Devastate" ,            },
      
      { {"macro","/startattack"}, nil, "target" },
   }

   local spell,target = parseSpellTable(spellTable)
   jps.Target = target
   return spell
end