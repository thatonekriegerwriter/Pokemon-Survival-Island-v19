#===============================================================================
#
#===============================================================================
class MoveSelectionSprite < SpriteWrapper
  attr_reader :preselected
  attr_reader :index
  def initialize(viewport=nil,fifthmove=false)
    super(viewport)
    # Sets the Move Selection Cursor
    if SUMMARY_B2W2_STYLE
      @movesel = AnimatedBitmap.new("Graphics/Pictures/Summary/cursor_move_B2W2")
    else
      @movesel = AnimatedBitmap.new("Graphics/Pictures/Summary/cursor_move")
    end
    @frame = 0
    @index = 0
    @fifthmove = fifthmove
    @preselected = false
    @updating = false
    refresh
  end

  def refresh
    w = @movesel.width
    h = @movesel.height/2
    self.x = 240
    # Changed the position of the Move Select cursor
    self.y = 91+(self.index*64)
    self.y -= 76 if @fifthmove
    self.y += 20 if @fifthmove && self.index==Pokemon::MAX_MOVES   # Add a gap
    self.bitmap = @movesel.bitmap
    if self.preselected
      self.src_rect.set(0,h,w,h)
    else
      self.src_rect.set(0,0,w,h)
    end
  end
end

#===============================================================================
#
#===============================================================================
class RibbonSelectionSprite < MoveSelectionSprite
  def initialize(viewport=nil)
    super(viewport)
    # Sets the Ribbon Selection Cursor
    if SUMMARY_B2W2_STYLE
      @movesel = AnimatedBitmap.new("Graphics/Pictures/Summary/cursor_ribbon_B2W2")
    else
      @movesel = AnimatedBitmap.new("Graphics/Pictures/Summary/cursor_ribbon")
    end
    @frame = 0
    @index = 0
    @preselected = false
    @updating = false
    @spriteVisible = true
    refresh
  end

  def refresh
    w = @movesel.width
    h = @movesel.height/2
 # Changed the position of the Ribbon Select cursor
    self.x = 0+(self.index%4)*68
    self.y = 72+((self.index/4).floor*68)
    self.bitmap = @movesel.bitmap
    if self.preselected
      self.src_rect.set(0,h,w,h)
    else
      self.src_rect.set(0,0,w,h)
    end
  end
end

