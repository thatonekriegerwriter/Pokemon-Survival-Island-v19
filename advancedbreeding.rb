#===============================================================================
# Query information about Pokémon in the Day Care.
#===============================================================================
# Returns the number of Pokémon in the Day Care.
def pbDayCareDeposited
  ret = 0
  for i in 0...2
    ret += 1 if $PokemonGlobal.daycare[i][0]
  end
  return ret
end

# Get name/cost info of a particular Pokémon in the Day Care.
def pbDayCareGetDeposited(index,nameVariable,costVariable)
  pkmn = $PokemonGlobal.daycare[index][0]
  return false if !pkmn
  cost = pbDayCareGetCost(index)
  $game_variables[nameVariable] = pkmn.name if nameVariable>=0
  $game_variables[costVariable] = cost if costVariable>=0
end

# Get name/levels gained info of a particular Pokémon in the Day Care.
def pbDayCareGetLevelGain(index,nameVariable,levelVariable)
  pkmn = $PokemonGlobal.daycare[index][0]
  return false if !pkmn
  $game_variables[nameVariable]  = pkmn.name
  $game_variables[levelVariable] = pkmn.level-$PokemonGlobal.daycare[index][1]
  return true
end

def pbDayCareGetCost(index)
  pkmn = $PokemonGlobal.daycare[index][0]
  return 0 if !pkmn
  cost = pkmn.level-$PokemonGlobal.daycare[index][1]+1
  cost *= 100
  return cost
end

# Returns whether an egg is waiting to be collected.
def pbEggGenerated?
  return false if pbDayCareDeposited!=2
  return $PokemonGlobal.daycareEgg==1
end



#===============================================================================
# Manipulate Pokémon in the Day Care.
#===============================================================================
def pbDayCareDeposit(index)
  for i in 0...2
    next if $PokemonGlobal.daycare[i][0]
    $PokemonGlobal.daycare[i][0] = $Trainer.party[index]
    $PokemonGlobal.daycare[i][1] = $Trainer.party[index].level
    $PokemonGlobal.daycare[i][0].heal
    $Trainer.party[index] = nil
    $Trainer.party.compact!
    $PokemonGlobal.daycareEgg      = 0
    $PokemonGlobal.daycareEggSteps = 0
    return
  end
  raise _INTL("No room to deposit a Pokémon")
end

def pbDayCareWithdraw(index)
  if !$PokemonGlobal.daycare[index][0]
    raise _INTL("There's no Pokémon here...")
  elsif $Trainer.party_full?
    raise _INTL("Can't store the Pokémon...")
  else
    $Trainer.party[$Trainer.party.length] = $PokemonGlobal.daycare[index][0]
    $PokemonGlobal.daycare[index][0] = nil
    $PokemonGlobal.daycare[index][1] = 0
    $PokemonGlobal.daycareEgg = 0
  end
end

def pbDayCareChoose(text,variable)
  count = pbDayCareDeposited
  if count==0
    raise _INTL("There's no Pokémon here...")
  elsif count==1
    $game_variables[variable] = ($PokemonGlobal.daycare[0][0]) ? 0 : 1
  else
    choices = []
    for i in 0...2
      pokemon = $PokemonGlobal.daycare[i][0]
      if pokemon.male?
        choices.push(_ISPRINTF("{1:s} (♂, Lv.{2:d})",pokemon.name,pokemon.level))
      elsif pokemon.female?
        choices.push(_ISPRINTF("{1:s} (♀, Lv.{2:d})",pokemon.name,pokemon.level))
      else
        choices.push(_ISPRINTF("{1:s} (Lv.{2:d})",pokemon.name,pokemon.level))
      end
    end
    choices.push(_INTL("CANCEL"))
    command = pbMessage(text,choices,choices.length)
    $game_variables[variable] = (command==2) ? -1 : command
  end
end



#===============================================================================
# Check compatibility of Pokémon in the Day Care.
#===============================================================================
def pbIsDitto?(pkmn)
  return pkmn.species_data.egg_groups.include?(:Ditto)
end

def pbDayCareCompatibleGender(pkmn1, pkmn2)
  return true if pkmn1.female? && pkmn2.male?
  return true if pkmn1.male? && pkmn2.female?
  ditto1 = pbIsDitto?(pkmn1)
  ditto2 = pbIsDitto?(pkmn2)
  return true if ditto1 && !ditto2
  return true if ditto2 && !ditto1
  return false
