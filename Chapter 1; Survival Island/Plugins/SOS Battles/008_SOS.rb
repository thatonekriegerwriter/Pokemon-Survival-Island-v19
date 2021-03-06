#===============================================================================
# SOS Battles - By Vendily [v19]
#===============================================================================
# This script adds in SOS Battles, the added mechanic from Alola, where
#  Pokémon have a chance of calling for aid while in battle.
# This version of the script does not implement special weather based encounters
#  but does have a method that can be edited to do so.
# The script also defines the manually used effect of the Adrenaline Orb item.
#===============================================================================
# To use it, you must add species that are able to SOS call in the SOS_CALL_RATES
#  hash. The key is the species symbol, and the value is the rate in percentage
#  the mon will call at.
#   AKA. :BULBASAUR=>100 is a valid entry
#
# Optionally, you may add species to SOS_CALL_MONS, the species that
#  the mon will call for. Add more entries of the same species to make them more
#  likely. The Key is the species symbol, and the value is an array of species.
#   AKA. :BULBASAUR=>[:BULBASAUR,:BULBASAUR,:BULBASAUR,:IVYSAUR,:IVYSAUR,:VENUSAUR]
#   is a valid entry.
# If you don't have an entry for a calling species, it will call another mon of
#  the same species as itself.
#
# To implement the doubled EV points in an SOS battle, there is an aditional
#  edit to "def pbGainEVsOne" in PokeBattle_Battle
#  under:
#    # Double EV gain because of Pokérus
#    if pkmn.pokerusStage>=1   # Infected or cured
#      evYield.collect! { |a| a*2 }
#    end
#  put:
#    if @sosbattle
#      evYield.collect! { |a| a*2 }
#    end
#
# If you wish to implement special called allies, edit the array returned by
#  pbSpecialSOSMons. By default, it just passes through the regular array used.
# The method also takes the calling battler, if you wish to check its properties.
#===============================================================================
# * Hash containing base species call rates
#   SOS_CALL_RATES={:BULBASAUR=>5,:SUNKERN==>5,:ROSELIA=>5,:SENTRET=>5,:GROWLITHE=>5,:ODDISH=>5,:TAILLOW=>5,:PHANPY=>5,:FARFETCHD=>5,:CYNDAQUIL=>5,:NIDORANmA=>5,:NIDORANfE=>5,:PIDGEY=>5,:SANDSCREW=>5,:VULPIX=>5,:SCYTHER=>5,:TORCHIC=>5,:MINUN=>5,:PLUSLE=>5,:EKANS=>5,:MAREEP=>5,:JIGGLYPUFF=>5,:POOCHYENA=>5,:DROWZEE=>5,:HYPNO=>5,:ZIGZAGOON=>5,:RATTATA=>5,:SPEAROW=>5,:TANGELA=>5,:LOTAD=>5,:SQUIRTLE=>5,:INKAY=>5,:WARTORTLE=>5,:POIPOLE=>5,:SEISMITOAD=>5,:POPPLIO=>5,:POLIWAG=>5,:PSYDUCK=>5,:MARILL=>5,:PONYTA=>5,:NATU=>5,:HIPPOWDON=>5,:SHUCKLE=>5,:DIGLETT=>5,:ROCKRUFF=>5,:ACCELGOR=>5,:GEODUDE=>5,:MANKEY=>5,:SLUGMA=>5,:CUBONE=>5,:MACHOP=>5,:MAGMAR=>5,:ARON=>5,:SHUCKLE=>5,:AERODACTYL=>5,:CHARMANDER=>5,:TEDDIURSA=>5,:MAKUHITA=>5,:NUMEL=>5,:SNORLAX=>5,:ABSOL=>5,:SPOINK=>5,:GLIGAR=>5,:CLEFAIRY=>5,:MEDITITE=>5,:LARVITAR=>5,:ZUBAT=>5,:MAWILE=>5,:NOSEPASS=>5,:SABLEYE=>5,:WHISMUR=>5,:HORSEA=>5,:FLETCHLING=>5,:TOGEDEMARU=>5,:DEDENNE=>5,:EMOLGA=>5,:WOOLOO=>5,:ROOKIDEE=>5,:VENONAT=>5,:WOOPER=>5,:MINCCINO=>5,:CROAGUNK=>5,:SHELMET=>5,:VOLBEAT=>5,:KARRABLAST=>5,:STUNKY=>5,:GOOMY=>5,:TOTODILE=>5,:AZUMARILL=>5,:QUAGSIRE=>5,:SNOM=>5,:MAGIKARP=>5,:OSHAWOTT=>5,:MAREANIE=>5,:FEEBAS=>5,:BEAUTIFLY=>5,:SEEDOT=>5,:PATRAT=>5,:KOMALA=>5,:ORICORIO=>5,:ZANGOOSE=>5,:KIRLIA=>5,:AXEW=>5,:GROTLE=>5,:PACHIRISU=>5,:BUIZEL=>5,:PINSIR=>5,:LILLIGANT=>5,:GLACEON=>5,:SANDYGAST=>5,:SWINUB=>5,:NOIBAT=>5,:SMOOCHUM=>5,:SNEASEL=>5,:DELIBIRD=>5,:CASTFORM=>5,:WEAVILE=>5,:DARUMAKA=>5,:FROSLASS=>5,:METANG=>5,:PIPLUP=>5,:CUBCHOO=>5,:MRMIME=>5,:JYNX=>5,:STARYU=>5,:MUDKIP=>5,:MISDREAVUS=>5,:SHUPPET=>5,:GASTLY=>5,:FROAKIE=>5,:DEWPIDER=>5,:CACNEA=>5,:SCRAGGY=>5,:TAUROS=>5,:DUCKLETT=>5,:SEWADDLE=>5,:WURMPLE=>5,:YANMA=>5,:DURANT=>5,:JOLTIK=>5,:SCATTERBUG=>5,:CUTIEFLY=>5,:GRUBBIN=>5,:NINCADA=>5,:TREECKO=>5,:CHIKORITA=>5,:SWABLU=>5,:DRATINI=>5,:STARAVIA=>5,:DODUO=>5,:STUNFISK=>5,:MUDBRAY=>5,:CHANSEY=>5,:EEVEE=>5,:RIOLU=>5,:SLOWPOKE=>5,:DUNSPARCE=>5}

