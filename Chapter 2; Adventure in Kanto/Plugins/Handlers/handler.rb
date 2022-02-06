Events.onStepTakenTransferPossible+=proc {

if $PokemonBag.pbHasItem?(:SPRINKLER)
  $game_switches[410]==true 
end

if $PokemonBag.pbHasItem?(:COALGENERATOR)
  $game_switches[409]==true 
end


if $PokemonBag.pbHasItem?(:UPGRADEDCRAFTINGBENCH)
  $game_switches[402]==true 
end

if $PokemonBag.pbHasItem?(:MEDICINEPOT)
  $game_switches[405]==true 
end

if $PokemonBag.pbHasItem?(:FURNACE)
  $game_switches[403]==true 
end

if $PokemonBag.pbHasItem?(:CAULDRON)
  $game_switches[147]==true 
end

if $PokemonBag.pbHasItem?(:CRAFTINGBENCH)
  $game_switches[150]==true 
end

if $PokemonBag.pbHasItem?(:APRICORNCRAFTING)
  $game_switches[144]==true 
end

if $PokemonBag.pbHasItem?(:PORTABLEPC)
  $game_switches[406]==true 
end

if $PokemonBag.pbHasItem?(:BEDROLL)
  $game_switches[407]==true 
end

if $PokemonBag.pbHasItem?(:SEWINGMACHINE)
  $game_switches[411]==true 
end

if $PokemonBag.pbHasItem?(:ELECTRICPRESS)
  $game_switches[412]==true 
end

if $game_variables[256]==(:GHOSTMAIL) && rand(100) == 5
  $game_variables[208]+=1
end

if !$game_switches[54]==true 
 if $PokemonSystem.survivalmode == 0
   Achievements.incrementProgress("SURVIVOR",1)
   $game_switches[54]==true 
 end
end

if $PokemonSystem.nuzlockemode == 0
 if $game_switches[57]==false
  EliteBattle.startNuzlocke
  pbMessage(_INTL("You toggled Nuzlocke Mode."))
  Achievements.incrementProgress("NUZLOCKED",1)
 else
  EliteBattle.toggle_nuzlocke
  pbMessage(_INTL("You toggled Nuzlocke Mode."))
 end
end

  
}




Events.onTrainerPartyLoad += proc { |_sender, trainer|
  if trainer[0] # I saw this on other codes so I put it in
    party = trainer[0].party   # trainer[0][2] from old code no longer exists. This seems to be where that same value is now located
    if $game_switches[141]==true # Feel free to change which Switch you want or condition to trigger this.
      if pbBalancedLevel($Trainer.party) > pbBalancedLevel(trainer[0].party) + 3 #Used to see if levels even should be adjusted. The +3 makes it so your party level needs to be 3 levels higher before this kicks in. Feel free to adjust.
      levelAdjust = pbBalancedLevel($Trainer.party) - pbBalancedLevel(trainer[0].party) #Calculate the difference before the for loop incase values change in the middle of the loop
        for i in party
          # Increases level by the party level difference. Allowing the pokemon in the team to keep their level differences from each other.
          #I add to the level instead of overriding it so that the internal team level differences don't change and are not random.
          newlevel = i.level + levelAdjust + rand(2*$game_variables[30]) # Change this if you want to adjust the levels. The -3 keeps the team 3 levels lower on average.
          if newlevel > 255
            newlevel = 255
          end
          i.level = newlevel
          i.calc_stats
          i.reset_moves
        end
      end
    end
  end
}