end

def pbDayCareGetCompat
  return 0 if pbDayCareDeposited != 2
  pkmn1 = $PokemonGlobal.daycare[0][0]
  pkmn2 = $PokemonGlobal.daycare[1][0]
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
  return 0 if !pbDayCareCompatibleGender(pkmn1, pkmn2)
  # Pokémon can breed; calculate a compatibility factor
  ret = 1
  ret += 1 if pkmn1.species == pkmn2.species
  ret += 1 if pkmn1.owner.id != pkmn2.owner.id
  return ret
end

def pbDayCareGetCompatibility(variable)
  $game_variables[variable] = pbDayCareGetCompat
end





def pbDayCareGenerateEgg
  return if pbDayCareDeposited != 2
  if $game_switches[298]==false
  raise _INTL("Can't store the egg.") if $Trainer.party_full?
  end
  pkmn0 = $PokemonGlobal.daycare[0][0]
  pkmn1 = $PokemonGlobal.daycare[1][0]
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
    if babyspecies == :VULPIX
      babyspecies = :VULPIII if GameData::Species.exists?(:VULPIII)
    elsif babyspecies == :VULPIX && father.hasType?(:ICE) && rand(100)<10
      babyspecies = :VULPIII if GameData::Species.exists?(:VULPIII)
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
    ivinherit[i] = :HP if parent.hasItem?(:POWERWEIGHT) || $game_switches[295]==true && rand(255)<25
    ivinherit[i] = :ATTACK if parent.hasItem?(:POWERBRACER) || $game_switches[295]==true && rand(255)<25
    ivinherit[i] = :DEFENSE if parent.hasItem?(:POWERBELT) || $game_switches[295]==true && rand(255)<25
    ivinherit[i] = :SPECIAL_ATTACK if parent.hasItem?(:POWERLENS) || $game_switches[295]==true && rand(255)<25
    ivinherit[i] = :SPECIAL_DEFENSE if parent.hasItem?(:POWERBAND) || $game_switches[295]==true && rand(255)<25
    ivinherit[i] = :SPEED if parent.hasItem?(:POWERANKLET) || $game_switches[295]==true && rand(255)<25
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
  
  
  # Inheriting Base Stats
  bss = {}
  GameData::Stat.each_main { |s| @base_stats[s.id] = rand(255) }
  bssinherit = []
  for i in 0...2
    parent = [mother,father][i]
    bssinherit[i] = :HP if $game_switches[294]==true && rand(255)<25
    bssinherit[i] = :ATTACK if $game_switches[294]==true && rand(255)<25
    bssinherit[i] = :DEFENSE if $game_switches[294]==true && rand(255)<25
    bssinherit[i] = :SPECIAL_ATTACK if $game_switches[294]==true && rand(255)<25
    bssinherit[i] = :SPECIAL_DEFENSE if $game_switches[294]==true && rand(255)<25
    bssinherit[i] = :SPEED if $game_switches[294]==true && rand(255)<25
  end
  num = 0
  r = rand(2)
  2.times do
    if bssinherit[r]!=nil
      parent = [mother,father][r]
      bss[bssinherit[r]] = parent.baseStats[bssinherit[r]]
      num += 1
      break
    end
    r = (r+1)%2
  end
  limit = (mother.hasItem?(:DESTINYKNOT) || father.hasItem?(:DESTINYKNOT)) ? 5 : 3
  loop do
    freestats = []
    GameData::Stat.each_main { |s| freestats.push(s.id) if !bssinherit.include?(s.id) }
    break if freestats.length==0
    r = freestats[rand(freestats.length)]
    parent = [mother,father][rand(2)]
    bss[r] = parent.baseStats[r]
    bssinherit.push(r)
    num += 1
    break if num>=limit
  end
  
  
  # Inheriting nature
  new_natures = []
  new_natures.push(mother.nature) if mother.hasItem?(:EVERSTONE)
  new_natures.push(mother.nature) if $game_switches[297]==true && rand(255)<25
  new_natures.push(father.nature) if father.hasItem?(:EVERSTONE)
  new_natures.push(mother.nature) if $game_switches[297]==true && rand(255)<25
  if new_natures.length > 0
    new_nature = (new_natures.length == 1) ? new_natures[0] : new_natures[rand(new_natures.length)]
    egg.nature = new_nature
  end
  # Masuda method and Shiny Charm
  shinyretries = 0
  shinyretries += 5 if mother.shiny?
  shinyretries += 5 if father.shiny?
  shinyretries += 10 if $game_switches[299]==true
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
  if $game_switches[298]==true
  happ= rand(140)+rand(40)
  else
  happ= rand(140)
  end
  # Set all stats
  egg.happiness = happ
  egg.iv = ivs
  egg.moves = finalmoves
  egg.calc_stats
  egg.baseStats = bss
  egg.obtain_text = _INTL("Breeding")
  egg.name = _INTL("Egg")
  egg.steps_to_hatch = egg.species_data.hatch_steps
  egg.givePokerus if rand(65536) < Settings::POKERUS_CHANCE
  # Add egg to party
  if $game_switches[298]==true
   if $game_switches[288]==true
    $game_variables[4994]=egg
   if $game_switches[289]==true
    $game_variables[4995]=egg
   if $game_switches[290]==true
    $game_variables[4996]=egg
   if $game_switches[291]==true
    $game_variables[4997]=egg
   if $game_switches[292]==true
    $game_variables[4998]=egg
   if $game_switches[293]==true
    $game_variables[4999]=egg
	else
	break
	end
  else
  $Trainer.party[$Trainer.party.length] = egg