# * Hash containing species called allies
# * Switch id to enable/disable SOS battles. Set to <1 to not check.
#=============================================================================== 
begin
  PluginManager.register({
    :name    => "SOS Battles",
    :version => "1.1",
    :link    => "https://reliccastle.com/resources/444/",
    :credits => "Vendily"
  })
  rescue
    raise "This script only funtions in v19."
  end
#SOS_CALL_RATES={:BULBASAUR=>5,:SUNKERN==>5,:ROSELIA=>5,:SENTRET=>5,:GROWLITHE=>5,:ODDISH=>5,:TAILLOW=>5,:PHANPY=>5,:FARFETCHD=>5,:CYNDAQUIL=>5,:NIDORANmA=>5,:NIDORANfE=>5,:PIDGEY=>5,:SANDSCREW=>5,:VULPIX=>5,:SCYTHER=>5,:TORCHIC=>5,:MINUN=>5,:PLUSLE=>5,:EKANS=>5,:MAREEP=>5,:JIGGLYPUFF=>5,:POOCHYENA=>5,:DROWZEE=>5,:HYPNO=>5,:ZIGZAGOON=>5,:RATTATA=>5,:SPEAROW=>5,:TANGELA=>5,:LOTAD=>5,:SQUIRTLE=>5,:INKAY=>5,:WARTORTLE=>5,:POIPOLE=>5,:SEISMITOAD=>5,:POPPLIO=>5,:POLIWAG=>5,:PSYDUCK=>5,:MARILL=>5,:PONYTA=>5,:NATU=>5,:HIPPOWDON=>5,:SHUCKLE=>5,:DIGLETT=>5,:ROCKRUFF=>5,:ACCELGOR=>5,:GEODUDE=>5,:MANKEY=>5,:SLUGMA=>5,:CUBONE=>5,:MACHOP=>5,:MAGMAR=>5,:ARON=>5,:SHUCKLE=>5,:AERODACTYL=>5,:CHARMANDER=>5,:TEDDIURSA=>5,:MAKUHITA=>5,:NUMEL=>5,:SNORLAX=>5,:ABSOL=>5,:SPOINK=>5,:GLIGAR=>5,:CLEFAIRY=>5,:MEDITITE=>5,:LARVITAR=>5,:ZUBAT=>5,:MAWILE=>5,:NOSEPASS=>5,:SABLEYE=>5,:WHISMUR=>5,:HORSEA=>5,:FLETCHLING=>5,:TOGEDEMARU=>5,:DEDENNE=>5,:EMOLGA=>5,:WOOLOO=>5,:ROOKIDEE=>5,:VENONAT=>5,:WOOPER=>5,:MINCCINO=>5,:CROAGUNK=>5,:SHELMET=>5,:VOLBEAT=>5,:KARRABLAST=>5,:STUNKY=>5,:GOOMY=>5,:TOTODILE=>5,:AZUMARILL=>5,:QUAGSIRE=>5,:SNOM=>5,:MAGIKARP=>5,:OSHAWOTT=>5,:MAREANIE=>5,:FEEBAS=>5,:BEAUTIFLY=>5,:SEEDOT=>5,:PATRAT=>5,:KOMALA=>5,:ORICORIO=>5,:ZANGOOSE=>5,:KIRLIA=>5,:AXEW=>5,:GROTLE=>5,:PACHIRISU=>5,:BUIZEL=>5,:PINSIR=>5,:LILLIGANT=>5,:GLACEON=>5,:SANDYGAST=>5,:SWINUB=>5,:NOIBAT=>5,:SMOOCHUM=>5,:SNEASEL=>5,:DELIBIRD=>5,:CASTFORM=>5,:WEAVILE=>5,:DARUMAKA=>5,:FROSLASS=>5,:METANG=>5,:PIPLUP=>5,:CUBCHOO=>5,:MRMIME=>5,:JYNX=>5,:STARYU=>5,:MUDKIP=>5,:MISDREAVUS=>5,:SHUPPET=>5,:GASTLY=>5,:FROAKIE=>5,:DEWPIDER=>5,:CACNEA=>5,:SCRAGGY=>5,:TAUROS=>5,:DUCKLETT=>5,:SEWADDLE=>5,:WURMPLE=>5,:YANMA=>5,:DURANT=>5,:JOLTIK=>5,:SCATTERBUG=>5,:CUTIEFLY=>5,:GRUBBIN=>5,:NINCADA=>5,:TREECKO=>5,:CHIKORITA=>5,:SWABLU=>5,:DRATINI=>5,:STARAVIA=>5,:DODUO=>5,:STUNFISK=>5,:MUDBRAY=>5,:CHANSEY=>5,:EEVEE=>5,:RIOLU=>5,:SLOWPOKE=>5,:DUNSPARCE=>5}
SOS_CALL_RATES={}
SOS_CALL_MONS={}
NO_SOS_BATTLES = -1
   
  class PokeBattle_Battle
    attr_accessor :adrenalineorb
    attr_accessor :lastturncalled
    attr_accessor :lastturnanswered
    attr_accessor :soschain
    attr_accessor :sosbattle
    
    def soschain
      return @soschain || 0
    end
    
    def pbSpecialSOSMons(caller,mons)
      return mons
    end
    
    
    def pbCallForHelp(caller)
      cspecies=GameData::Species.get(caller.species).species
      rate=SOS_CALL_RATES[cspecies] || 0
      return if rate==0 # should never trigger anyways but you never know.
      pbDisplay(_INTL("{1} called for help!", caller.pbThis))
      rate*=4 # base rate
      rate=rate.to_f # don't want to lose decimal points
      intimidate=false
      caller.eachOpposing{ |b|
        if b.hasActiveAbility?(:INTIMIDATE) ||
           b.hasActiveAbility?(:UNNERVE) ||
           b.hasActiveAbility?(:PRESSURE)
          intimidate=true
          break
        end
      }
      rate*=1.2 if intimidate
      if @lastturncalled==@turnCount-1
        rate*=1.5
      end
      if !@lastturnanswered
        rate*=3.0
      end
      rate=rate.round # rounding it off.
      pbDisplayPaused(_INTL("... ... ..."))
      idxOther = -1
      case pbSideSize(caller.index)
      when 1
        idxOther=3
        # change battle size
        @sideSizes[1]=2
      when 2
        idxOther = (caller.index+2)%4
      end
      if idxOther>=0 && pbRandom(100)<rate
        @lastturnanswered=true
        mons=SOS_CALL_MONS[cspecies] || [caller.species]
        mons=pbSpecialSOSMons(caller,mons)
        mon=mons[pbRandom(mons.length)]
        alevel=caller.level-1
        alevel=1 if alevel<1
        ally=pbGenerateSOSPokemon(GameData::Species.get(mon).species,alevel)
        if @battlers[idxOther].nil?
          pbCreateBattler(idxOther,ally,@party2.length)
        else
          @battlers[idxOther].pbInitialize(ally,@party2.length)
        end
        @scene.pbSOSJoin(idxOther,ally)
        pbDisplay(_INTL("{1} appeared!",@battlers[idxOther].pbThis))
        # prevent cheap shot
        @battlers[idxOther].lastRoundMoved=@turnCount
        # required to gain exp and to do "switch in" effects, like Spikes
        pbOnActiveOne(@battlers[idxOther])
        @party2.push(ally)
        @party2order.push(@party2order.length)
      else
        @lastturnanswered=false
        pbDisplay(_INTL("Its help didn't appear!"))
      end
      @lastturncalled=@turnCount
    end
    
    def pbGenerateSOSPokemon(species,level)
      genwildpoke = Pokemon.new(species,level,$Trainer)
      items = genwildpoke.wildHoldItems
      firstpoke = @battlers[0]
      chances = [50,5,1]
      chances = [60,20,5] if firstpoke.hasActiveAbility?(:COMPOUNDEYES)
      itemrnd = rand(100)
      if itemrnd<chances[0] || (items[0]==items[1] && items[1]==items[2])
        genwildpoke.item=(items[0])
      elsif itemrnd<(chances[0]+chances[1])
        genwildpoke.item=(items[1])
      elsif itemrnd<(chances[0]+chances[1]+chances[2])
        genwildpoke.item=(items[2])
      end
      if $PokemonBag.pbHasItem?(:SHINYCHARM)
        for i in 0...2   # 3 times as likely
          break if genwildpoke.shiny?
          genwildpoke.personalID = rand(65536)|(rand(65536)<<16)
        end
      end
      chain=self.soschain
      shinychain=(chain/10)
      shinychain-=1 if chain%10==0
      if shinychain>0
        for i in 0...shinychain
          break if genwildpoke.shiny?
          genwildpoke.personalID = rand(65536)|(rand(65536)<<16)
        end
      end
      ivchain=(chain/10)
      ivchain+=1 if chain>=5
      ivs=(0..5).to_a
      ivs.shuffle!
      if ivchain>0
        for i in 0...ivchain
          break if ivs.length==0
          iv=ivs.shift
          genwildpoke.ivs[iv]=31
        end
      end
      hachain=(chain/10)
      if hachain>0
        genwildpoke.ability_index=2 if pbRandom(100)<hachain*5
      end
      if rand(65536)<Settings::POKERUS_CHANCE
        genwildpoke.givePokerus
      end
      if firstpoke.hasActiveAbility?(:CUTECHARM) && !genwildpoke.singleGendered?
        if firstpoke.gender==0
          (rand(3)<2) ? genwildpoke.makeFemale : genwildpoke.makeMale
        elsif firstpoke.gender==1
          (rand(3)<2) ? genwildpoke.makeMale : genwildpoke.makeFemale
        end
      elsif firstpoke.hasActiveAbility?(:SYNCHRONIZE)
        genwildpoke.nature=firstpoke.nature if rand(10)<5
      end
      Events.onWildPokemonCreate.trigger(nil,genwildpoke)
      return genwildpoke
    end
    
  end
   
  class PokeBattle_Battler
    def pbCanCall?
      return false if NO_SOS_BATTLES>0 &&  $game_switches[NO_SOS_BATTLES]
      # only wild battles
      return false if @battle.trainerBattle?
      # only wild mons
      return false if !opposes?
      # can't call in triple+ battles (don't want to figure out where the battler needs to be)
      return false if @battle.pbSideSize(@index)>=3
      # can't call if partner already in
      allies=@battle.battlers.select {|b| b && !b.fainted? && !b.opposes?(@index) && b.index!=@index}
      return false if allies.length>0
      # just to be safe
      return false if self.fainted?
      # no call if status
      return false if self.pbHasAnyStatus?
      # no call if multiturn attack
      return false if usingMultiTurnAttack?
      species=GameData::Species.get(self.species).name
      rate=SOS_CALL_RATES[self.species] || 0
      # not a species that calls
      return false if rate==0
      rate*=3 if self.hp>(self.totalhp/4) && self.hp<=(self.totalhp/2)
      rate*=5 if self.hp<=(self.totalhp/4)
      rate*=2 if @battle.adrenalineorb
      return @battle.pbRandom(100)<rate
    end
    
 
    def pbProcessTurn(choice,tryFlee=true)
      return false if fainted?
      # Wild roaming Pokémon always flee if possible
      if tryFlee && @battle.wildBattle? && opposes? &&
         @battle.rules["alwaysflee"] && @battle.pbCanRun?(@index)
        pbBeginTurn(choice)
        pbSEPlay("Battle flee")
        @battle.pbDisplay(_INTL("{1} fled from battle!",pbThis))
        @battle.decision = 3
        pbEndTurn(choice)
        return true
      end
      # Shift with the battler next to this one
      if choice[0]==:Shift
        idxOther = -1
        case @battle.pbSideSize(@index)
        when 2
          idxOther = (@index+2)%4
        when 3
          if @index!=2 && @index!=3   # If not in middle spot already
            idxOther = ((@index%2)==0) ? 2 : 3
          end
        end
        if idxOther>=0
          @battle.pbSwapBattlers(@index,idxOther)
          case @battle.pbSideSize(@index)
          when 2
            @battle.pbDisplay(_INTL("{1} moved across!",pbThis))
          when 3
            @battle.pbDisplay(_INTL("{1} moved to the center!",pbThis))
          end
        end
        pbBeginTurn(choice)
        pbCancelMoves
        @lastRoundMoved = @battle.turnCount   # Done something this round
        return true
      end
      if pbCanCall?
        pbCancelMoves
        @battle.pbCallForHelp(self)
        @lastRoundMoved = @battle.turnCount
        pbEndTurn(choice)
        return true
      end
      # If this battler's action for this round wasn't "use a move"
      if choice[0]!=:UseMove
        # Clean up effects that end at battler's turn
        pbBeginTurn(choice)
        pbEndTurn(choice)
        return false
      end
      # Turn is skipped if Pursuit was used during switch
      if @effects[PBEffects::Pursuit]
        @effects[PBEffects::Pursuit] = false
        pbCancelMoves
        pbEndTurn(choice)
        @battle.pbJudge
        return false
      end
      # Use the move
      PBDebug.log("[Move usage] #{pbThis} started using #{choice[2].name}")
      PBDebug.logonerr{
        pbUseMove(choice,choice[2]==@battle.struggle)
      }
      @battle.pbJudge
      # Update priority order
      #    @battle.pbCalculatePriority if NEWEST_BATTLE_MECHANICS
      @battle.pbCalculatePriority if Settings::RECALCULATE_TURN_ORDER_AFTER_SPEED_CHANGES
      return true
    end
  end
   
  class PokeBattle_Scene
    def pbSOSJoin(battlerindex,pkmn)
      pbRefresh
      sendOutAnims=[]
      adjustAnims=[]
      setupbox=false
      if !@sprites["dataBox_#{battlerindex}"]
        @sprites["dataBox_#{battlerindex}"] = PokemonDataBox.new(@battle.battlers[battlerindex],
            @battle.pbSideSize(battlerindex),@viewport)
        setupbox=true
        @sprites["targetWindow"].dispose
        @sprites["targetWindow"] = TargetMenuDisplay.new(@viewport,200,@battle.sideSizes)
        @sprites["targetWindow"].visible=false
        pbCreatePokemonSprite(battlerindex)
        @battle.battlers[battlerindex].eachAlly{|b|
          adjustAnims.push([DataBoxDisappearAnimation.new(@sprites,@viewport,b.index),b])
        }
      end
      pkmn = @battle.battlers[battlerindex].effects[PBEffects::Illusion] || pkmn
      pbChangePokemon(battlerindex,pkmn)
      sendOutAnim = SOSJoinAnimation.new(@sprites,@viewport,
          @battle.pbGetOwnerIndexFromBattlerIndex(battlerindex)+1,
          @battle.battlers[battlerindex])
      dataBoxAnim = DataBoxAppearAnimation.new(@sprites,@viewport,battlerindex)
      sendOutAnims.push([sendOutAnim,dataBoxAnim,false])
      # Play all animations
      loop do
        adjustAnims.each do |a|
          next if a[0].animDone?
          a[0].update
        end
        pbUpdate
        break if !adjustAnims.any? {|a| !a[0].animDone?}
      end
      # delete and remake sprites
      adjustAnims.each {|a|
        @sprites["dataBox_#{a[1].index}"].dispose
        @sprites["dataBox_#{a[1].index}"] = PokemonDataBox.new(a[1],
            @battle.pbSideSize(a[1].index),@viewport)
      }
      # have to remake here, because I have to destroy and remake the databox
      # and that breaks the reference link.
      if setupbox
        @battle.battlers[battlerindex].eachAlly{|b|
          sendanim=SOSAdjustAnimation.new(@sprites,@viewport,
            @battle.pbGetOwnerIndexFromBattlerIndex(b.index)+1,b)
          dataanim=DataBoxAppearAnimation.new(@sprites,@viewport,b.index)
          sendOutAnims.push([sendanim,dataanim,false,b])
        }
      end
      loop do
        sendOutAnims.each do |a|
          next if a[2]
          a[0].update
          a[1].update if a[0].animDone?
          a[2] = true if a[1].animDone?
        end
        pbUpdate
        break if !sendOutAnims.any? { |a| !a[2] }
      end
      adjustAnims.each {|a| a[0].dispose}
      sendOutAnims.each { |a| a[0].dispose; a[1].dispose }
      # Play shininess animations for shiny Pokémon
      if @battle.showAnims && @battle.battlers[battlerindex].shiny?
        pbCommonAnimation("Shiny",@battle.battlers[battlerindex])
      end
    end
  end
   
  class SOSJoinAnimation < PokeBattle_Animation
    include PokeBattle_BallAnimationMixin
   
    def initialize(sprites,viewport,idxTrainer,battler)
      @idxTrainer     = idxTrainer
      @battler        = battler
      sprites["pokemon_#{battler.index}"].visible = false
      @shadowVisible = sprites["shadow_#{battler.index}"].visible
      sprites["shadow_#{battler.index}"].visible = false
      super(sprites,viewport)
    end
   
    def createProcesses
      batSprite = @sprites["pokemon_#{@battler.index}"]
      shaSprite = @sprites["shadow_#{@battler.index}"]
      # Calculate the Poké Ball graphic to use
      # Calculate the color to turn the battler sprite
      col = Tone.new(0,0,0,248)
      # Calculate start and end coordinates for battler sprite movement
      batSprite.src_rect.height=batSprite.bitmap.height
      battlerX = batSprite.x
      battlerY = batSprite.y
      delay = 0
      # Set up battler sprite
      battler = addSprite(batSprite,PictureOrigin::Bottom)
      battler.setXY(0,battlerX,battlerY)
      battler.setTone(0,col)
      # Battler animation
      battler.setVisible(delay,true)
      battler.setOpacity(delay,255)
      # NOTE: As soon as the battler sprite finishes zooming, and just as it
      #       starts changing its tone to normal, it plays its intro animation.
      col.gray = 0
      battler.moveTone(delay+5,10,col,[batSprite,:pbPlayIntroAnimation])
      if @shadowVisible
        # Set up shadow sprite
        shadow = addSprite(shaSprite,PictureOrigin::Center)
        shadow.setOpacity(0,0)
        # Shadow animation
        shadow.setVisible(delay,@shadowVisible)
        shadow.moveOpacity(delay+5,10,255)
      end
    end
  end
   
  class PokemonBattlerSprite < RPG::Sprite
    attr_accessor   :sideSize
  end
  class PokemonBattlerShadowSprite < RPG::Sprite
    attr_accessor   :sideSize
  end
   
  class SOSAdjustAnimation < PokeBattle_Animation
    include PokeBattle_BallAnimationMixin
   
    def initialize(sprites,viewport,idxTrainer,battler)
      @idxTrainer     = idxTrainer
      @battler        = battler
      @shadowVisible = sprites["shadow_#{battler.index}"].visible
      super(sprites,viewport)
    end
   
    def createProcesses
      batSprite = @sprites["pokemon_#{@battler.index}"]
      shaSprite = @sprites["shadow_#{@battler.index}"]
      batSprite.sideSize=@battler.battle.pbSideSize(@battler.index)
      shaSprite.sideSize=@battler.battle.pbSideSize(@battler.index)
      batSprite.pbSetPosition
      shaSprite.pbSetPosition if @shadowVisible
      battler = addSprite(batSprite,PictureOrigin::Bottom)
    end
  end
   
  ItemHandlers::CanUseInBattle.add(:ADRENALINEORB,proc { |item,pokemon,battler,move,firstAction,battle,scene,showMessages|
    if battle.adrenalineorb
      scene.pbDisplay(_INTL("It won't have any effect.")) if showMessages
      next false
    end
    next true
  })
   
  ItemHandlers::UseInBattle.add(:ADRENALINEORB,proc { |item,battler,battle|
    battle.adrenalineorb=true
    battle.pbDisplayPaused(_INTL("The {1} makes the wild Pokémon nervous!",PBItems.getName(item)))
  })