def pbGrassEvolutionStone
pbChooseNonEggPokemon(1,3)
  case $game_variables[3]
     when "Gloom"
    Kernel.pbMessage(_INTL("Gloom evolves into Vileplume."))
	pkmn=$trainer.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:VILEPLUME)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Weepingbell"
    Kernel.pbMessage(_INTL("Weepingbell evolves into Victreebell."))
	pkmn=$trainer.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:VECTREEBEL)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Exeggcute" 
    Kernel.pbMessage(_INTL("Exeggcute evolves into Exeggcutor."))
	pkmn=$trainer.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:EXEGGCUTOR)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Eevee"
    Kernel.pbMessage(_INTL("Eevee evolves into Leafeon."))
	pkmn=$trainer.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:LEAFEON)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Nuzleaf"
    Kernel.pbMessage(_INTL("Nuzleaf evolves into Shiftry."))
	pkmn=$trainer.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:SHIFTRY)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Pansage"
    Kernel.pbMessage(_INTL("Pansage evolves into Semisage."))
	pkmn=$trainer.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:SEMISAGE)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
     when "Cherubi"
    Kernel.pbMessage(_INTL("Cherubi evolves into Cherrim."))
	pkmn=$trainer.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:STEENEE)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
    Kernel.pbMessage(_INTL("OH! How abnormal!"))
	 else
    Kernel.pbMessage(_INTL("That does not seem to be able to evolve with this stone."))
  end
end


def pbEeveelution
pbChooseNonEggPokemon(1,3)
  case $game_variables[3]
     when "Eevee"
    Kernel.pbMessage(_INTL("We can't do anything with Eevee, just Eeveelutions."))
	
     when "Jolteon","Vaporeon","Sylveon","Leafeon","Flareon","Glaceon","Umbreon","Espeon"
    Kernel.pbMessage(_INTL("Stand back!"))
	pkmn=$trainer.party[$game_variables[1]]
	pbFadeOutInWithMusic {
    evo = PokemonEvolutionScene.new
    evo.pbStartScreen(pbGetPokemon(1),:EEVEE)
    evo.pbEvolution(false)
    evo.pbEndScreen
}
	 else
    Kernel.pbMessage(_INTL("That... isn't an Eevee"))
  end
end


def pbDayChecker(month,day,vari)
  m = Time.new.month
  d = Time.new.day
 if m == month && d == day #Checks if it is October 31th
    $game_switches[vari] = true
  else
    $game_switches[vari] = false
  end
 end

def pbIndigoPlateauDays(month1,day1,day2,day3,day4,day5,vari)
  m = Time.new.month
  d = Time.new.day
 if m == month1 && d == day1 || m == month1 && d == day2 || m == month1 && d == day3 || m == month1 && d == day4 || m == month1 && d == day5  #Checks if it is October 31th
    $game_switches[vari] = true
  else
    $game_switches[vari] = false
  end
end

def pbIndigoPlateauDays2(month1,day1,month2,day2,month3,day3,vari)
  m = Time.new.month
  d = Time.new.day
 if m == month1 && d == day1 || m == month2 && d == day2 || m == month3 && d == day3  #Checks if it is October 31th
    $game_switches[vari] = true
  else
    $game_switches[vari] = false
  end
end




	
def pbNextChampionShip
    $game_variables[421]=rand(40)
end












#===============================================================================
# Check compatibility of Pokémon in the Day Care.
#===============================================================================




def pbIsDitto2?(pkmn)
  return pkmn.species_data.egg_groups.include?(:Ditto)
end

def pbCompatibleGender?(pkmn1, pkmn2)
  return true if pkmn1.female? && pkmn2.male?
  return true if pkmn1.male? && pkmn2.female?
  ditto1 = pbIsDitto?(pkmn1)
  ditto2 = pbIsDitto?(pkmn2)
  return true if ditto1 && !ditto2
  return true if ditto2 && !ditto1
  return false
end