end

#===============================================================================
# Code that happens every step the player takes.
#===============================================================================
Events.onStepTaken += proc { |_sender,_e|
  # Make an egg available at the Day Care
  deposited = pbDayCareDeposited
  if deposited==2 && $PokemonGlobal.daycareEgg==0
    $PokemonGlobal.daycareEggSteps = 0 if !$PokemonGlobal.daycareEggSteps
    $PokemonGlobal.daycareEggSteps += 1
    if $PokemonGlobal.daycareEggSteps==256
      $PokemonGlobal.daycareEggSteps = 0
      compatval = [0,20,50,70][pbDayCareGetCompat]
      if $game_switches[296]==true && rand(255)<25 && GameData::Item.exists?(:OVALCHARM) && $PokemonBag.pbHasItem?(:OVALCHARM)
        compatval = [20,60,80,88][pbDayCareGetCompat]
      elsif $game_switches[296]==true && rand(255)<25
        compatval = [0,40,80,88][pbDayCareGetCompat]
      elsif GameData::Item.exists?(:OVALCHARM) && $PokemonBag.pbHasItem?(:OVALCHARM)
        compatval = [0,40,80,88][pbDayCareGetCompat]
      end
      $PokemonGlobal.daycareEgg = 1 if rand(100)<compatval   # Egg is generated
	  if $game_switches[298]==true
	  pbDayCareGenerateEgg
	  $PokemonGlobal.daycareEggSteps = 0
	  $PokemonGlobal.daycareEgg==0
	  end
    end
  end
  # Day Care Pokémon gain Exp/moves
  for i in 0...2
    pkmn = $PokemonGlobal.daycare[i][0]
    next if !pkmn
    maxexp = pkmn.growth_rate.maximum_exp
    next if pkmn.exp>=maxexp
    oldlevel = pkmn.level
    pkmn.exp += 1   # Gain Exp
    next if pkmn.level==oldlevel
    pkmn.calc_stats
    movelist = pkmn.getMoveList
    for i in movelist
      pkmn.learn_move(i[1]) if i[0]==pkmn.level   # Learned a new move
    end
  end
}




#===============================================================================
# * One screen Day-Care Checker item - by FL (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. It makes a One screen Day-Care Checker
# (like in DPP) activated by item. This display the pokémon sprite, names,
# levels, genders and if them generate an egg.
#
#===============================================================================
#
#
#
#
#
#   pbFadeOutIn(99999){ 
#     scene=DayCareCheckerScene.new
#     screen=DayCareChecker.new(scene)
#     screen.startScreen
#   }
# To this script works, put it above main, put a 480x320 background in 
# DCCBACKPATH location and, like any item, you need to add in the "items.txt"
# and in the script. There an example below using the name DAYCARESIGHT, but
# you can use any other name changing the DDCITEM and the item that be added in
# txt. You can change the internal number too:
#
# 631,DAYCARESIGHT,DayCare Sight,8,0,"A visor that can be use for see certains Pokémon in Day-Care to monitor their growth.",2,0,6
# 
#===============================================================================

 # Change this and the item.txt if you wish another name
