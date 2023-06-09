#===============================================================================
#
#===============================================================================
#===============================================================================
#
#===============================================================================
# Overhauls the classic Trainer Card from Pokémon Essentials
class Trainer
  # Random ID other than this Trainer's ID
  def make_foreign_ID(number = nil)
    loop do
      ret = rand(2 ** 16) | rand(2 ** 16) << 16
      return ret if ret != @id
    end
    return number if number != nil
    return 0
  end
end
#===============================================================================
#
#===============================================================================

class Player < Trainer
  # These need to be initialized
  # A swinging number, increases and decreases with progress
  attr_accessor(:score)
  # Changes the Trainer Card, similar to achievements
  attr_accessor(:stars)
  # Date and time
  attr_accessor(:hall_of_fame)
  # Fake Trainer Class
  attr_accessor(:trainer_class)

  def score
    @score = 0 if !@score
    return @score
  end

  def stars
    @stars = 0 if !@stars
    return @stars
  end

  def hall_of_fame
    @hall_of_fame = [] if !@hall_of_fame
    return @hall_of_fame
  end

  def trainer_class
    @trainer_class = "PKMN Trainer" if !@trainer_class
    return @trainer_class
  end

  def fullname2
    return _INTL("{1} {2}",@trainer_class,@name)
  end

  alias initialize_HGSS_Trainer_Card initialize
  def initialize(name, trainer_type)
    initialize_HGSS_Trainer_Card(name, trainer_type)
    @score         = 0
    @stars         = 0
    @hall_of_fame  = []
    @trainer_class ="PKMN Trainer"
  end
end
#===============================================================================
#
#===============================================================================

class HallOfFame_Scene # Minimal change to store HoF time into a variable

  def writeTrainerData
    totalsec = Graphics.frame_count / Graphics.frame_rate
    hour     = totalsec / 60 / 60
    min      = totalsec / 60 % 60
    # Store time of first Hall of Fame in $player.hall_of_fame if not array is empty
    if $player.hall_of_fame = []
      $player.hall_of_fame.push(pbGetTimeNow)
      $player.hall_of_fame.push(totalsec)
    end
    pubid     = sprintf("%05d",$player.public_ID)
    lefttext  = _INTL("Name<r>{1}<br>",$player.name)
    lefttext +=_INTL("IDNo.<r>{1}<br>",pubid)
    lefttext +=_ISPRINTF("Time<r>{1:02d}:{2:02d}<br>",hour,min)
    lefttext +=_INTL("Pokédex<r>{1}/{2}<br>",
        $player.pokedex.owned_count,$player.pokedex.seen_count)
    @sprites["messagebox"]          = Window_AdvancedTextPokemon.new(lefttext)
    @sprites["messagebox"].viewport = @viewport
    @sprites["messagebox"].width    = 192 if @sprites["messagebox"].width<192
    @sprites["msgwindow"]           = pbCreateMessageWindow(@viewport)
    pbMessageDisplay(@sprites["msgwindow"],
        _INTL("League champion!\nCongratulations!\\^"))
  end
end
#===============================================================================
#
#===============================================================================