def pbBreedingGetCompat
  return 0 if $game_variables[496] < 2
  pkmn1 = $game_variables[497]
  pkmn2 = $game_variables[498]
  # Shadow Pokémon cannot breed
  return 0 if pkmn1.shadowPokemon? || pkmn2.shadowPokemon?
  # Pokémon in the Undiscovered egg group cannot breed
  egg_groups1 = pkmn1.species_data.egg_groups
  egg_groups2 = pkmn2.species_data.egg_groups
  return 0 if egg_groups1.include?(:Undiscovered) ||
              egg_groups2.include?(:Undiscovered)
  # Pokémon that don't share an egg group (and neither is in the Ditto group)
  # cannot breed
  return 0 if !egg_groups1.include?(:Ditto) &&
              !egg_groups2.include?(:Ditto) &&
              (egg_groups1 & egg_groups2).length == 0
  # Pokémon with incompatible genders cannot breed
  return 0 if !pbCompatibleGender?(pkmn1, pkmn2)
  # Pokémon can breed; calculate a compatibility factor
  ret = 1
  ret += 1 if pkmn1.species == pkmn2.species
  ret += 1 if pkmn1.owner.id != pkmn2.owner.id
  return ret
end

def pbDayCareGetCompatibility(variable)
  $game_variables[variable] = pbBreedingGetCompat
end


def pbBreedingGetCompat1
  return 0 if $game_variables[496] < 4
  pkmn1 = $game_variables[499]
  pkmn2 = $game_variables[500]
  # Shadow Pokémon cannot breed
  return 0 if pkmn1.shadowPokemon? || pkmn2.shadowPokemon?
  # Pokémon in the Undiscovered egg group cannot breed
  egg_groups1 = pkmn1.species_data.egg_groups
  egg_groups2 = pkmn2.species_data.egg_groups
  return 0 if egg_groups1.include?(:Undiscovered) ||
              egg_groups2.include?(:Undiscovered)
  # Pokémon that don't share an egg group (and neither is in the Ditto group)
  # cannot breed
  return 0 if !egg_groups1.include?(:Ditto) &&
              !egg_groups2.include?(:Ditto) &&
              (egg_groups1 & egg_groups2).length == 0
  # Pokémon with incompatible genders cannot breed
  return 0 if !pbCompatibleGender?(pkmn1, pkmn2)
  # Pokémon can breed; calculate a compatibility factor
  ret = 1
  ret += 1 if pkmn1.species == pkmn2.species
  ret += 1 if pkmn1.owner.id != pkmn2.owner.id
  return ret
end

def pbDayCareGetCompatibility(variable)
  $game_variables[variable] = pbBreedingGetCompat
end