DCCBACKPATH= "Graphics/Pictures/dccbackground" # You can change if you wish 
# If you wish that the pokémon is positioned like in battle (have the distance
# defined in metadata, even the BattlerAltitude) change the below line to true
DDCBATTLEPOSITION = false

class DayCareCheckerScene  
  def startScene
    @sprites={}
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @pkmn1=$PokemonGlobal.daycare[0][0]
    @pkmn2=$PokemonGlobal.daycare[1][0]
    # If you wish that if there only one pokémon, it became right 
    # positioned, them uncomment the four below lines
    #if !@pkmn1 && @pkmn2
    #  @pkmn1=@pkmn2
    #  @pkmn2=nil
    #end  
    textPositions=[]
    baseColor=Color.new(12*8,12*8,12*8)
    shadowColor=Color.new(26*8,26*8,25*8)
    @sprites["background"]=IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap(DCCBACKPATH)
    pokemony=128
    pokemonyadjust=pokemony-32
    if @pkmn1
      @sprites["pokemon1"]=PokemonSprite.new(@viewport)
      @sprites["pokemon1"].setPokemonBitmap(@pkmn1)
      @sprites["pokemon1"].mirror=true
      pbPositionPokemonSprite(@sprites["pokemon1"],32,pokemony)
      if DDCBATTLEPOSITION
        @sprites["pokemon1"].y=pokemonyadjust+adjustBattleSpriteY(@sprites["pokemon1"],@pkmn1.species,1)
      end
      textPositions.push([
        _INTL("{1} Lv{2}{3}",@pkmn1.name,@pkmn1.level.to_s,genderString(@pkmn1.gender)),32,46,false,baseColor,shadowColor
      ])
    end
    if @pkmn2
      @sprites["pokemon2"]=PokemonSprite.new(@viewport)
      @sprites["pokemon2"].setPokemonBitmap(@pkmn2)
      pbPositionPokemonSprite(@sprites["pokemon2"],312,pokemony)
      if DDCBATTLEPOSITION
        @sprites["pokemon2"].y==pokemonyadjust + adjustBattleSpriteY(@sprites["pokemon2"],@pkmn2.species,1)
      end
      textPositions.push([
        _INTL("{1} Lv{2}{3}",@pkmn2.name,@pkmn2.level.to_s,genderString(@pkmn2.gender)),464,46,true,baseColor,shadowColor
      ])
    end
    if $PokemonGlobal.daycareEgg==1
      fSpecies = pbDayCareGenerateEggFSpecies(@pkmn1,@pkmn2)
      speciesAndForm = pbGetSpeciesFromFSpecies(fSpecies)
      species = speciesAndForm[0]
      form = speciesAndForm[1]
      @sprites["egg"]=IconSprite.new(156,pokemony+16,@viewport)
      @sprites["egg"].setBitmap(EggType.eggPicture(species,form,false))
      # Uncomment the below line to only a egg shadow be show
      # @sprites["egg"].color=Color.new(0,0,0,255)    
    end
    @sprites["overlay"]=Sprite.new(@viewport)
    @sprites["overlay"].bitmap=BitmapWrapper.new(Graphics.width,Graphics.height)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbDrawTextPositions(@sprites["overlay"].bitmap,textPositions) if !textPositions.empty?
    pbFadeInAndShow(@sprites) { update }
  end

  def genderString(gender)
    ret="  "
    if gender==0
      ret=" ♂"
    elsif gender==1
      ret=" ♀"
    end  
    return ret
  end  

  def middleScene
    loop do
      Graphics.update
      Input.update
      self.update
      break if Input.trigger?(Input::B) || Input.trigger?(Input::C)
    end 
  end

  def update
    pbUpdateSpriteHash(@sprites)
  end

  def endScene
    pbFadeOutAndHide(@sprites) { update }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

class DayCareChecker
  def initialize(scene)
    @scene=scene
  end

  def startScreen
    @scene.startScene
    @scene.middleScene
    @scene.endScene
  end
end

# Item handlers