class PokemonTrainerCard_Scene

  # Waits x frames
  def wait(frames)
    frames.times do
      Graphics.update
    end
  end

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
    if @sprites["bg"]
      @sprites["bg"].ox -= 2
      @sprites["bg"].oy -= 2
    end
  end

  def pbStartScene(vari=false)
    @front      = true
    @flip       = false
    @viewport   = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @sprites    = {}
    addBackgroundPlane(@sprites,"bg","Trainer Card/bg",@viewport)
	if vari==true
    @sprites["card"] = IconSprite.new(128*2,96*2,@viewport)
    @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card_#{$player.stars}")
    @sprites["card"].zoom_x = 2 ; @sprites["card"].zoom_y=2

    @sprites["card"].ox = @sprites["card"].bitmap.width/2
    @sprites["card"].oy = @sprites["card"].bitmap.height/2

    @sprites["bg"].zoom_x = 2
    @sprites["bg"].zoom_y = 2
    @sprites["bg"].ox    += 6
    @sprites["bg"].oy    -= 26
    @sprites["overlay"]   = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @sprites["overlay2"]  = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbSetSystemFont(@sprites["overlay2"].bitmap)

    @sprites["overlay"].x  = 128*2
    @sprites["overlay"].y  = 96*2
    @sprites["overlay"].ox = @sprites["overlay"].bitmap.width/2
    @sprites["overlay"].oy = @sprites["overlay"].bitmap.height/2

    @sprites["help_overlay"] = IconSprite.new(0,Graphics.height-48,@viewport)
    @sprites["help_overlay"].setBitmap("Graphics/Pictures/Trainer Card/overlay_0")
    @sprites["help_overlay"].zoom_x = 2 ; @sprites["help_overlay"].zoom_y=2
    @sprites["trainer"] = IconSprite.new(336,112,@viewport)
    @sprites["trainer"].setBitmap(GameData::TrainerType.player_front_sprite_filename($player.trainer_type))
    @sprites["trainer"].x -= (@sprites["trainer"].bitmap.width-128)/2+36-4
    @sprites["trainer"].y -= (@sprites["trainer"].bitmap.height-128)+80+4
    @sprites["trainer"].x += 120
    @sprites["trainer"].y += 80
    @tx=@sprites["trainer"].x
    @ty=@sprites["trainer"].y
    @sprites["trainer"].ox = @sprites["trainer"].bitmap.width/2
    pbDrawTrainerCardFront2
    pbFadeInAndShow(@sprites) { pbUpdate }
    else
    cardexists = pbResolveBitmap(sprintf("Graphics/Pictures/Trainer Card/card_f"))
    @sprites["card"] = IconSprite.new(0, 0, @viewport)
    if $player.female? && cardexists
      @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card_f")
    else
      @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card")
    end
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["trainer"] = IconSprite.new(336, 112, @viewport)
    @sprites["trainer"].setBitmap(GameData::TrainerType.player_front_sprite_filename($player.trainer_type))
    @sprites["trainer"].x -= (@sprites["trainer"].bitmap.width - 128) / 2
    @sprites["trainer"].y -= (@sprites["trainer"].bitmap.height - 128)
    @sprites["trainer"].z = 2
    pbDrawTrainerCardFront
    pbFadeInAndShow(@sprites) { pbUpdate }
	end
  end


  def flip1
    # "Flip"
    15.times do
      @sprites["overlay"].zoom_y   = 1.03
      @sprites["card"].zoom_y      = 2.06
      @sprites["overlay"].zoom_x  -= 0.1
      @sprites["trainer"].zoom_x  -= 0.1
      @sprites["overlay"].visible  = false if @sprites["overlay"].zoom_x <= 0
      @sprites["overlay2"].visible = false if @sprites["overlay"].zoom_x <= 0
      @sprites["trainer"].visible  = false if @sprites["trainer"].zoom_x <= 0
      @sprites["trainer"].x       -= 12
      @sprites["card"].zoom_x     -= 0.15
      pbUpdate
      wait(1)
    end
    pbUpdate
  end

  def flip2
    # UNDO "Flip"
    15.times do
      @sprites["overlay"].zoom_x  += 0.1
      @sprites["trainer"].zoom_x  += 0.1
      @sprites["overlay"].visible  = true if @sprites["overlay"].zoom_x >= 0
      @sprites["overlay2"].visible = true if @sprites["overlay"].zoom_x >= 0
      @sprites["trainer"].visible  = true if @sprites["trainer"].zoom_x >= 0 && @front
      @sprites["trainer"].x       += 12
      @sprites["card"].zoom_x     += 0.15
      @sprites["overlay"].zoom_y   = 1
      @sprites["card"].zoom_y      = 2
      pbUpdate
      wait(1)
    end
    pbUpdate
  end


  def pbDrawTrainerCardFront
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    baseColor   = Color.new(72, 72, 72)
    shadowColor = Color.new(160, 160, 160)
    totalsec = $stats.play_time.to_i
    hour = totalsec / 60 / 60
    min = totalsec / 60 % 60
    time = (hour > 0) ? _INTL("{1}h {2}m", hour, min) : _INTL("{1}m", min)

    if $player.playerhealth >= 80
         trainerhealth = _INTL("Healthy")
         healthColor=Color.new(255,255,255)
     else
       if $player.playerhealth >= 50
         trainerhealth = _INTL("Injured")
         healthColor=Color.new(255,255,255)
     else
        if $player.playerhealth >= 25
         trainerhealth = _INTL("Wounded")
         healthColor=Color.new(255,255,255)
     else
        if $player.playerhealth <= 24
         trainerhealth = _INTL("Critical")
         healthColor=Color.new(255,255,255)
        end
        end
     end
    end

    if $player.playerfood >= 80
         trainerhunger = _INTL("Full")
         hungerColor=Color.new(55,255,55)
       else
         if $player.playerfood >= 75
           trainerhunger = _INTL("Well Off")
           hungerColor=Color.new(255,255,55)
         else
           if $player.playerfood >= 50
             trainerhunger = _INTL("Hungry")
             hungerColor=Color.new(255,125,55)
           else
               if $player.playerfood >= 25
                trainerhunger = _INTL("Starving")
                hungerColor=Color.new(255,125,55)
                else
                 if $player.playerfood <= 24
                   trainerhunger= _INTL("Dying")
                   hungerColor=Color.new(255,55,55)
			    end
			   end
           end
         end
       end   


    if $player.playerwater >= 80
         trainerthirst = _INTL("Quenched")
         thirstColor=Color.new(55,255,55)
       else
         if $player.playerwater >= 75
           trainerthirst = _INTL("Well Off")
           thirstColor=Color.new(255,255,55)
         else
           if $player.playerwater >= 50
             trainerthirst = _INTL("Thirsty")
             thirstColor=Color.new(255,125,55)
           else
               if $player.playerwater >= 25
                trainerthirst = _INTL("Dehydrated")
                thirstColor=Color.new(255,125,55)
                else
                 if $player.playerwater <= 24
                   trainerthirst= _INTL("Dying")
                   thirstColor=Color.new(255,55,55)
			    end
			   end
           end
         end
       end   

    if $player.playersleep >= 80
          trainersleep = _INTL("Rested")
          sleepColor=Color.new(55,255,55)
       else
         if $player.playersleep >= 75
            trainersleep = _INTL("Well Off")
            sleepColor=Color.new(255,255,55)
         else
           if $player.playersleep >= 50
              trainersleep = _INTL("Tired")
              sleepColor=Color.new(255,125,55)
           else
               if $player.playersleep >= 25
                 trainersleep = _INTL("Deprived")
                 sleepColor=Color.new(255,125,55)
                else
                 if $player.playersleep <= 24
                   trainersleep= _INTL("Dying")
                   sleepColor=Color.new(255,55,55)
			    end
			   end
           end
         end
       end 
    $PokemonGlobal.startTime = pbGetTimeNow if !$PokemonGlobal.startTime
    starttime = _INTL("{1} {2}, {3}",
                      pbGetAbbrevMonthName($PokemonGlobal.startTime.mon),
                      $PokemonGlobal.startTime.day,
                      $PokemonGlobal.startTime.year)
    textPositions = [
      [_INTL("Name"), 34, 70, 0, baseColor, shadowColor],
      [$player.name, 302, 70, 1, baseColor, shadowColor],
      [_INTL("{1}",$player.playerclass), 332, 70, 0, baseColor, shadowColor],
      [_INTL("Lv{1}",$game_system.level_cap), 468, 70, 1, baseColor, shadowColor],
       [_INTL("Health"),40,103,0,baseColor,shadowColor],
       [_INTL(trainerhealth),302,103,1,healthColor,shadowColor],
       [_INTL("{1}%",$player.playerhealth.to_s_formatted),190,103,1,healthColor,shadowColor],
       [_INTL("Pokédex"),36,147,0,baseColor,shadowColor],
       [sprintf("%d/%d",$player.pokedex.owned_count,$player.pokedex.seen_count),302,147,1,baseColor,shadowColor],
       [_INTL("FOD"),34,186,0,baseColor,shadowColor],
       [_INTL(trainerhunger),302,186,1,hungerColor,shadowColor],
       [_INTL("{1}%",$player.playerfood.to_s_formatted),190,186,1,hungerColor,shadowColor],
       [_INTL("H20"),34,217,0,baseColor,shadowColor],
       [_INTL(trainerthirst),302,217,1,thirstColor,shadowColor],
       [_INTL("{1}%",$player.playerwater.to_s_formatted),190,217,1,thirstColor,shadowColor],
       [_INTL("SLP"),34,246,0,baseColor,shadowColor],
       [_INTL(trainersleep),302,246,1,sleepColor,shadowColor],
       [_INTL("{1}%",$player.playersleep.to_s_formatted),190,246,1,sleepColor,shadowColor]
    ]
    pbDrawTextPositions(overlay, textPositions)
    x = 72
    imagepos=[]
    # Draw Region 0 badges
	 if $game_switches[1176]==true
      imagepos.push(["Graphics/Pictures/Trainer Card/badges4",x,300,0*48,0*48,48,48])
      x += 48+8
	 end
	 if $game_switches[1177]==true
      imagepos.push(["Graphics/Pictures/Trainer Card/badges4",x,300,1*48,0*48,48,48])
      x += 48+8
	 end
	 if $game_switches[1178]==true
      imagepos.push(["Graphics/Pictures/Trainer Card/badges4",x,300,2*48,0*48,48,48])
      x += 48+8
	 end
	 if $game_switches[1179]==true
      imagepos.push(["Graphics/Pictures/Trainer Card/badges4",x,300,3*48,0*48,48,48])
	 end
    pbDrawImagePositions(overlay, imagepos)

  end

  def pbDrawTrainerCardFront2
    flip1 if @flip == true
    @front = true
    @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card_#{$player.stars}")
    @overlay  = @sprites["overlay"].bitmap
    @overlay2 = @sprites["overlay2"].bitmap
    @overlay.clear
    @overlay2.clear
    baseColor   = Color.new(72,72,72)
    shadowColor = Color.new(160,160,160)
    baseGold    = Color.new(255,198,74)
    shadowGold  = Color.new(123,107,74)
    if $player.stars == 5
      baseColor   = baseGold
      shadowColor = shadowGold
    end
    totalsec = Graphics.frame_count / Graphics.frame_rate
    hour     = totalsec / 60 / 60
    min      = totalsec / 60 % 60
    time     = _ISPRINTF("{1:02d}:{2:02d}",hour,min)
    $PokemonGlobal.startTime = pbGetTimeNow if !$PokemonGlobal.startTime
    starttime = _INTL("{1} {2}, {3}",
       pbGetAbbrevMonthName($PokemonGlobal.startTime.mon),
       $PokemonGlobal.startTime.day,
       $PokemonGlobal.startTime.year)
    textPositions = [
       [_INTL("NAME"),332-60,58-16,0,baseColor,shadowColor],
       [$player.name,302+89*2,58-16,1,baseColor,shadowColor],
       [_INTL("ID No."),32,58-16,0,baseColor,shadowColor],
       [sprintf("%05d",$player.public_ID),468-122*2,64-16,1,baseColor,shadowColor],
       [_INTL("MONEY"),32,106-16,0,baseColor,shadowColor],
       [_INTL("${1}",$player.money.to_s_formatted),302+2,112-16,1,baseColor,shadowColor],
       [_INTL("STRING 1"),32,106+32,0,baseColor,shadowColor],
       [sprintf("%d",$game_variables[410]),302+2,106+32,1,baseColor,shadowColor],
       [_INTL("SCORE"),32,202,0,baseColor,shadowColor],
       [sprintf("%d",$player.score),302+2,202,1,baseColor,shadowColor],
       [_INTL("TIME"),32,202+48,0,baseColor,shadowColor],
       [time,302+88*2,202+48,1,baseColor,shadowColor],
       [_INTL("ADVENTURE STARTED"),32,250+32,0,baseColor,shadowColor],
       [starttime,302+89*2,250+32,1,baseColor,shadowColor]
    ]
    @sprites["overlay"].z += 10
    pbDrawTextPositions(@overlay,textPositions)
    textPositions = [
      [_INTL("Press F5 to flip the card."),16,64+280,0,Color.new(216,216,216),Color.new(80,80,80)]
    ]
    @sprites["overlay2"].z+=20
    pbDrawTextPositions(@overlay2,textPositions)
    flip2 if @flip == true
  end

  def pbDrawTrainerCardBack2
    pbUpdate
    @flip = true
    flip1
    @front = false
    @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card_#{$player.stars}b")
    @overlay   = @sprites["overlay"].bitmap
    @overlay2  = @sprites["overlay2"].bitmap
    @overlay.clear
    @overlay2.clear
    baseColor   = Color.new(72,72,72)
    shadowColor = Color.new(160,160,160)
    baseGold    = Color.new(255,198,74)
    shadowGold  = Color.new(123,107,74)
    if $player.stars == 5
      baseColor   = baseGold
      shadowColor = shadowGold
    end
    hof=[]
    if $player.hall_of_fame != []
      hof.push(_INTL("{1} {2}, {3}",
        pbGetAbbrevMonthName($player.hall_of_fame[0].mon),
        $player.hall_of_fame[0].day,
        $player.hall_of_fame[0].year))
      hour = $player.hall_of_fame[1] / 60 / 60
      min  = $player.hall_of_fame[1] / 60 % 60
      time = _ISPRINTF("{1:02d}:{2:02d}",hour,min)
      hof.push(time)
    else
      hof.push("--- --, ----")
      hof.push("--:--")
    end
    textPositions = [
      [_INTL("HALL OF FAME DEBUT"),32,64-48,0,baseColor,shadowColor],
      [hof[0],302+89*2,58-48,1,baseColor,shadowColor],
      [hof[1],302+89*2,58-16,1,baseColor,shadowColor],
      # These are meant to be Link Battle modes, use as you wish, see below
      #[_INTL(" "),32+111*2,106-16,0,baseColor,shadowColor],
      #[_INTL(" "),32+176*2,106-16,0,baseColor,shadowColor],

      [_INTL("W"),32+111*2,106-16+32,0,baseColor,shadowColor],
      [_INTL("L"),32+176*2,106-16+32,0,baseColor,shadowColor],

      [_INTL("W"),32+111*2,106-16+64,0,baseColor,shadowColor],
      [_INTL("L"),32+176*2,106-16+64,0,baseColor,shadowColor],

      # Customize "$game_variables[410]" to use whatever variable you'd like
      # Some examples: eggs hatched, berries collected,
      # total steps (maybe converted to km/miles? Be creative, dunno!)
      # Pokémon defeated, shiny Pokémon encountered, etc.
      # While I do not include how to create those variables, feel free to HMU
      # if you need some support in the process, or reply to the Relic Castle
      # thread.

      [_INTL($player.fullname2),32,106-16,0,baseColor,shadowColor],
      #[_INTL(" ",$game_variables[410]),302+2+50-2,106-16,1,baseColor,shadowColor],
      #[_INTL(" ",$game_variables[410]),302+2+50+63*2,106-16,1,baseColor,shadowColor],

      [_INTL("STRING 2"),32,106+32-16,0,baseColor,shadowColor],
      [_INTL("{1}",$game_variables[410]),302+2+50-2,106+32-16,1,baseColor,shadowColor],
      [_INTL("{1}",$game_variables[410]),302+2+50+63*2,106+32-16,1,baseColor,shadowColor],

      [_INTL("STRING 3"),32,112+32-16+32,0,baseColor,shadowColor],
      [_INTL("{1}",$game_variables[410]),302+2+50-2,106+32-16+32,1,baseColor,shadowColor],
      [_INTL("{1}",$game_variables[410]),302+2+50+63*2,106+32-16+32,1,baseColor,shadowColor]
    ]
    @sprites["overlay"].z+=20
    pbDrawTextPositions(@overlay,textPositions)
    textPositions = [
      [_INTL("Press F5 to flip the card."),16,64+280,0,Color.new(216,216,216),Color.new(80,80,80)]
    ]
    @sprites["overlay2"].z += 20
    pbDrawTextPositions(@overlay2,textPositions)
    # Draw Badges on overlay (doesn't support animations, might support .gif)
    imagepos=[]
    # Draw Region 0 badges
    x = 64-28
    for i in 0...8
      imagepos.push(["Graphics/Pictures/Trainer Card/badges0",x,104*2,i*48,0*48,48,48]) if $player.badges[i+0*8]
      x += 48+8
    end
    # Draw Region 1 badges
    x = 64-28
    for i in 0...8
      imagepos.push(["Graphics/Pictures/Trainer Card/badges1",x,104*2+52,i*48,0*48,48,48]) if $player.badges[i+1*8]
      x += 48+8
    end
    #print(@sprites["overlay"].ox,@sprites["overlay"].oy,x)
    pbDrawImagePositions(@overlay,imagepos)
    flip2
  end

  def pbTrainerCard(vari=false)
    selection = 0 
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::USE) && vari == true
        if @front == true
          pbDrawTrainerCardBack2
          wait(3)
        else
          pbDrawTrainerCardFront2 if @front == false
          wait(3)
        end
      end
      if Input.trigger?(Input::RIGHT)
        FameChecker.create ? 1 : 0
      end
      if Input.trigger?(Input::BACK)
        break
      end
    end
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end
#===============================================================================
#
#===============================================================================

class PokemonTrainerCardScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen(vari=false)
    @scene.pbStartScene(vari)
    @scene.pbTrainerCard(vari)
    @scene.pbEndScene
  end
end