#===============================================================================
# Generate an Egg based on Pokémon in the Day Care.
#===============================================================================
def pbGenerateEggHome
  return if $game_variables[496] < 2
  raise _INTL("Can't store the egg.") if $Trainer.party_full?
  pkmn0 = $game_variables[497]
  pkmn1 = $game_variables[498]
  mother = nil
  father = nil
  babyspecies = nil
  ditto0 = pbIsDitto?(pkmn0)
  ditto1 = pbIsDitto?(pkmn1)
  if pkmn0.female? || ditto0
    mother = pkmn0
    father = pkmn1
    babyspecies = (ditto0) ? father.species : mother.species
  else
    mother = pkmn1
    father = pkmn0
    babyspecies = (ditto1) ? father.species : mother.species
  end
  # Determine the egg's species
  babyspecies = GameData::Species.get(babyspecies).get_baby_species(true, mother.item_id, father.item_id)
  case babyspecies
  when :MANAPHY
    babyspecies = :PHIONE if GameData::Species.exists?(:PHIONE)
  when :NIDORANfE, :NIDORANmA
    if GameData::Species.exists?(:NIDORANfE) && GameData::Species.exists?(:NIDORANmA)
      babyspecies = [:NIDORANfE, :NIDORANmA][rand(2)]
    end
  when :VOLBEAT, :ILLUMISE
    if GameData::Species.exists?(:VOLBEAT) && GameData::Species.exists?(:ILLUMISE)
      babyspecies = [:VOLBEAT, :ILLUMISE][rand(2)]
    end
  when :VULPIX
    if babyspecies == :VULPIX && father.hasType?(:ICE) && rand(100)<10
      egg.form = 1
    end
  end
  # Generate egg
  egg = Pokemon.new(babyspecies, Settings::EGG_LEVEL)
  # Randomise personal ID
  pid = rand(65536)
  pid |= (rand(65536)<<16)
  egg.personalID = pid
  # Inheriting form
  if [:BURMY, :SHELLOS, :BASCULIN, :FLABEBE, :PUMPKABOO, :ORICORIO, :ROCKRUFF, :MINIOR].include?(babyspecies)
    newForm = mother.form
    newForm = 0 if mother.isSpecies?(:MOTHIM)
    egg.form = newForm
  end
  # Inheriting Alolan form
  if [:RATTATA, :SANDSHREW, :VULPIX, :DIGLETT,
      :MEOWTH, :GEODUDE, :GRIMER, :PONYTA,
      :SLOWPOKE, :FARFETCHD, :MRMIME, :CORSOLA,
      :ZIGZAGOON, :DARUMAKA, :YAMASK, :STUNFISK].include?(babyspecies)
    if mother.form == 1
      egg.form = 1 if mother.hasItem?(:EVERSTONE)
    elsif father.species_data.get_baby_species(true, mother.item_id, father.item_id) == babyspecies
      egg.form = 1 if father.form == 1 && father.hasItem?(:EVERSTONE)
    end
    if mother.form == 2
      egg.form = 2 if mother.hasItem?(:EVERSTONE)
    elsif pbGetBabySpecies(father.species,mother.item,father.item)==babyspecies
      egg.form = 2 if father.form == 2 && father.hasItem?(:EVERSTONE)
    end
  end
  # Inheriting Moves
  moves = []
  othermoves = []
  movefather = father
  movemother = mother
  if pbIsDitto?(movefather) && !mother.female?
    movefather = mother
    movemother = father
  end
  # Initial Moves
  initialmoves = egg.getMoveList
  for k in initialmoves
    if k[0] <= Settings::EGG_LEVEL
      moves.push(k[1])
    elsif mother.hasMove?(k[1]) && father.hasMove?(k[1])
      othermoves.push(k[1])
    end
  end
  # Inheriting Natural Moves
  for move in othermoves
    moves.push(move)
  end
  # Inheriting Machine Moves
  if Settings::BREEDING_CAN_INHERIT_MACHINE_MOVES
    GameData::Item.each do |i|
      atk = i.move
      next if !atk
      next if !egg.compatible_with_move?(atk)
      next if !movefather.hasMove?(atk)
      moves.push(atk)
    end
  end
  # Inheriting Egg Moves
  babyEggMoves = egg.species_data.egg_moves
  if movefather.male?
    babyEggMoves.each { |m| moves.push(m) if movefather.hasMove?(m) }
  end
  if Settings::BREEDING_CAN_INHERIT_EGG_MOVES_FROM_MOTHER
    babyEggMoves.each { |m| moves.push(m) if movemother.hasMove?(m) }
  end
  # Volt Tackle
  lightball = false
  if (father.isSpecies?(:PIKACHU) || father.isSpecies?(:RAICHU)) &&
      father.hasItem?(:LIGHTBALL)
    lightball = true
  end
  if (mother.isSpecies?(:PIKACHU) || mother.isSpecies?(:RAICHU)) &&
      mother.hasItem?(:LIGHTBALL)
    lightball = true
  end
  if lightball && babyspecies == :PICHU && GameData::Move.exists?(:VOLTTACKLE)
    moves.push(:VOLTTACKLE)
  end
  moves = moves.reverse
  moves |= []   # remove duplicates
  moves = moves.reverse
  # Assembling move list
  first_move_index = moves.length - Pokemon::MAX_MOVES
  first_move_index = 0 if first_move_index < 0
  finalmoves = []
  for i in first_move_index...moves.length
    finalmoves.push(Pokemon::Move.new(moves[i]))
  end
  # Inheriting Individual Values
  ivs = {}
  GameData::Stat.each_main { |s| ivs[s.id] = rand(Pokemon::IV_STAT_LIMIT + 1) }
  ivinherit = []
  for i in 0...2
    parent = [mother,father][i]
    ivinherit[i] = :HP if parent.hasItem?(:POWERWEIGHT)
    ivinherit[i] = :ATTACK if parent.hasItem?(:POWERBRACER)
    ivinherit[i] = :DEFENSE if parent.hasItem?(:POWERBELT)
    ivinherit[i] = :SPECIAL_ATTACK if parent.hasItem?(:POWERLENS)
    ivinherit[i] = :SPECIAL_DEFENSE if parent.hasItem?(:POWERBAND)
    ivinherit[i] = :SPEED if parent.hasItem?(:POWERANKLET)
  end
  num = 0
  r = rand(2)
  2.times do
    if ivinherit[r]!=nil
      parent = [mother,father][r]
      ivs[ivinherit[r]] = parent.iv[ivinherit[r]]
      num += 1
      break
    end
    r = (r+1)%2
  end
  limit = (mother.hasItem?(:DESTINYKNOT) || father.hasItem?(:DESTINYKNOT)) ? 5 : 3
  loop do
    freestats = []
    GameData::Stat.each_main { |s| freestats.push(s.id) if !ivinherit.include?(s.id) }
    break if freestats.length==0
    r = freestats[rand(freestats.length)]
    parent = [mother,father][rand(2)]
    ivs[r] = parent.iv[r]
    ivinherit.push(r)
    num += 1
    break if num>=limit
  end
  # Inheriting nature
  new_natures = []
  new_natures.push(mother.nature) if mother.hasItem?(:EVERSTONE)
  new_natures.push(father.nature) if father.hasItem?(:EVERSTONE)
  if new_natures.length > 0
    new_nature = (new_natures.length == 1) ? new_natures[0] : new_natures[rand(new_natures.length)]
    egg.nature = new_nature
  end
  # Masuda method and Shiny Charm
  shinyretries = 0
  shinyretries += 5 if mother.shiny?
  shinyretries += 5 if father.shiny?
  shinyretries += 5 if father.owner.language != mother.owner.language
  shinyretries += 2 if GameData::Item.exists?(:SHINYCHARM) && $PokemonBag.pbHasItem?(:SHINYCHARM)
  if shinyretries>0
    shinyretries.times do
      break if egg.shiny?
      egg.personalID = rand(2**16) | rand(2**16) << 16
    end
  end
  # Inheriting ability from the mother
  if !ditto0 || !ditto1
    parent = (ditto0) ? father : mother   # The non-Ditto
    if parent.hasHiddenAbility?
      egg.ability_index = parent.ability_index if rand(100) < 60
    elsif !ditto0 && !ditto1
      if rand(100) < 80
        egg.ability_index = mother.ability_index
      else
        egg.ability_index = (mother.ability_index + 1) % 2
      end
    end
  end
  # Inheriting Poké Ball from the mother (or father if it's same species as mother)
  if !ditto0 || !ditto1
    possible_balls = []
    if mother.species == father.species
      possible_balls.push(mother.poke_ball)
      possible_balls.push(father.poke_ball)
    else
      possible_balls.push(pkmn0.poke_ball) if pkmn0.female? || ditto1
      possible_balls.push(pkmn1.poke_ball) if pkmn1.female? || ditto0
    end
    possible_balls.delete(:MASTERBALL)    # Can't inherit this Ball
    possible_balls.delete(:CHERISHBALL)   # Can't inherit this Ball
    if possible_balls.length > 0
      egg.poke_ball = possible_balls[0]
      egg.poke_ball = possible_balls[rand(possible_balls.length)] if possible_balls.length > 1
    end
  end
  # Set all stats
  egg.happiness = 120
  egg.iv = ivs
  egg.moves = finalmoves
  egg.calc_stats
  egg.obtain_text = _INTL("Found at home.")
  egg.name = _INTL("Egg")
  egg.steps_to_hatch = egg.species_data.hatch_steps
  egg.givePokerus if rand(65536) < Settings::POKERUS_CHANCE
  # Add egg to party
  $Trainer.party[$Trainer.party.length] = egg