#===============================================================================
#
#===============================================================================
class PokemonSummary_Scene
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
    # Sets the Moving Background
    if @sprites["background"]
      @sprites["background"].ox-= -1
      @sprites["background"].oy-= -1
    end
  end
  def pbStartScene(party,partyindex,inbattle=false)
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @party      = party
    @partyindex = partyindex
    @pokemon    = @party[@partyindex]
    @inbattle   = inbattle
    @page = 1
    @typebitmap    = AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
    @markingbitmap = AnimatedBitmap.new("Graphics/Pictures/Summary/markings")
    @sprites = {}
    # Sets the Summary Background
    # Background glitch fixed by Shashu-Greninja
    @sprites["bg_overlay"] = IconSprite.new(0,0,@viewport)
    if SUMMARY_B2W2_STYLE
      addBackgroundPlane(@sprites,"background","Summary/background_B2W2",@viewport)
    else
      addBackgroundPlane(@sprites,"background","Summary/background",@viewport)
    end
    # Sets the Moving Background Loop
    @sprites["background"].ox+=6
    @sprites["background"].oy-=36
    # Sets the Summary Overlays
    @sprites["menuoverlay"] = IconSprite.new(0,0,@viewport)
    @sprites["pokemon"] = PokemonSprite.new(@viewport)
    @sprites["pokemon"].setOffset(PictureOrigin::Center)
    # Changed the position of Pok??mon Battler
    @sprites["pokemon"].x = 414
    @sprites["pokemon"].y = 208
    @sprites["pokemon"].setPokemonBitmap(@pokemon)
    @sprites["pokeicon"] = PokemonIconSprite.new(@pokemon,@viewport)
    @sprites["pokeicon"].setOffset(PictureOrigin::Center)
    # Changed the position of Pok??mon Icon
    @sprites["pokeicon"].x       = 46
    @sprites["pokeicon"].y       = 92
    @sprites["pokeicon"].visible = false
    # Changed the position of the held Item icon
    @sprites["itemicon"] = ItemIconSprite.new(485,358,@pokemon.item_id,@viewport)
    @sprites["itemicon"].blankzero = true
    @sprites["overlay"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["movepresel"] = MoveSelectionSprite.new(@viewport)
    @sprites["movepresel"].visible     = false
    @sprites["movepresel"].preselected = true
    @sprites["movesel"] = MoveSelectionSprite.new(@viewport)
    @sprites["movesel"].visible = false
    # Draws the Ribbon Selection Cursor
    @sprites["ribbonpresel"] = RibbonSelectionSprite.new(@viewport)
    @sprites["ribbonpresel"].visible     = false
    @sprites["ribbonpresel"].preselected = true
    @sprites["ribbonsel"] = RibbonSelectionSprite.new(@viewport)
    @sprites["ribbonsel"].visible = false
    # Sets the Up Arrow in Ribbons Page
    @sprites["uparrow"] = AnimatedSprite.new("Graphics/Pictures/uparrow",8,28,40,2,@viewport)
    # Draws the Up Arrow in Ribbons Page
    @sprites["uparrow"].x = 260
    @sprites["uparrow"].y = 56
    @sprites["uparrow"].play
    @sprites["uparrow"].visible = false
    # Sets the Down Arrow in Ribbons Page
    @sprites["downarrow"] = AnimatedSprite.new("Graphics/Pictures/downarrow",8,28,40,2,@viewport)
    # Draws the Up Arrow in Ribbons Page
    @sprites["downarrow"].x = 260
    @sprites["downarrow"].y = 260
    @sprites["downarrow"].play
    @sprites["downarrow"].visible = false
    # Sets the Marking Overlay
    @sprites["markingbg"] = IconSprite.new(260,88,@viewport)
    @sprites["markingbg"].setBitmap("Graphics/Pictures/Summary/overlay_marking")
    @sprites["markingbg"].visible = false
    @sprites["markingoverlay"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @sprites["markingoverlay"].visible = false
    pbSetSystemFont(@sprites["markingoverlay"].bitmap)
    # Sets the Marking Selector
    @sprites["markingsel"] = IconSprite.new(0,0,@viewport)
    if SUMMARY_B2W2_STYLE
      @sprites["markingsel"].setBitmap("Graphics/Pictures/Summary/cursor_marking_B2W2")
    else
      @sprites["markingsel"].setBitmap("Graphics/Pictures/Summary/cursor_marking")
    end
    @sprites["markingsel"].src_rect.height = @sprites["markingsel"].bitmap.height/2
    @sprites["markingsel"].visible = false
    @sprites["messagebox"] = Window_AdvancedTextPokemon.new("")
    @sprites["messagebox"].viewport       = @viewport
    @sprites["messagebox"].visible        = false
    @sprites["messagebox"].letterbyletter = true
    pbBottomLeftLines(@sprites["messagebox"],2)
    drawPage(@page)
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def _ZUD_SummaryImages(textToHide=nil, line=nil)
    return if !@pokemon.dynamaxAble?
    base   = Color.new(90,82,82)
    shadow = Color.new(165,165,173)
    overlay = @sprites["overlay"].bitmap
    imagepos = []
    textpos = [["",0,0,0,Color.new(255,255,255),Color.new(165,165,173)]]
    imagepos.push(["Graphics/Pictures/Summary/gfactor",454,82,0,0,-1,-1]) if @pokemon.gmaxFactor?
    if @page==2
      if SUMMARY_B2W2_STYLE
        imagepos.push(["Graphics/Pictures/Summary/overlay_dynamax_B2W2",0,302,0,0,-1,-1])
      else
        imagepos.push(["Graphics/Pictures/Summary/overlay_dynamax",0,302,0,0,-1,-1])
      end
      textpos.push([_INTL("Dynamax Lv."),42,282,0,Color.new(255,255,255),Color.new(165,165,173)])
      imagepos.push(["Graphics/Pictures/Summary/dynamax_bar", 82, 332, 0, 0, @pokemon.dynamax_lvl*16, 14])
    end
    pbDrawImagePositions(overlay,imagepos)
    pbDrawTextPositions(overlay, textpos)
  end

  # Sets the Forget Move Screen
  def pbStartForgetScene(party,partyindex,move_to_learn)
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @party      = party
    @partyindex = partyindex
    @pokemon    = @party[@partyindex]
    @page = 4
    @typebitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
    @sprites = {}
    # Sets the Summary Background
    # Background glitch fixed by Shashu-Greninja
    @sprites["bg_overlay"] = IconSprite.new(0,0,@viewport)
    if SUMMARY_B2W2_STYLE
      addBackgroundPlane(@sprites,"background","Summary/background_B2W2",@viewport)
    else
      addBackgroundPlane(@sprites,"background","Summary/background",@viewport)
    end
    # Sets the Moving Background Loop
    @sprites["background"].ox+=6
    @sprites["background"].oy-=36
    # Sets the Summary Overlays
    @sprites["menuoverlay"] = IconSprite.new(0,0,@viewport)
    @sprites["overlay"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["pokeicon"] = PokemonIconSprite.new(@pokemon,@viewport)
    @sprites["pokeicon"].setOffset(PictureOrigin::Center)
    # Sets the Pok??mon Icon on the scene
    @sprites["pokeicon"].x       = 46
    @sprites["pokeicon"].y       = 92
    @sprites["movesel"] = MoveSelectionSprite.new(@viewport,!move_to_learn.nil?)
    @sprites["movesel"].visible = false
    @sprites["movesel"].visible = true
    @sprites["movesel"].index   = 0
    new_move = (move_to_learn) ? Pokemon::Move.new(move_to_learn) : nil
    drawSelectedMove(new_move,@pokemon.moves[0])
    pbFadeInAndShow(@sprites)
  end

#===============================================================================
# IV Ratings - Shows IV ratings on Page 3 (Stats)
#   Adaptaded from Lucidious89's IV star script by Tommaniacal
#
# Converted to BW Summary Pack by DeepBlue PacificWaves
#	Updated to v19 by Shashu-Greninja
#===============================================================================
  def pbDisplayIVRating
    ratingf  = sprintf("Graphics/Pictures/Summary/RatingF")
    ratingd  = sprintf("Graphics/Pictures/Summary/RatingD")
    ratingc  = sprintf("Graphics/Pictures/Summary/RatingC")
    ratingb  = sprintf("Graphics/Pictures/Summary/RatingB")
    ratinga  = sprintf("Graphics/Pictures/Summary/RatingA")
    ratings  = sprintf("Graphics/Pictures/Summary/RatingS")
    overlay  = @sprites["overlay"].bitmap
    imagepos = []
    # HP
    if @pokemon.iv[:HP]>30 || @pokemon.ivMaxed[:HP]
      imagepos.push([ratings,110,82,0,0,-1,-1])
    elsif @pokemon.iv[:HP]>22 && @pokemon.iv[:HP]<31
      imagepos.push([ratinga,110,82,0,0,-1,-1])
    elsif @pokemon.iv[:HP]>15 && @pokemon.iv[:HP]<23
      imagepos.push([ratingb,110,82,0,0,-1,-1])
    elsif @pokemon.iv[:HP]>7 && @pokemon.iv[:HP]<16
      imagepos.push([ratingc,110,82,0,0,-1,-1])
    elsif @pokemon.iv[:HP]>0 && @pokemon.iv[:HP]<8
      imagepos.push([ratingd,110,82,0,0,-1,-1])
    else
      imagepos.push([ratingf,110,82,0,0,-1,-1])
    end
    # ATK
    if @pokemon.iv[:ATTACK]>30 || @pokemon.ivMaxed[:ATTACK]
      imagepos.push([ratings,110,132,0,0,-1,-1])
    elsif @pokemon.iv[:ATTACK]>22 && @pokemon.iv[:ATTACK]<31
      imagepos.push([ratinga,110,132,0,0,-1,-1])
    elsif @pokemon.iv[:ATTACK]>15 && @pokemon.iv[:ATTACK]<23
      imagepos.push([ratingb,110,132,0,0,-1,-1])
    elsif @pokemon.iv[:ATTACK]>7 && @pokemon.iv[:ATTACK]<16
      imagepos.push([ratingc,110,132,0,0,-1,-1])
    elsif @pokemon.iv[:ATTACK]>0 && @pokemon.iv[:ATTACK]<8
      imagepos.push([ratingd,110,132,0,0,-1,-1])
    else
      imagepos.push([ratingf,110,132,0,0,-1,-1])
    end
    # DEF
    if @pokemon.iv[:DEFENSE]>30 || @pokemon.ivMaxed[:DEFENSE]
      imagepos.push([ratings,110,164,0,0,-1,-1])
    elsif @pokemon.iv[:DEFENSE]>22 && @pokemon.iv[:DEFENSE]<31
      imagepos.push([ratinga,110,164,0,0,-1,-1])
    elsif @pokemon.iv[:DEFENSE]>15 && @pokemon.iv[:DEFENSE]<23
      imagepos.push([ratingb,110,164,0,0,-1,-1])
    elsif @pokemon.iv[:DEFENSE]>7 && @pokemon.iv[:DEFENSE]<16
      imagepos.push([ratingc,110,164,0,0,-1,-1])
    elsif @pokemon.iv[:DEFENSE]>0 && @pokemon.iv[:DEFENSE]<8
      imagepos.push([ratingd,110,164,0,0,-1,-1])
    else
      imagepos.push([ratingf,110,164,0,0,-1,-1])
    end
    # SPATK
    if @pokemon.iv[:SPECIAL_ATTACK]>30 || @pokemon.ivMaxed[:SPECIAL_ATTACK]
      imagepos.push([ratings,110,196,0,0,-1,-1])
    elsif @pokemon.iv[:SPECIAL_ATTACK]>22 && @pokemon.iv[:SPECIAL_ATTACK]<31
      imagepos.push([ratinga,110,196,0,0,-1,-1])
    elsif @pokemon.iv[:SPECIAL_ATTACK]>15 && @pokemon.iv[:SPECIAL_ATTACK]<23
      imagepos.push([ratingb,110,196,0,0,-1,-1])
    elsif @pokemon.iv[:SPECIAL_ATTACK]>7 && @pokemon.iv[:SPECIAL_ATTACK]<16
      imagepos.push([ratingc,110,196,0,0,-1,-1])
    elsif @pokemon.iv[:SPECIAL_ATTACK]>0 && @pokemon.iv[:SPECIAL_ATTACK]<8
      imagepos.push([ratingd,110,196,0,0,-1,-1])
    else
      imagepos.push([ratingf,110,196,0,0,-1,-1])
    end
    # SPDEF
    if @pokemon.iv[:SPECIAL_DEFENSE]>30 || @pokemon.ivMaxed[:SPECIAL_DEFENSE]
      imagepos.push([ratings,110,228,0,0,-1,-1])
    elsif @pokemon.iv[:SPECIAL_DEFENSE]>22 && @pokemon.iv[:SPECIAL_DEFENSE]<31
      imagepos.push([ratinga,110,228,0,0,-1,-1])
    elsif @pokemon.iv[:SPECIAL_DEFENSE]>15 && @pokemon.iv[:SPECIAL_DEFENSE]<23
      imagepos.push([ratingb,110,228,0,0,-1,-1])
    elsif @pokemon.iv[:SPECIAL_DEFENSE]>7 && @pokemon.iv[:SPECIAL_DEFENSE]<16
      imagepos.push([ratingc,110,228,0,0,-1,-1])
    elsif @pokemon.iv[:SPECIAL_DEFENSE]>0 && @pokemon.iv[:SPECIAL_DEFENSE]<8
      imagepos.push([ratingd,110,228,0,0,-1,-1])
    else
      imagepos.push([ratingf,110,228,0,0,-1,-1])
    end
    # SPEED
    if @pokemon.iv[:SPEED]>30 || @pokemon.ivMaxed[:SPEED]
      imagepos.push([ratings,110,260,0,0,-1,-1])
    elsif @pokemon.iv[:SPEED]>22 && @pokemon.iv[:SPEED]<31
      imagepos.push([ratinga,110,260,0,0,-1,-1])
    elsif @pokemon.iv[:SPEED]>15 && @pokemon.iv[:SPEED]<23
      imagepos.push([ratingb,110,260,0,0,-1,-1])
    elsif @pokemon.iv[:SPEED]>7 && @pokemon.iv[:SPEED]<16
      imagepos.push([ratingc,110,260,0,0,-1,-1])
    elsif @pokemon.iv[:SPEED]>0 && @pokemon.iv[:SPEED]<8
      imagepos.push([ratingd,110,260,0,0,-1,-1])
    else
     imagepos.push([ratingf,110,260,0,0,-1,-1])
    end
    pbDrawImagePositions(overlay,imagepos)
  end
#=============================================================================

  def drawPage(page)
    if @pokemon.egg?
      drawPageOneEgg
      return
    end
    @sprites["itemicon"].item = @pokemon.item_id
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    # Changes the color of the text, to the one used in BW
    base   = Color.new(90,82,82)
    shadow = Color.new(165,165,173)
    # Set background image
    if SUMMARY_B2W2_STYLE
      @sprites["bg_overlay"].setBitmap("Graphics/Pictures/Summary/background_B2W2")
      @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_#{page}_B2W2")
    else
      @sprites["bg_overlay"].setBitmap("Graphics/Pictures/Summary/background")
      @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_#{page}")
    end
    imagepos=[]
    # Show the Pok?? Ball containing the Pok??mon
    ballimage = sprintf("Graphics/Pictures/Summary/icon_ball_%s", @pokemon.poke_ball)
    if !pbResolveBitmap(ballimage)
      ballimage = sprintf("Graphics/Pictures/Summary/icon_ball_%02d", pbGetBallType(@pokemon.poke_ball))
    end
    imagepos.push([ballimage,320,44])
    # Show status/fainted/Pok??rus infected icon
    status = 0
    if @pokemon.fainted?
      status = GameData::Status::DATA.keys.length / 2
    elsif @pokemon.status != :NONE
      status = GameData::Status.get(@pokemon.status).id_number
    elsif @pokemon.pokerusStage == 1
      status = GameData::Status::DATA.keys.length / 2 + 1
    end
    status -= 1
    if status >= 0
      imagepos.push(["Graphics/Pictures/statuses",410,88,0,16*status,44,16])
    end
    # Show Pok??rus cured icon
    if @pokemon.pokerusStage==2
      if SUMMARY_B2W2_STYLE
        imagepos.push([sprintf("Graphics/Pictures/Summary/icon_pokerus"),376,303])
      else
        imagepos.push([sprintf("Graphics/Pictures/Summary/icon_pokerus"),376,305])
      end
    end
    # Show shininess star
    if @pokemon.shiny?
      if SUMMARY_B2W2_STYLE
        imagepos.push([sprintf("Graphics/Pictures/shiny"),350,303])
      else
        imagepos.push([sprintf("Graphics/Pictures/shiny"),352,305])
      end
    end
    # Draw all images
    pbDrawImagePositions(overlay,imagepos)
    # Write various bits of text
    pagename = [_INTL("POK??MON INFO"),
                _INTL("TRAINER MEMO"),
                _INTL("SKILLS"),
                _INTL("MOVES"),
                _INTL("HAPPINESS"),
                _INTL("FAMILY TREE")][page-1]
    # Changed various positions of the text
    #============================================================================
    # Changed various positions of the text
    # Updated to ZUD Plugin by Shashu-Greninja
    #============================================================================
    if SUMMARY_B2W2_STYLE
      textpos = [
        [@pokemon.name,354,40,0,Color.new(90,82,82),Color.new(165,165,173)],
        [@pokemon.level.to_s,346,72,0,Color.new(90,82,82),Color.new(165,165,173)],
        [_INTL("Item"),298,314,0,base,shadow]
      ]
    else
      textpos = [
        [pagename,26,2,0,Color.new(255,255,255),Color.new(132,132,132)],
        [@pokemon.name,354,40,0,Color.new(90,82,82),Color.new(165,165,173)],
        [@pokemon.level.to_s,346,72,0,Color.new(90,82,82),Color.new(165,165,173)],
        [_INTL("Item"),298,316,0,base,shadow]
      ]
    end
    _ZUD_SummaryImages(textpos,2) if defined?(Settings::ZUD_COMPAT)
    # Write the held item's name
    if @pokemon.hasItem?
      textpos.push([@pokemon.item.name,290,344,0,base,shadow])
    else
      textpos.push([_INTL("None"),290,344,0,base,shadow])
    end
    # Write the gender symbol
    if @pokemon.male?
      textpos.push([_INTL("???"),486,40,0,Color.new(0,0,214),Color.new(15,148,255)])
    elsif @pokemon.female?
      textpos.push([_INTL("???"),486,40,0,Color.new(198,0,0),Color.new(255,155,155)])
    end
    # Draw all text
    pbDrawTextPositions(overlay,textpos)
    # Draw the Pok??mon's markings
    if SUMMARY_B2W2_STYLE
      drawMarkings(overlay,370,302)
    else
      drawMarkings(overlay,416,306)
    end
    # Draw page-specific information
    case page
    when 1 then drawPageOne
    when 2 then drawPageTwo
    when 3 then drawPageThree
    when 4 then drawPageFour
    when 5 then drawPageFive
    when 6 then drawPageSix
    end
  end

  def drawPageOne
    overlay = @sprites["overlay"].bitmap
    # Changes the color of the text, to the one used in BW
    base   = Color.new(255,255,255)
    shadow = Color.new(165,165,173)
    dexNumBase   = (@pokemon.shiny?) ? Color.new(198,0,0) : Color.new(90,82,82)
    dexNumShadow = (@pokemon.shiny?) ? Color.new(255,155,155) : Color.new(165,165,173)
    # If a Shadow Pok??mon, draw the heart gauge area and bar
    if @pokemon.shadowPokemon?
      shadowfract = @pokemon.heart_gauge.to_f / Pokemon::HEART_GAUGE_SIZE
      if SUMMARY_B2W2_STYLE
        imagepos = [
          ["Graphics/Pictures/Summary/overlay_shadow_B2W2",0,228],
          ["Graphics/Pictures/Summary/overlay_shadowbar",90,266,0,0,(shadowfract*248).floor,-1]
        ]
      else
        imagepos = [
          ["Graphics/Pictures/Summary/overlay_shadow",0,228],
          ["Graphics/Pictures/Summary/overlay_shadowbar",90,268,0,0,(shadowfract*248).floor,-1]
        ]
      end
      pbDrawImagePositions(overlay,imagepos)
    end
    # Write various bits of text. Changed various positions of the text
    if SUMMARY_B2W2_STYLE
      textpos = [
        [_INTL("Dex No."),34,60,0,base,shadow],
        [_INTL("Species"),34,92,0,base,shadow],
        [@pokemon.speciesName,164,92,0,Color.new(90,82,82),Color.new(165,165,173)],
        [_INTL("Type"),34,124,0,base,shadow],
        [_INTL("OT"),34,156,0,base,shadow],
        [_INTL("ID No."),34,188,0,base,shadow],
      ]
    else
      textpos = [
        [_INTL("Dex No."),34,62,0,base,shadow],
        [_INTL("Species"),34,94,0,base,shadow],
        [@pokemon.speciesName,164,94,0,Color.new(90,82,82),Color.new(165,165,173)],
        [_INTL("Type"),34,126,0,base,shadow],
        [_INTL("OT"),34,158,0,base,shadow],
        [_INTL("ID No."),34,190,0,base,shadow],
      ]
    end
    # Write the Regional/National Dex number
    dexnum = GameData::Species.get(@pokemon.species).id_number
    dexnumshift = false
    if $Trainer.pokedex.unlocked?(-1)   # National Dex is unlocked
      dexnumshift = true if Settings::DEXES_WITH_OFFSETS.include?(-1)
    else
      dexnum = 0
      for i in 0...$Trainer.pokedex.dexes_count - 1
        next if !$Trainer.pokedex.unlocked?(i)
        num = pbGetRegionalNumber(i,@pokemon.species)
        next if num<=0
        dexnum = num
        dexnumshift = true if Settings::DEXES_WITH_OFFSETS.include?(i)
        break
      end
    end
    if dexnum<=0
      if SUMMARY_B2W2_STYLE
        # Write ??? if Pok??mon is not found in the Dex
        textpos.push(["???",164,60,0,dexNumBase,dexNumShadow])
      else
        textpos.push(["???",164,62,0,dexNumBase,dexNumShadow])
      end
    else
      dexnum -= 1 if dexnumshift
      # Write the Dex Number
      if SUMMARY_B2W2_STYLE
        textpos.push([sprintf("%03d",dexnum),164,60,0,dexNumBase,dexNumShadow])
      else
        textpos.push([sprintf("%03d",dexnum),164,62,0,dexNumBase,dexNumShadow])
      end
    end
    # Write Original Trainer's name and ID number
    if @pokemon.owner.name.empty?
      if SUMMARY_B2W2_STYLE
        textpos.push([_INTL("RENTAL"),164,156,0,Color.new(90,82,82),Color.new(165,165,173)])
        textpos.push(["?????",164,186,0,Color.new(90,82,82),Color.new(165,165,173)])
      else
        textpos.push([_INTL("RENTAL"),164,158,0,Color.new(90,82,82),Color.new(165,165,173)])
        textpos.push(["?????",164,188,0,Color.new(90,82,82),Color.new(165,165,173)])
      end
    else
      # Changes the color of the text, to the one used in BW
      ownerbase   = Color.new(90,82,82)
      ownershadow = Color.new(165,165,173)
      case @pokemon.owner.gender
      when 0
        ownerbase = Color.new(0,0,214)
        ownershadow = Color.new(15,148,255)
      when 1
        ownerbase = Color.new(198,0,0)
        ownershadow = Color.new(255,155,155)
      end
      if SUMMARY_B2W2_STYLE
        # Write Trainer's name
        textpos.push([@pokemon.owner.name,164,156,0,ownerbase,ownershadow])
        # Write Pok??mon's ID
        textpos.push([sprintf("%05d",@pokemon.owner.public_id),164,188,0,Color.new(90,82,82),Color.new(165,165,173)])
      else
        # Write Trainer's name
        textpos.push([@pokemon.owner.name,164,158,0,ownerbase,ownershadow])
        # Write Pok??mon's ID
        textpos.push([sprintf("%05d",@pokemon.owner.public_id),164,190,0,Color.new(90,82,82),Color.new(165,165,173)])
      end
    end
    # Write Exp text OR heart gauge message (if a Shadow Pok??mon)
    if @pokemon.shadowPokemon?
      textpos.push([_INTL("Heart Gauge"),33,222,0,base,shadow])
      heartmessage = [_INTL("The door to its heart is open! Undo the final lock!"),
                      _INTL("The door to its heart is almost fully open."),
                      _INTL("The door to its heart is nearly open."),
                      _INTL("The door to its heart is opening wider."),
                      _INTL("The door to its heart is opening up."),
                      _INTL("The door to its heart is tightly shut.")][@pokemon.heartStage]
       # Changed the text color, to the one used in BW
       memo = sprintf("<c3=404040,B0B0B0>%s\n",heartmessage)
       y_coord = SUMMARY_B2W2_STYLE ? 294 : 296
       drawFormattedTextEx(overlay,16,y_coord,264,memo)
    else
      endexp = @pokemon.growth_rate.minimum_exp_for_level(@pokemon.level + 1)
      if SUMMARY_B2W2_STYLE
        textpos.push([_INTL("Exp. Points"),34,220,0,base,shadow])
        # Changed the Positon of No. of Exp
        textpos.push([@pokemon.exp.to_s_formatted,215,252,2,Color.new(90,82,82),Color.new(165,165,173)])
        textpos.push([_INTL("To Next Lv."),34,284,0,base,shadow])
        # Changed the Positon of No. of Exp to Next Level
        textpos.push([(endexp-@pokemon.exp).to_s_formatted,177,316,2,Color.new(90,82,82),Color.new(165,165,173)])
      else
        textpos.push([_INTL("Exp. Points"),34,222,0,base,shadow])
        # Changed the Positon of No. of Exp
        textpos.push([@pokemon.exp.to_s_formatted,215,254,2,Color.new(90,82,82),Color.new(165,165,173)])
        textpos.push([_INTL("To Next Lv."),34,286,0,base,shadow])
        # Changed the Positon of No. of Exp to Next Level
        textpos.push([(endexp-@pokemon.exp).to_s_formatted,177,318,2,Color.new(90,82,82),Color.new(165,165,173)])
      end
    end
    # Draw all text
    pbDrawTextPositions(overlay,textpos)
    # Draw Pok??mon type(s)
    type1_number = GameData::Type.get(@pokemon.type1).id_number
    type2_number = GameData::Type.get(@pokemon.type2).id_number
    type1rect = Rect.new(0, type1_number * 28, 64, 28)
    type2rect = Rect.new(0, type2_number * 28, 64, 28)
    if @pokemon.type1==@pokemon.type2
      if SUMMARY_B2W2_STYLE
        overlay.blt(164,132,@typebitmap.bitmap,type1rect)
      else
        overlay.blt(164,134,@typebitmap.bitmap,type1rect)
      end
    else
      if SUMMARY_B2W2_STYLE
        overlay.blt(164,132,@typebitmap.bitmap,type1rect)
        overlay.blt(232,132,@typebitmap.bitmap,type2rect)
      else
        overlay.blt(164,134,@typebitmap.bitmap,type1rect)
        overlay.blt(232,134,@typebitmap.bitmap,type2rect)
      end
    end
    # Draw Exp bar
    if @pokemon.level<GameData::GrowthRate.max_level
      w = @pokemon.exp_fraction * 128
      w = ((w/2).round)*2
      if SUMMARY_B2W2_STYLE
        pbDrawImagePositions(overlay,[["Graphics/Pictures/Summary/overlay_exp",140,358,0,0,w,6]])
      else
        pbDrawImagePositions(overlay,[["Graphics/Pictures/Summary/overlay_exp",140,360,0,0,w,6]])
      end
    end
  end

  def drawPageOneEgg
    @sprites["itemicon"].item = @pokemon.item_id
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    # Changes the color of the text, to the one used in BW
    base   = Color.new(90,82,82)
    shadow = Color.new(165,165,173)
    # Set background image
    if SUMMARY_B2W2_STYLE
      @sprites["bg_overlay"].setBitmap("Graphics/Pictures/Summary/background")
      @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_egg_B2W2")
    else
      @sprites["bg_overlay"].setBitmap("Graphics/Pictures/Summary/background")
      @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_egg")
    end
    imagepos = []
    # Show the Pok?? Ball containing the Pok??mon
    ballimage = sprintf("Graphics/Pictures/Summary/icon_ball_%s", @pokemon.poke_ball)
    if !pbResolveBitmap(ballimage)
      ballimage = sprintf("Graphics/Pictures/Summary/icon_ball_%02d", pbGetBallType(@pokemon.poke_ball))
    end
    imagepos.push([ballimage,320,50])
    # Draw all images
    pbDrawImagePositions(overlay,imagepos)
    # Write various bits of text
    if SUMMARY_B2W2_STYLE
      textpos = [
        [@pokemon.name,354,40,0,base,shadow],
        [_INTL("Item"),298,314,0,base,shadow]
      ]
    else
      textpos = [
        [_INTL("TRAINER MEMO"),26,2,0,Color.new(255,255,255),Color.new(132,132,132)],
        [@pokemon.name,354,40,0,base,shadow],
        [_INTL("Item"),298,316,0,base,shadow]
      ]
    end
    # Write the held item's name
    if @pokemon.hasItem?
      textpos.push([@pokemon.item.name,290,344,0,base,shadow])
    else
      textpos.push([_INTL("None"),290,344,0,base,shadow])
    end
    # Draw all text
    pbDrawTextPositions(overlay,textpos)
    memo = ""
    # Write date received
    if @pokemon.timeReceived
      date  = @pokemon.timeReceived.day
      month = pbGetMonthName(@pokemon.timeReceived.mon)
      year  = @pokemon.timeReceived.year
      # Changed the color of the text, to the one used in BW
      memo += _INTL("<c3=404040,B0B0B0>{1} {2}, {3}\n",date,month,year)
    end
    # Write map name egg was received on
    mapname = pbGetMapNameFromId(@pokemon.obtain_map)
    mapname = @pokemon.obtain_text if @pokemon.obtain_text && !@pokemon.obtain_text.empty?
    if mapname && mapname != ""
      # Changed the color of the text, to the one used in BW
      memo += _INTL("<c3=404040,B0B0B0>A mysterious Pok??mon Egg received from <c3=0000D6,7394FF>{1}<c3=404040,B0B0B0>.\n",mapname)
    else
      # Changed the color of the text, to the one used in BW
      memo += _INTL("<c3=404040,B0B0B0>A mysterious Pok??mon Egg.\n",mapname)
    end
    memo += "\n" # Empty line
    # Write Egg Watch blurb
    memo += _INTL("<c3=404040,B0B0B0>\"The Egg Watch\"\n")
    eggstate = _INTL("It looks like this Egg will take a long time to hatch.")
    eggstate = _INTL("What will hatch from this? It doesn't seem close to hatching.") if @pokemon.steps_to_hatch < 10200
    eggstate = _INTL("It appears to move occasionally. It may be close to hatching.") if @pokemon.steps_to_hatch < 2550
    eggstate = _INTL("Sounds can be heard coming from inside! It will hatch soon!") if @pokemon.steps_to_hatch < 1275
    memo += sprintf("<c3=404040,B0B0B0>%s\n",eggstate)
    # Draw all text
    drawFormattedTextEx(overlay,10,86,268,memo)
    # Draw the Pok??mon's markings
    if SUMMARY_B2W2_STYLE
      drawMarkings(overlay,370,302)
    else
      drawMarkings(overlay,416,306)
    end
  end

  def drawPageTwo
    overlay = @sprites["overlay"].bitmap
    memo = ""
    # Write nature
    showNature = !@pokemon.shadowPokemon? || @pokemon.heartStage>3
    if showNature
      natureName = @pokemon.nature.name
      # Changed the color of the text, to the one used in BW
      memo += _INTL("<c3=0000d6,7394ff>{1}<c3=404040,B0B0B0> nature.\n",natureName)
    end
    # Write date received
    if @pokemon.timeReceived
      date  = @pokemon.timeReceived.day
      month = pbGetMonthName(@pokemon.timeReceived.mon)
      year  = @pokemon.timeReceived.year
      # Changed the color of the text, to the one used in BW
      memo += _INTL("<c3=404040,B0B0B0>{1} {2}, {3}\n",date,month,year)
    end
     # Write map name Pok??mon was received on
    mapname = pbGetMapNameFromId(@pokemon.obtain_map)
    mapname = @pokemon.obtain_text if @pokemon.obtain_text && !@pokemon.obtain_text.empty?
    mapname = _INTL("Faraway place") if !mapname || mapname==""
    # Changed the color of the text, to the one used in BW
    memo += sprintf("<c3=0000d6,7394ff>%s\n",mapname)
    # Write how Pok??mon was obtained
    mettext = [_INTL("Met at Lv. {1}.",@pokemon.obtain_level),
               _INTL("Egg received."),
               _INTL("Traded at Lv. {1}.",@pokemon.obtain_level),
               "",
               _INTL("Had a fateful encounter at Lv. {1}.",@pokemon.obtain_level)
              ][@pokemon.obtain_method]
              # Changed the color of the text, to the one used in BW
    memo += sprintf("<c3=404040,B0B0B0>%s\n",mettext) if mettext && mettext!=""
    # If Pok??mon was hatched, write when and where it hatched
    if @pokemon.obtain_method == 1
      if @pokemon.timeEggHatched
        date  = @pokemon.timeEggHatched.day
        month = pbGetMonthName(@pokemon.timeEggHatched.mon)
        year  = @pokemon.timeEggHatched.year
        # Changed the color of the text, to the one used in BW
        memo += _INTL("<c3=404040,B0B0B0>{1} {2}, {3}\n",date,month,year)
      end
      mapname = pbGetMapNameFromId(@pokemon.hatched_map)
      mapname = _INTL("Faraway place") if nil_or_empty?(mapname)
        # Changed the colors of the text, to the one used in BW
      memo += sprintf("<c3=C60000,FF7373>%s\n",mapname)
      memo += _INTL("<c3=404040,B0B0B0>Egg hatched.\n")
    else
      memo += "\n"   # Empty line
    end
    # Write characteristic
    if showNature
      best_stat = nil
      best_iv = 0
      stats_order = [:HP, :ATTACK, :DEFENSE, :SPEED, :SPECIAL_ATTACK, :SPECIAL_DEFENSE]
      start_point = @pokemon.personalID % stats_order.length   # Tiebreaker
      for i in 0...stats_order.length
        stat = stats_order[(i + start_point) % stats_order.length]
        if !best_stat || @pokemon.iv[stat] > @pokemon.iv[best_stat]
          best_stat = stat
          best_iv = @pokemon.iv[best_stat]
        end
      end
      characteristics = {
        :HP              => [_INTL("Loves to eat."),
                             _INTL("Takes plenty of siestas."),
                             _INTL("Nods off a lot."),
                             _INTL("Scatters things often."),
                             _INTL("Likes to relax.")],
        :ATTACK          => [_INTL("Proud of its power."),
                             _INTL("Likes to thrash about."),
                             _INTL("A little quick tempered."),
                             _INTL("Likes to fight."),
                             _INTL("Quick tempered.")],
        :DEFENSE         => [_INTL("Sturdy body."),
                             _INTL("Capable of taking hits."),
                             _INTL("Highly persistent."),
                             _INTL("Good endurance."),
                             _INTL("Good perseverance.")],
        :SPECIAL_ATTACK  => [_INTL("Highly curious."),
                             _INTL("Mischievous."),
                             _INTL("Thoroughly cunning."),
                             _INTL("Often lost in thought."),
                             _INTL("Very finicky.")],
        :SPECIAL_DEFENSE => [_INTL("Strong willed."),
                             _INTL("Somewhat vain."),
                             _INTL("Strongly defiant."),
                             _INTL("Hates to lose."),
                             _INTL("Somewhat stubborn.")],
        :SPEED           => [_INTL("Likes to run."),
                             _INTL("Alert to sounds."),
                             _INTL("Impetuous and silly."),
                             _INTL("Somewhat of a clown."),
                             _INTL("Quick to flee.")]
      }
      memo += sprintf("<c3=404040,B0B0B0>%s\n", characteristics[best_stat][best_iv % 5])
    end
    # Write all text
    drawFormattedTextEx(overlay,12,68,300,memo)
  end

  def drawPageThree
    overlay = @sprites["overlay"].bitmap
    # Changes the color of the text, to the one used in BW
    base   = Color.new(90,82,82)
    shadow = Color.new(165,165,173)
    if SHOW_EV_IV
      # Set background image when showing EV/IV Stats
      @sprites["bg_overlay"].setBitmap("Graphics/Pictures/Summary/background")
      @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_hidden")
    end
    if SHOW_EV_IV && SUMMARY_B2W2_STYLE
      # Set background image when showing EV/IV Stats
      @sprites["bg_overlay"].setBitmap("Graphics/Pictures/Summary/background_B2W2")
      @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_hidden_B2W2")
    end
    # Show IV Letters Grades
    pbDisplayIVRating if SHOW_IV_RATINGS
    # Determine which stats are boosted and lowered by the Pok??mon's nature
    # Stats Shadow Bug fixed by Shashu-Greninja
    statshadows = {}
    GameData::Stat.each_main { |s| statshadows[s.id] = shadow }
    if !@pokemon.shadowPokemon? || @pokemon.heartStage > 3
      @pokemon.nature_for_stats.stat_changes.each do |change|
        if INVERTED_SHADOW_STATS
          statshadows[change[0]] = Color.new(148,148,214) if change[1] > 0
          statshadows[change[0]] = Color.new(206,148,156) if change[1] < 0
        else
          statshadows[change[0]] = Color.new(206,148,156) if change[1] > 0
          statshadows[change[0]] = Color.new(148,148,214) if change[1] < 0
        end
      end
    end
#===============================================================================
# Stat Screen Upgrade (EVs and IVs in Summary)
#   By Weibrot, Kobi2604 and dirkriptide
#
#     Converted to BW Summary Pack by DeepBlue PacificWaves
#    Updated to v19 by Shashu-Greninja
#===============================================================================
# Write various bits of text
    if SHOW_EV_IV
      textpos = [
        [_INTL("HP"),64,70,0,Color.new(255,255,255),statshadows[:HP]],
        [sprintf("%d/%d",@pokemon.hp,@pokemon.totalhp),182,70,2,base,shadow],
        [sprintf("%d",@pokemon.ev[:HP]),252,70,2,base,shadow],
        [sprintf("%d",@pokemon.iv[:HP]),296,70,2,base,shadow],
        [_INTL("Attack"),16,120,0,Color.new(255,255,255),statshadows[:ATTACK]],
        [sprintf("%d",@pokemon.attack),182,120,2,base,shadow],
        [sprintf("%d",@pokemon.ev[:ATTACK]),252,120,2,base,shadow],
        [sprintf("%d",@pokemon.iv[:ATTACK]),296,120,2,base,shadow],
        [_INTL("Defense"),16,152,0,Color.new(255,255,255),statshadows[:DEFENSE]],
        [sprintf("%d",@pokemon.defense),182,152,2,base,shadow],
        [sprintf("%d",@pokemon.ev[:DEFENSE]),252,152,2,base,shadow],
        [sprintf("%d",@pokemon.iv[:DEFENSE]),296,152,2,base,shadow],
        [_INTL("Sp. Atk"),16,184,0,Color.new(255,255,255),statshadows[:SPECIAL_ATTACK]],
        [sprintf("%d",@pokemon.spatk),182,184,2,base,shadow],
        [sprintf("%d",@pokemon.ev[:SPECIAL_ATTACK]),252,184,2,base,shadow],
        [sprintf("%d",@pokemon.iv[:SPECIAL_ATTACK]),296,184,2,base,shadow],
        [_INTL("Sp. Def"),16,216,0,Color.new(255,255,255),statshadows[:SPECIAL_DEFENSE]],
        [sprintf("%d",@pokemon.spdef),182,216,2,base,shadow],
        [sprintf("%d",@pokemon.ev[:SPECIAL_DEFENSE]),252,216,2,base,shadow],
        [sprintf("%d",@pokemon.iv[:SPECIAL_DEFENSE]),296,216,2,base,shadow],
        [_INTL("Speed"),16,248,0,Color.new(255,255,255),statshadows[:SPEED]],
        [sprintf("%d",@pokemon.speed),182,248,2,base,shadow],
        [sprintf("%d",@pokemon.ev[:SPEED]),252,248,2,base,shadow],
        [sprintf("%d",@pokemon.iv[:SPEED]),296,248,2,base,shadow],
        [_INTL("Ability"),38,282,0,Color.new(255,255,255),Color.new(165,165,173)],
      ]
    else
      textpos = [
        [_INTL("HP"),64,70,0,Color.new(255,255,255),statshadows[:HP]],
        [sprintf("%d/%d",@pokemon.hp,@pokemon.totalhp),212,70,2,base,shadow],
        [_INTL("Attack"),16,120,0,Color.new(255,255,255),statshadows[:ATTACK]],
        [sprintf("%d",@pokemon.attack),212,120,2,base,shadow],
        [_INTL("Defense"),16,152,0,Color.new(255,255,255),statshadows[:DEFENSE]],
        [sprintf("%d",@pokemon.defense),212,152,2,base,shadow],
        [_INTL("Sp. Atk"),16,184,0,Color.new(255,255,255),statshadows[:SPECIAL_ATTACK]],
        [sprintf("%d",@pokemon.spatk),212,184,2,base,shadow],
        [_INTL("Sp. Def"),16,216,0,Color.new(255,255,255),statshadows[:SPECIAL_DEFENSE]],
        [sprintf("%d",@pokemon.spdef),212,216,2,base,shadow],
        [_INTL("Speed"),16,248,0,Color.new(255,255,255),statshadows[:SPEED]],
        [sprintf("%d",@pokemon.speed),212,248,2,base,shadow],
        [_INTL("Ability"),38,282,0,Color.new(255,255,255),Color.new(165,165,173)],
      ]
    end
    # Draw ability name and description
    ability = @pokemon.ability
    if ability
      textpos.push([ability.name,240,282,2,Color.new(90,82,82),Color.new(165,165,173)])
      drawTextEx(overlay,12,324,282,2,ability.description,base,shadow)
    end
    # Draw all text
    pbDrawTextPositions(overlay,textpos)
    # Draw HP bar
    if @pokemon.hp>0
      w = @pokemon.hp*96*1.0/@pokemon.totalhp
      w = 1 if w<1
      w = ((w/2).round)*2
      hpzone = 0
      hpzone = 1 if @pokemon.hp<=(@pokemon.totalhp/2).floor
      hpzone = 2 if @pokemon.hp<=(@pokemon.totalhp/4).floor
      if SHOW_EV_IV
        imagepos = [["Graphics/Pictures/Summary/overlay_hp",190,112,0,hpzone*6,w,6]]
      else
        imagepos = [["Graphics/Pictures/Summary/overlay_hp",168,112,0,hpzone*6,w,6]]
      end
      pbDrawImagePositions(overlay,imagepos)
    end
  end

  def drawPageFour
    overlay = @sprites["overlay"].bitmap
    # Changes the color of the text, to the one used in BW
    moveBase   = Color.new(255,255,255)
    moveShadow = Color.new(123,123,123)
    ppBase   = [moveBase,                # More than 1/2 of total PP
                Color.new(255,214,0),    # 1/2 of total PP or less
                Color.new(255,115,0),   # 1/4 of total PP or less
                Color.new(255,8,72)]    # Zero PP
    ppShadow = [moveShadow,             # More than 1/2 of total PP
                Color.new(123,99,0),   # 1/2 of total PP or less
                Color.new(115,57,0),   # 1/4 of total PP or less
                Color.new(123,8,49)]   # Zero PP
    @sprites["pokemon"].visible  = true
    @sprites["pokeicon"].visible = false
    @sprites["itemicon"].visible = true
    textpos  = []
    imagepos = []
    # Write move names, types and PP amounts for each known move
    yPos = 76
    for i in 0...Pokemon::MAX_MOVES
      move=@pokemon.moves[i]
      if move
        type_number = GameData::Type.get(move.type).id_number
        imagepos.push(["Graphics/Pictures/types", 32, yPos + 8, 0, type_number * 28, 64, 28])
        textpos.push([move.name,100,yPos,0,moveBase,moveShadow])
        if move.total_pp>0
          textpos.push([_INTL("PP"),126,yPos+32,0,moveBase,moveShadow])
          ppfraction = 0
          if move.pp==0;                  ppfraction = 3
          elsif move.pp*4<=move.total_pp; ppfraction = 2
          elsif move.pp*2<=move.total_pp; ppfraction = 1
          end
          textpos.push([sprintf("%d/%d",move.pp,move.total_pp),244,yPos+32,1,ppBase[ppfraction],ppShadow[ppfraction]])
        end
      else
        textpos.push(["-",100,yPos,0,moveBase,moveShadow])
        textpos.push(["--",226,yPos+32,1,moveBase,moveShadow])
      end
      yPos += 64
    end
    # Draw all text and images
    pbDrawTextPositions(overlay,textpos)
    pbDrawImagePositions(overlay,imagepos)
  end

  def drawPageFourSelecting(move_to_learn)
    # Learn a New Move Scene
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    # Changes the color of the text, to the one used in BW
    base   = Color.new(255,255,255)
    shadow = Color.new(123,123,123)
    moveBase   = Color.new(255,255,255)
    moveShadow = Color.new(123,123,123)
    ppBase   = [moveBase,                # More than 1/2 of total PP
                Color.new(255,214,0),    # 1/2 of total PP or less
                Color.new(255,115,0),   # 1/4 of total PP or less
                Color.new(255,8,74)]    # Zero PP
    ppShadow = [moveShadow,             # More than 1/2 of total PP
                Color.new(123,99,0),   # 1/2 of total PP or less
                Color.new(115,57,0),   # 1/4 of total PP or less
                Color.new(123,8,49)]   # Zero PP
    # Set background image
    if move_to_learn
      @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_learnmove")
    else
      if SUMMARY_B2W2_STYLE
        @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_movedetail_B2W2")
      else
        @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_movedetail")
      end
    end
    # Write various bits of text
    if move_to_learn || SUMMARY_B2W2_STYLE
      textpos = [
        [_INTL("CATEGORY"),20,116,0,base,shadow],
        [_INTL("POWER"),20,148,0,base,shadow],
        [_INTL("ACCURACY"),20,180,0,base,shadow]
      ]
    else
      textpos = [
        [_INTL("MOVES"),26,2,0,base,shadow],
        [_INTL("CATEGORY"),20,116,0,base,shadow],
        [_INTL("POWER"),20,148,0,base,shadow],
        [_INTL("ACCURACY"),20,180,0,base,shadow]
      ]
    end
    imagepos = []
    # Write move names, types and PP amounts for each known move
    yPos = 92
    yPos -= 76 if move_to_learn
    limit = (move_to_learn) ? Pokemon::MAX_MOVES + 1 : Pokemon::MAX_MOVES
    for i in 0...limit
      move = @pokemon.moves[i]
      if i==Pokemon::MAX_MOVES
        move = move_to_learn
        yPos += 20
      end
      if move
        #-----------------------------------------------------------------------
        # ZUD - Max Move display.
        #-----------------------------------------------------------------------
        maxmove = (defined?(Settings::ZUD_COMPAT) && !move_to_learn) ? _ZUD_DrawMoveSel(move)[0] : move
        type_number = GameData::Type.get(maxmove.type).id_number
        imagepos.push(["Graphics/Pictures/types", 260, yPos + 8, 0, type_number * 28, 64, 28])
        textpos.push([maxmove.name,328,yPos,0,moveBase,moveShadow])
        #-----------------------------------------------------------------------
        if move.total_pp>0
          textpos.push([_INTL("PP"),354,yPos+32,0,moveBase,moveShadow])
          ppfraction = 0
          if move.pp==0;                  ppfraction = 3
          elsif move.pp*4<=move.total_pp; ppfraction = 2
          elsif move.pp*2<=move.total_pp; ppfraction = 1
          end
          textpos.push([sprintf("%d/%d",move.pp,move.total_pp),472,yPos+32,1,ppBase[ppfraction],ppShadow[ppfraction]])
        end
      else
        textpos.push(["-",328,yPos,0,moveBase,moveShadow])
        textpos.push(["--",454,yPos+32,1,moveBase,moveShadow])
      end
      yPos += 64
    end
    # Draw all text and images
    pbDrawTextPositions(overlay,textpos)
    pbDrawImagePositions(overlay,imagepos)
    # Draw Pok??mon's type icon(s)
    type1_number = GameData::Type.get(@pokemon.type1).id_number
    type2_number = GameData::Type.get(@pokemon.type2).id_number
    type1rect = Rect.new(0, type1_number * 28, 64, 28)
    type2rect = Rect.new(0, type2_number * 28, 64, 28)
    if @pokemon.type1==@pokemon.type2
      overlay.blt(130,78,@typebitmap.bitmap,type1rect)
    else
      overlay.blt(96,78,@typebitmap.bitmap,type1rect)
      overlay.blt(166,78,@typebitmap.bitmap,type2rect)
    end
  end

  def drawSelectedMove(move_to_learn, selected_move)
    # Draw all of page four, except selected move's details
    drawPageFourSelecting(move_to_learn)
    # Set various values
    overlay = @sprites["overlay"].bitmap
    base   = Color.new(90, 82, 82)
    shadow = Color.new(165, 165, 173)
    @sprites["pokemon"].visible = false if @sprites["pokemon"]
    @sprites["pokeicon"].pokemon = @pokemon
    @sprites["pokeicon"].visible = true
    @sprites["itemicon"].visible = false if @sprites["itemicon"]
    textpos = []
    # Write power and accuracy values for selected move
    #---------------------------------------------------------------------------
    # ZUD - Display Max Move data.
    #---------------------------------------------------------------------------
    maxmove_data = (defined?(Settings::ZUD_COMPAT)) ? _ZUD_DrawMoveSel(selected_move) : [selected_move,"???"]
    flex_dmg     = maxmove_data[1]
    maxmove      = maxmove_data[0]
    case maxmove.base_damage
    when 0 then textpos.push(["---", 216, 150, 1, base, shadow])   # Status move
    when 1 then textpos.push(["#{flex_dmg}", 216, 148, 1, base, shadow])   # Variable power move
    else        textpos.push([selected_move.base_damage.to_s, 216, 148, 1, base, shadow])
    end
    if maxmove.accuracy == 0
      textpos.push(["---", 216, 182, 1, base, shadow])
    else
      textpos.push(["#{selected_move.accuracy}%", 216 + overlay.text_size("%").width, 180, 1, base, shadow])
    end
    #---------------------------------------------------------------------------
    # Draw all text
    pbDrawTextPositions(overlay, textpos)
    # Draw selected move's damage category icon
    imagepos = [["Graphics/Pictures/category", 166, 122, 0, selected_move.category * 28, 64, 28]]
    pbDrawImagePositions(overlay, imagepos)
    # Draw selected move's description
    drawTextEx(overlay, 4, 224, 230, 5, selected_move.description, base, shadow)
  end

  def drawPageFive
    overlay = @sprites["overlay"].bitmap
    @sprites["uparrow"].visible   = false
    @sprites["downarrow"].visible = false
    base   = Color.new(90,82,82)
    shadow = Color.new(165,165,173)
    textColumn=300
    evColumn=390
    ivColumn=455
    # Write various bits of text
    if @pokemon.happiness==0 
      verdict=_INTL("It simply hates your very essence.")
	elsif @pokemon.happiness==0 && @pokemon.loyalty>=149
      verdict=_INTL("It hates you passionately, but it may listen.")
	elsif @pokemon.happiness==0 && @pokemon.loyalty>=199
      verdict=_INTL("It dislikes you in unexplainable ways, but it respects you")
	elsif @pokemon.happiness==0 && @pokemon.loyalty>=249
      verdict=_INTL("It simply hates your very essence, yet you know it will listen.")
	elsif @pokemon.happiness==0 && @pokemon.loyalty>=250
      verdict=_INTL("It works with you in combat, but do not confuse that as being safe.")
    elsif @pokemon.loyalty>=0&&@pokemon.loyalty<=49 && @pokemon.happiness>=0&&@pokemon.happiness<=49
      verdict=_INTL("It doesn't seem particularly interested in you")
    elsif @pokemon.loyalty>=50&&@pokemon.loyalty<=74 && @pokemon.happiness>=0&&@pokemon.happiness<=49
      verdict=_INTL("It sometimes listens.")
    elsif @pokemon.loyalty>=75&&@pokemon.loyalty<=149 && @pokemon.happiness>=0&&@pokemon.happiness<=49
      verdict=_INTL("It will listen on occasion")
    elsif @pokemon.loyalty>=150&&@pokemon.loyalty<=199 && @pokemon.happiness>=0&&@pokemon.happiness<=49
      verdict=_INTL("It seems to be uninvested in you, but it listens when you call.")
    elsif @pokemon.loyalty>=200&&@pokemon.loyalty<=249 && @pokemon.happiness>=0&&@pokemon.happiness<=49
      verdict=_INTL("It listens to your every word in combat, but outside, ignores you.")
    elsif @pokemon.loyalty>=0&&@pokemon.loyalty<=49 && @pokemon.happiness>=50&&@pokemon.happiness<=74
      verdict=_INTL("It really likes playing when you aren't busy fighting!")
    elsif @pokemon.loyalty>=50&&@pokemon.loyalty<=74 && @pokemon.happiness>=50&&@pokemon.happiness<=74
      verdict=_INTL("It seems to be growing fonder of you.")
    elsif @pokemon.loyalty>=75&&@pokemon.loyalty<=149 && @pokemon.happiness>=50&&@pokemon.happiness<=74
      verdict=_INTL("It tries to spend more time with you, but only in combat.")
    elsif @pokemon.loyalty>=150&&@pokemon.loyalty<=199 && @pokemon.happiness>=50&&@pokemon.happiness<=74
      verdict=_INTL("It enjoys fighting together.")
    elsif @pokemon.loyalty>=200&&@pokemon.loyalty<=249 && @pokemon.happiness>=50&&@pokemon.happiness<=74
      verdict=_INTL("It will leap into combat at a dime, but is to itself outside of combat.")
    elsif @pokemon.loyalty>=0&&@pokemon.loyalty<=49 && @pokemon.happiness>=75&&@pokemon.happiness<=149
      verdict=_INTL("It likes you as a person.")
    elsif @pokemon.loyalty>=50&&@pokemon.loyalty<=74 && @pokemon.happiness>=75&&@pokemon.happiness<=149
      verdict=_INTL("It follows you around 24/7, yet checks out in combat.")
    elsif @pokemon.loyalty>=75&&@pokemon.loyalty<=149 && @pokemon.happiness>=75&&@pokemon.happiness<=149
      verdict=_INTL("It is an excellent partner both in the wild, and in combat.")
    elsif @pokemon.loyalty>=150&&@pokemon.loyalty<=199 && @pokemon.happiness>=75&&@pokemon.happiness<=149
      verdict=_INTL("It seems to enjoy your time together.")
    elsif @pokemon.loyalty>=200&&@pokemon.loyalty<=249 && @pokemon.happiness>=75&&@pokemon.happiness<=149
      verdict=_INTL("It hangs on your words, and leaps into battle without fail.")
    elsif @pokemon.loyalty>=0&&@pokemon.loyalty<=49 && @pokemon.happiness>=150&&@pokemon.happiness<=199
      verdict=_INTL("It loves to play, and run around, but not much else.")
    elsif @pokemon.loyalty>=50&&@pokemon.loyalty<=74 && @pokemon.happiness>=150&&@pokemon.happiness<=199
      verdict=_INTL("It zooms around, playing with you, yet has trouble fighting.")
    elsif @pokemon.loyalty>=75&&@pokemon.loyalty<=149 && @pokemon.happiness>=150&&@pokemon.happiness<=199
      verdict=_INTL("You are bonding around both life and combat.")
    elsif @pokemon.loyalty>=150&&@pokemon.loyalty<=199 && @pokemon.happiness>=150&&@pokemon.happiness<=199
      verdict=_INTL("It looks really happy! It will listen to what you say!")
    elsif @pokemon.loyalty>=200&&@pokemon.loyalty<=249 && @pokemon.happiness>=150&&@pokemon.happiness<=199
      verdict=_INTL("You almost have perfect synergy.")
    elsif @pokemon.loyalty>=0&&@pokemon.loyalty<=49 && @pokemon.happiness>=200&&@pokemon.happiness<=249
      verdict=_INTL("It loves you to death, but ignores fighting.")
    elsif @pokemon.loyalty>=50&&@pokemon.loyalty<=74 && @pokemon.happiness>=200&&@pokemon.happiness<=249
      verdict=_INTL("It enjoys spending time with you, and is gaining confidence in combat.")
    elsif @pokemon.loyalty>=75&&@pokemon.loyalty<=149 && @pokemon.happiness>=200&&@pokemon.happiness<=249
      verdict=_INTL("It loves you, and is trying to improve for you!")
    elsif @pokemon.loyalty>=150&&@pokemon.loyalty<=199 && @pokemon.happiness>=200&&@pokemon.happiness<=249
      verdict=_INTL("It spends all its time with you!")
    elsif @pokemon.loyalty>=200&&@pokemon.loyalty<=249 && @pokemon.happiness>=200&&@pokemon.happiness<=249
      verdict=_INTL("Your synergy is increasing!")
    elsif @pokemon.loyalty>=0&&@pokemon.loyalty<=49 && @pokemon.happiness>=250
      verdict=_INTL("It's basically your pet, not really ready for combat.")
    elsif @pokemon.loyalty>=50&&@pokemon.loyalty<=74 && @pokemon.happiness>=250
      verdict=_INTL("It struggles with anything beyond bellyrubs.")
    elsif @pokemon.loyalty>=75&&@pokemon.loyalty<=149 && @pokemon.happiness>=250
      verdict=_INTL("It wants to help in combat, but gets distracted sometimes.")
    elsif @pokemon.loyalty>=150&&@pokemon.loyalty<=199 && @pokemon.happiness>=250
      verdict=_INTL("It's already a good friend, now its becoming a good partner.")
    elsif @pokemon.loyalty>=200&&@pokemon.loyalty<=249 && @pokemon.happiness>=250
      verdict=_INTL("You feel like your auras match sometimes.")
    elsif @pokemon.loyalty>=250 && @pokemon.happiness>=0&&@pokemon.happiness<=49
      verdict=_INTL("It follows your commands promptly.")
    elsif @pokemon.loyalty>=250 && @pokemon.happiness>=50&&@pokemon.happiness<=74
      verdict=_INTL("It seems to want a little more than combat.")
    elsif @pokemon.loyalty>=250 && @pokemon.happiness>=75&&@pokemon.happiness<=149
      verdict=_INTL("It seems to enjoy being around you.")
    elsif @pokemon.loyalty>=250 && @pokemon.happiness>=150&&@pokemon.happiness<=199
      verdict=_INTL("It wants to be together all the time.")
    elsif @pokemon.loyalty>=250 && @pokemon.happiness>=200&&@pokemon.happiness<=249
      verdict=_INTL("It thinks about you a lot!")
    elsif @pokemon.loyalty>=250 && @pokemon.happiness>=250
      verdict=_INTL("You two are in sync!!!!!")
    end
    textpos = [
#       [@pokemon.name,46,62,0,base,shadow],
#       [@pokemon.level.to_s,46,92,0,Color.new(64,64,64),Color.new(176,176,176)],
#       [_INTL("Item"),66,318,0,base,shadow],
       [_INTL("Happiness:"),10,62,0,base,shadow],
       [_INTL("{1}/255",@pokemon.happiness{1}),126,62,0,base,shadow],
       [_INTL("Loyalty"),10,92,0,base,shadow],
       [_INTL("{1}/255",@pokemon.loyalty{1}),126,92,0,base,shadow],
       [_INTL("Food:"),10,222,0,base,shadow],
       [_INTL("{1}/100",@pokemon.food{1}),126,222,0,base,shadow],
       [_INTL("Water"),10,242,0,base,shadow],
       [_INTL("{1}/100",@pokemon.water{1}),126,242,0,base,shadow],
       [_INTL("Age"),10,262,0,base,shadow],
       [_INTL("{1}",@pokemon.sleep{1}),126,262,0,base,shadow],
    ]
    # Draw all text
    pbDrawTextPositions(overlay,textpos)
    # Show all ribbons  
	drawTextEx(overlay,10,130,282,3,verdict,Color.new(64,64,64),Color.new(176,176,176))
    imagepos = []
    coord = 0
    pbDrawImagePositions(overlay,imagepos)
	
  end
  
  def drawSelectedRibbon(ribbonid)
    # Draw all of page five
    drawPage(5)
    # Set various values
    overlay = @sprites["overlay"].bitmap
    # Changes the color of the text, to the one used in BW
    base   = Color.new(90,82,82)
    shadow = Color.new(165,165,173)
    nameBase   = Color.new(248,248,248)
    nameShadow = Color.new(104,104,104)
    # Get data for selected ribbon
    name = ribbonid ? GameData::Ribbon.get(ribbonid).name : ""
    desc = ribbonid ? GameData::Ribbon.get(ribbonid).description : ""
    # Draw the description box
    if SUMMARY_B2W2_STYLE
      imagepos = [["Graphics/Pictures/Summary/overlay_ribbon_B2W2",0,280]]
    else
      imagepos = [["Graphics/Pictures/Summary/overlay_ribbon",0,280]]
    end
    pbDrawImagePositions(overlay,imagepos)
    # Draw name of selected ribbon
    textpos = [
       [name,30,280,0,nameBase,nameShadow]
    ]
    pbDrawTextPositions(overlay,textpos)
    # Draw selected ribbon's description
    drawTextEx(overlay,30,322,480,0,desc,base,shadow)
  end

  def pbMarking(pokemon)
    @sprites["markingbg"].visible      = true
    @sprites["markingoverlay"].visible = true
    @sprites["markingsel"].visible     = true
    # Changed the color of the text, to the one used in BW
    base   = Color.new(248,248,248)
    shadow = Color.new(104,104,104)
    ret = pokemon.markings
    markings = pokemon.markings
    index = 0
    redraw = true
    markrect = Rect.new(0,0,16,16)
    loop do
      # Redraw the markings and text
      if redraw
        @sprites["markingoverlay"].bitmap.clear
        for i in 0...6
          markrect.x = i*16
          markrect.y = (markings&(1<<i)!=0) ? 16 : 0
          @sprites["markingoverlay"].bitmap.blt(300+58*(i%3),154+50*(i/3),@markingbitmap.bitmap,markrect)
        end
        textpos = [
           [_INTL("Mark {1}",pokemon.name),366,90,2,base,shadow],
           [_INTL("OK"),366,242,2,base,shadow],
           [_INTL("Cancel"),366,290,2,base,shadow]
        ]
        pbDrawTextPositions(@sprites["markingoverlay"].bitmap,textpos)
        redraw = false
      end
      # Reposition marking the cursor
      @sprites["markingsel"].x = 284+58*(index%3)
      @sprites["markingsel"].y = 144+50*(index/3)
      if index==6   # OK
        @sprites["markingsel"].x = 284
        @sprites["markingsel"].y = 244
        @sprites["markingsel"].src_rect.y = @sprites["markingsel"].bitmap.height/2
      elsif index==7   # Cancel
        @sprites["markingsel"].x = 284
        @sprites["markingsel"].y = 294
        @sprites["markingsel"].src_rect.y = @sprites["markingsel"].bitmap.height/2
      else
        @sprites["markingsel"].src_rect.y = 0
      end
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      elsif Input.trigger?(Input::USE)
        pbPlayDecisionSE
        if index==6   # OK
          ret = markings
          break
        elsif index==7   # Cancel
          break
        else
          mask = (1<<index)
          if (markings&mask)==0
            markings |= mask
          else
            markings &= ~mask
          end
          redraw = true
        end
      elsif Input.trigger?(Input::UP)
        if index==7;    index = 6
        elsif index==6; index = 4
        elsif index<3;  index = 7
        else;           index -= 3
        end
        pbPlayCursorSE
      elsif Input.trigger?(Input::DOWN)
        if index==7;    index = 1
        elsif index==6; index = 7
        elsif index>=3; index = 6
        else;           index += 3
        end
        pbPlayCursorSE
      elsif Input.trigger?(Input::LEFT)
        if index<6
          index -= 1
          index += 3 if index%3==2
          pbPlayCursorSE
        end
      elsif Input.trigger?(Input::RIGHT)
        if index<6
          index += 1
          index -= 3 if index%3==0
          pbPlayCursorSE
        end
      end
    end
    @sprites["markingbg"].visible      = false
    @sprites["markingoverlay"].visible = false
    @sprites["markingsel"].visible     = false
    if pokemon.markings!=ret
      pokemon.markings = ret
      return true
    end
    return false
  end
end

#===============================================================================
# * Family Tree - by FL (Credits will be apreciated)
#===============================================================================
#
# This script is for Pok??mon Essentials. It displays a sixth page at pok??mon
# summary showing a little info about the pok??mon mother, father, grandmothers
# and grandfathers if the pok??mon has any.
#
#===============================================================================
#
# To this script works, put it above PSystem_System. Put a 512x384 background
# for this screen in "Graphics/Pictures/Summary/" as "bg_6" and as "bg_6_egg".
# This last one is only necessary if SHOWFAMILYEGG is true. You also need to
# update the below pictures on same folder in order to reflect the summary
# icon change:
# - bg_1
# - bg_2
# - bg_3
# - bg_4
# - bg_movedetail
# - bg_5
#
# -At PField_DayCare, before line '$Trainer.party[$Trainer.party.length]=egg'
# add line 'egg.family = PokemonFamily.new(egg, father, mother)'
#
# -At PScreen_Summary, change both lines '@page = 5 if @page>5'
# to '@page=6 if @page>6'
#
# -Before line 'if Input.trigger?(Input::A)' add line 'handleInputsEgg'
#
# -After line 'when 5; drawPageFive' add 'when 6; drawPageSix'
#
# -Change line '_INTL("RIBBONS")][page-1]' into:
#
# _INTL("RIBBONS"),
# _INTL("FAMILY TREE")][page-1]
#
# -Change both lines 
# 'if @party[newindex] && (@page==1 || !@party[newindex].egg?)' into:
#
# if @party[newindex] && 
#   (@page==1 || !@party[newindex].egg? || (@page==6 && SHOWFAMILYEGG))
#
# -Change both
# 
#  pbSEStop; pbPlayCry(@pokemon)
#  @ribbonOffset = 0
#  dorefresh = true
#
# into:
#
#  pbSEStop; pbPlayCry(@pokemon)
#  @ribbonOffset = 0
#  if SHOWFAMILYEGG && @pokemon.isEgg? && @page==6
#    dorefresh = false
#    drawPageSix
#  else
#    dorefresh = true
#  end
#
#===============================================================================

class PokemonSummary_Scene
  SHOWFAMILYEGG = true # when true, family tree is also showed in egg screen.

  def drawPageSix
    overlay=@sprites["overlay"].bitmap
    base=Color.new(248,248,248)
    shadow=Color.new(104,104,104)
    textpos=[]
    if @pokemon.isEgg?
      overlay.clear
      pbSetSystemFont(overlay)
      @sprites["background"].setBitmap("Graphics/Pictures/Summary/bg_6_egg")
      imagepos = []
      ballimage = sprintf(
        "Graphics/Pictures/Summary/icon_ball_%02d",@pokemon.ballused)
      imagepos.push([ballimage,14,60,0,0,-1,-1])
      pbDrawImagePositions(overlay,imagepos)
      textpos=[
         [_INTL("TRAINER MEMO"),26,16,0,base,shadow],
         [@pokemon.name,46,62,0,base,shadow],
         [_INTL("Item"),62,318,0,base,shadow]
      ]
      if @pokemon.hasItem?
        textpos.push([@pokemon.item.name,16,352,0,
          Color.new(64,64,64), Color.new(176,176,176)])
      else
        textpos.push([_INTL("None"),16,352,0,
          Color.new(184,184,160),Color.new(208,208,200)])
      end
      drawMarkings(overlay,82,292)
    end  
    # Draw parents
    parentsY=[78,234]
    for i in 0...2
      parent = @pokemon.family && @pokemon.family[i] ? @pokemon.family[i] : nil
      iconParentParam = parent ? [parent.species,
          parent.gender==1,false,parent.form,false] : [0,0,false,0,false]
      iconParent=AnimatedBitmap.new(GameData::Species.icon_filename(iconParentParam))
      overlay.blt(234,parentsY[i],iconParent.bitmap,Rect.new(0,0,64,64))
      textpos.push([parent ? parent.name : _INTL("???"),
          320,parentsY[i],0,base,shadow])
      parentSpecieName=parent ? GameData::Species.get(parent.species).species : _INTL("???")
      if (parentSpecieName.split('').last=="???" ||
          parentSpecieName.split('').last=="???")
        parentSpecieName=parentSpecieName[0..-2]
      end
      textpos.push([parentSpecieName,320,32+parentsY[i],0,base,shadow])
      if parent
        if parent.gender==0
          textpos.push([_INTL("???"),500,32+parentsY[i],1,
              Color.new(24,112,216),Color.new(136,168,208)])
        elsif parent.gender==1
          textpos.push([_INTL("???"),500,32+parentsY[i],1,
              Color.new(248,56,32),Color.new(224,152,144)])
        end
      end
      grandX = [380,448]
      for j in 0...2
        iconGrandParam = parent && parent[j] ? [parent[j].species,
            parent[j].gender==1,false,parent[j].form,false] :
            [0,0,false,0,false]
        iconGrand=AnimatedBitmap.new(GameData::Species.icon_filename(iconGrandParam))
        overlay.blt(
            grandX[j],68+parentsY[i],iconGrand.bitmap,Rect.new(0,0,64,64))
      end
    end
    pbDrawTextPositions(overlay,textpos)
  end

  def handleInputsEgg
    if SHOWFAMILYEGG && @pokemon.isEgg?
      Kernel.echoln("@page="+@page.to_s)
      if Input.trigger?(Input::LEFT) && @page==6
        @page=1
        pbPlayCursorSE()
        dorefresh=true
      end
      if Input.trigger?(Input::RIGHT) && @page==1
        @page=6
        pbPlayCursorSE()
        dorefresh=true
      end
    end
    if dorefresh
      case @page
        when 1; drawPageOneEgg
        when 6; drawPageSix
      end
    end
  end
end

class PokemonFamily
  MAXGENERATIONS = 3 # Tree stored generation limit

  attr_reader :mother # PokemonFamily object
  attr_reader :father # PokemonFamily object

  attr_reader :species
  attr_reader :gender
  attr_reader :form
  attr_reader :name # nickname
  # You can add more data here and on initialize class. Just
  # don't store the entire pok??mon object.

  def initialize(pokemon, father=nil,mother=nil)
    initializedAsParent = !father || !mother
    if pokemon.family && pokemon.family.father
      @father = pokemon.family.father
    elsif father
      @father = PokemonFamily.new(father)
    end
    if pokemon.family && pokemon.family.mother
      @mother = pokemon.family.mother
    elsif mother
      @mother = PokemonFamily.new(mother)
    end

    # This data is only initialized as a parent in a cub.
    if initializedAsParent
      @species=pokemon.species
      @gender=pokemon.gender
      @name=pokemon.name
      @form=pokemon.form
    end

    applyGenerationLimit(MAXGENERATIONS)
  end

  def applyGenerationLimit(generation)
    if generation>1
      father.applyGenerationLimit(generation-1) if @father
      mother.applyGenerationLimit(generation-1) if @mother
    else
      father=nil
      mother=nil
    end
  end

  def [](value) # [0] = father, [1] = mother
    if value==0
    return @father
    elsif value==1
    return @mother
    end
    return nil
  end
end 

class Pokemon
  attr_accessor :family
end