end

def pbGenerateEggHome2
  return if $game_variables[496] < 4
  raise _INTL("Can't store the egg.") if $Trainer.party_full?
  pkmn0 = $game_variables[499]
  pkmn1 = $game_variables[500]
  mother = nil
  father = nil
  babyspecies = nil
  ditto0 = pbIsDitto?(pkmn0)
  ditto1 = pbIsDitto?(pkmn1)
  if pkmn0.female? || ditto0
    mother = pkmn0
    father = pkmn1
    babyspecies = (ditto0) ? father.species : mother.species
  else
    mother = pkmn1
    father = pkmn0
    babyspecies = (ditto1) ? father.species : mother.species
  end
  # Determine the egg's species
  babyspecies = GameData::Species.get(babyspecies).get_baby_species(true, mother.item_id, father.item_id)
  case babyspecies
  when :MANAPHY
    babyspecies = :PHIONE if GameData::Species.exists?(:PHIONE)
  when :NIDORANfE, :NIDORANmA
    if GameData::Species.exists?(:NIDORANfE) && GameData::Species.exists?(:NIDORANmA)
      babyspecies = [:NIDORANfE, :NIDORANmA][rand(2)]
    end
  when :VOLBEAT, :ILLUMISE
    if GameData::Species.exists?(:VOLBEAT) && GameData::Species.exists?(:ILLUMISE)
      babyspecies = [:VOLBEAT, :ILLUMISE][rand(2)]
    end
  when :VULPIX
    if babyspecies == :VULPIX && father.hasType?(:ICE) && rand(100)<10
      egg.form = 1
    end
  end
  # Generate egg
  egg = Pokemon.new(babyspecies, Settings::EGG_LEVEL)
  # Randomise personal ID
  pid = rand(65536)
  pid |= (rand(65536)<<16)
  egg.personalID = pid
  # Inheriting form
  if [:BURMY, :SHELLOS, :BASCULIN, :FLABEBE, :PUMPKABOO, :ORICORIO, :ROCKRUFF, :MINIOR].include?(babyspecies)
    newForm = mother.form
    newForm = 0 if mother.isSpecies?(:MOTHIM)
    egg.form = newForm
  end
  # Inheriting Alolan form
  if [:RATTATA, :SANDSHREW, :VULPIX, :DIGLETT,
      :MEOWTH, :GEODUDE, :GRIMER, :PONYTA,
      :SLOWPOKE, :FARFETCHD, :MRMIME, :CORSOLA,
      :ZIGZAGOON, :DARUMAKA, :YAMASK, :STUNFISK].include?(babyspecies)
    if mother.form == 1
      egg.form = 1 if mother.hasItem?(:EVERSTONE)
    elsif father.species_data.get_baby_species(true, mother.item_id, father.item_id) == babyspecies
      egg.form = 1 if father.form == 1 && father.hasItem?(:EVERSTONE)
    end
    if mother.form == 2
      egg.form = 2 if mother.hasItem?(:EVERSTONE)
    elsif pbGetBabySpecies(father.species,mother.item,father.item)==babyspecies
      egg.form = 2 if father.form == 2 && father.hasItem?(:EVERSTONE)
    end
  end
  # Inheriting Moves
  moves = []
  othermoves = []
  movefather = father
  movemother = mother
  if pbIsDitto?(movefather) && !mother.female?
    movefather = mother
    movemother = father
  end
  # Initial Moves
  initialmoves = egg.getMoveList
  for k in initialmoves
    if k[0] <= Settings::EGG_LEVEL
      moves.push(k[1])
    elsif mother.hasMove?(k[1]) && father.hasMove?(k[1])
      othermoves.push(k[1])
    end
  end
  # Inheriting Natural Moves
  for move in othermoves
    moves.push(move)
  end
  # Inheriting Machine Moves
  if Settings::BREEDING_CAN_INHERIT_MACHINE_MOVES
    GameData::Item.each do |i|
      atk = i.move
      next if !atk
      next if !egg.compatible_with_move?(atk)
      next if !movefather.hasMove?(atk)
      moves.push(atk)
    end
  end
  # Inheriting Egg Moves
  babyEggMoves = egg.species_data.egg_moves
  if movefather.male?
    babyEggMoves.each { |m| moves.push(m) if movefather.hasMove?(m) }
  end
  if Settings::BREEDING_CAN_INHERIT_EGG_MOVES_FROM_MOTHER
    babyEggMoves.each { |m| moves.push(m) if movemother.hasMove?(m) }
  end
  # Volt Tackle
  lightball = false
  if (father.isSpecies?(:PIKACHU) || father.isSpecies?(:RAICHU)) &&
      father.hasItem?(:LIGHTBALL)
    lightball = true
  end
  if (mother.isSpecies?(:PIKACHU) || mother.isSpecies?(:RAICHU)) &&
      mother.hasItem?(:LIGHTBALL)
    lightball = true
  end
  if lightball && babyspecies == :PICHU && GameData::Move.exists?(:VOLTTACKLE)
    moves.push(:VOLTTACKLE)
  end
  moves = moves.reverse
  moves |= []   # remove duplicates
  moves = moves.reverse
  # Assembling move list
  first_move_index = moves.length - Pokemon::MAX_MOVES
  first_move_index = 0 if first_move_index < 0
  finalmoves = []
  for i in first_move_index...moves.length
    finalmoves.push(Pokemon::Move.new(moves[i]))
  end
  # Inheriting Individual Values
  ivs = {}
  GameData::Stat.each_main { |s| ivs[s.id] = rand(Pokemon::IV_STAT_LIMIT + 1) }
  ivinherit = []
  for i in 0...2
    parent = [mother,father][i]
    ivinherit[i] = :HP if parent.hasItem?(:POWERWEIGHT)
    ivinherit[i] = :ATTACK if parent.hasItem?(:POWERBRACER)
    ivinherit[i] = :DEFENSE if parent.hasItem?(:POWERBELT)
    ivinherit[i] = :SPECIAL_ATTACK if parent.hasItem?(:POWERLENS)
    ivinherit[i] = :SPECIAL_DEFENSE if parent.hasItem?(:POWERBAND)
    ivinherit[i] = :SPEED if parent.hasItem?(:POWERANKLET)
  end
  num = 0
  r = rand(2)
  2.times do
    if ivinherit[r]!=nil
      parent = [mother,father][r]
      ivs[ivinherit[r]] = parent.iv[ivinherit[r]]
      num += 1
      break
    end
    r = (r+1)%2
  end
  limit = (mother.hasItem?(:DESTINYKNOT) || father.hasItem?(:DESTINYKNOT)) ? 5 : 3
  loop do
    freestats = []
    GameData::Stat.each_main { |s| freestats.push(s.id) if !ivinherit.include?(s.id) }
    break if freestats.length==0
    r = freestats[rand(freestats.length)]
    parent = [mother,father][rand(2)]
    ivs[r] = parent.iv[r]
    ivinherit.push(r)
    num += 1
    break if num>=limit
  end
  # Inheriting nature
  new_natures = []
  new_natures.push(mother.nature) if mother.hasItem?(:EVERSTONE)
  new_natures.push(father.nature) if father.hasItem?(:EVERSTONE)
  if new_natures.length > 0
    new_nature = (new_natures.length == 1) ? new_natures[0] : new_natures[rand(new_natures.length)]
    egg.nature = new_nature
  end
  # Masuda method and Shiny Charm
  shinyretries = 0
  shinyretries += 5 if mother.shiny?
  shinyretries += 5 if father.shiny?
  shinyretries += 5 if father.owner.language != mother.owner.language
  shinyretries += 2 if GameData::Item.exists?(:SHINYCHARM) && $PokemonBag.pbHasItem?(:SHINYCHARM)
  if shinyretries>0
    shinyretries.times do
      break if egg.shiny?
      egg.personalID = rand(2**16) | rand(2**16) << 16
    end
  end
  # Inheriting ability from the mother
  if !ditto0 || !ditto1
    parent = (ditto0) ? father : mother   # The non-Ditto
    if parent.hasHiddenAbility?
      egg.ability_index = parent.ability_index if rand(100) < 60
    elsif !ditto0 && !ditto1
      if rand(100) < 80
        egg.ability_index = mother.ability_index
      else
        egg.ability_index = (mother.ability_index + 1) % 2
      end
    end
  end
  # Inheriting Poké Ball from the mother (or father if it's same species as mother)
  if !ditto0 || !ditto1
    possible_balls = []
    if mother.species == father.species
      possible_balls.push(mother.poke_ball)
      possible_balls.push(father.poke_ball)
    else
      possible_balls.push(pkmn0.poke_ball) if pkmn0.female? || ditto1
      possible_balls.push(pkmn1.poke_ball) if pkmn1.female? || ditto0
    end
    possible_balls.delete(:MASTERBALL)    # Can't inherit this Ball
    possible_balls.delete(:CHERISHBALL)   # Can't inherit this Ball
    if possible_balls.length > 0
      egg.poke_ball = possible_balls[0]
      egg.poke_ball = possible_balls[rand(possible_balls.length)] if possible_balls.length > 1
    end
  end
  # Set all stats
  egg.happiness = 120
  egg.iv = ivs
  egg.moves = finalmoves
  egg.calc_stats
  egg.obtain_text = _INTL("Found at home.")
  egg.name = _INTL("Egg")
  egg.steps_to_hatch = egg.species_data.hatch_steps
  egg.givePokerus if rand(65536) < Settings::POKERUS_CHANCE
  # Add egg to party
  $Trainer.party[$Trainer.party.length] = egg
end

#===============================================================================
# Code that happens every step the player takes.
#===============================================================================
Events.onStepTaken += proc { |_sender,_e|
  # Make an egg available at the Day Care
  deposited = $game_variables[496]
  if deposited>=2 && $game_variables[494]==0
    $game_variables[494] = 0 if !$game_variables[495]
    $game_variables[495] += 1
    if $game_variables[495]==256
      $game_variables[495] = 0
      compatval = [0,20,50,70][pbBreedingGetCompat]
      if GameData::Item.exists?(:OVALCHARM) && $PokemonBag.pbHasItem?(:OVALCHARM)
        compatval = [0,40,80,88][pbBreedingGetCompat]
      end
      $game_variables[494] = 1 if rand(100)<compatval   # Egg is generated
    end
  end
  
  
  deposited = $game_variables[496]
  if deposited>=2 && $game_variables[494]==0
    $game_variables[494] = 0 if !$game_variables[495]
    $game_variables[495] += 1
    if $game_variables[495]==256
      $game_variables[495] = 0
      compatval = [0,20,50,70][pbBreedingGetCompat1]
      if GameData::Item.exists?(:OVALCHARM) && $PokemonBag.pbHasItem?(:OVALCHARM)
        compatval = [0,40,80,88][pbBreedingGetCompat1]
      end
      $game_variables[494] = 1 if rand(100)<compatval   # Egg is generated
    end
  end
}
