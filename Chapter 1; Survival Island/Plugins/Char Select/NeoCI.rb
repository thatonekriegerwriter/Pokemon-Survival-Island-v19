#Call NeoCI.ChoosePlayerCharacter
#Return the item internal number or 0 if canceled
module NeoCI
 def self.ChoosePlayerCharacter()
  pbToneChangeAll(Tone.new(-255,-255,-255),8)
  pbWait(16)
  itemscene=CharacterSelect_Scene.new
  itemscene.pbStartScene($PokemonCharacterSelect)
  charskin=itemscene.pbChooseCharacter
  itemscene.pbEndScene
  if charskin == -1
    #Nothing.
  else
    pbChangePlayer(charskin)
  end
  $game_variables[27]=charskin
  pbToneChangeAll(Tone.new(-255,-255,-255),0)
  pbToneChangeAll(Tone.new(0,0,0),6)
  #return charskin
 end
end

class CharacterSelect_Scene
#################################
## Configuration
  CHARACTERNAMEBASECOLOR=Color.new(88,88,80)
  CHARACTERNAMESHADOWCOLOR=Color.new(168,184,184)
#################################

  def update
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene(selection)
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    lastplayerCharacter=0
    animSpeed = 6
    @sprites={}
    @sprites["background"]=IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap(sprintf("Graphics/Pictures/charselect#{lastplayerCharacter}"))
    @sprites["character"]=IconSprite.new(194,48,@viewport)
    @sprites["character"].setBitmap(sprintf("Graphics/Pictures/charskin#{lastplayerCharacter-1}"))
    
#---TOP ROW---------------
    @sprites["minichar_0"]=AnimatedSprite.new("Graphics/Characters/3M",4,32,40,animSpeed,@viewport)
    @sprites["minichar_0"].x=168
    @sprites["minichar_0"].y=230
    
    @sprites["minichar_1"]=AnimatedSprite.new("Graphics/Characters/4F",4,32,40,animSpeed,@viewport)
    @sprites["minichar_1"].x=216
    @sprites["minichar_1"].y=230
    
    @sprites["minichar_2"]=AnimatedSprite.new("Graphics/Characters/2M",4,32,40,animSpeed,@viewport)
    @sprites["minichar_2"].x=264
    @sprites["minichar_2"].y=230
    
    @sprites["minichar_3"]=AnimatedSprite.new("Graphics/Characters/1F",4,32,40,animSpeed,@viewport)
    @sprites["minichar_3"].x=312
    @sprites["minichar_3"].y=230
    
#---BOTTOM ROW------------
    @sprites["minichar_4"]=AnimatedSprite.new("Graphics/Characters/4M",4,32,40,animSpeed,@viewport)
    @sprites["minichar_4"].x=168
    @sprites["minichar_4"].y=286
    
    @sprites["minichar_5"]=AnimatedSprite.new("Graphics/Characters/3F",4,32,40,animSpeed,@viewport)
    @sprites["minichar_5"].x=216
    @sprites["minichar_5"].y=286
    
    @sprites["minichar_6"]=AnimatedSprite.new("Graphics/Characters/1M",4,32,40,animSpeed,@viewport)
    @sprites["minichar_6"].x=264
    @sprites["minichar_6"].y=286
    
    @sprites["minichar_7"]=AnimatedSprite.new("Graphics/Characters/2F",4,32,40,animSpeed,@viewport)
    @sprites["minichar_7"].x=312
    @sprites["minichar_7"].y=286
    
    pbDeactivateWindows(@sprites)
    pbRefresh
    pbFadeInAndShow(@sprites)
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  def pbRefresh
    #@sprites["background"].setBitmap(sprintf("Graphics/Pictures/charselect#{playerCharacter}"))
  end
  
# Script that manages button inputs
  def pbChooseCharacter
    playerCharacter = 0
    prevCharacter = -1
    #pbRefresh
    @sprites["character"].setBitmap(sprintf("Graphics/Characters/trainer00#{playerCharacter}"))
    loop do
         Graphics.update
         Input.update
         self.update
         
         if prevCharacter>=0
        end
         if Input.trigger?(Input::LEFT)
           prevCharacter = playerCharacter
           if playerCharacter == 0
             playerCharacter = 7
           else
             playerCharacter -= 1
           end
          #pbRefresh
          @sprites["background"].setBitmap(sprintf("Graphics/Pictures/charselect#{playerCharacter}"))
          @sprites["character"].setBitmap(sprintf("Graphics/Characters/trainer00#{playerCharacter}"))
          @sprites["minichar_#{playerCharacter}"].play
        elsif Input.trigger?(Input::RIGHT)
             prevCharacter = playerCharacter
            if playerCharacter == 7
               playerCharacter = 0
             else
               playerCharacter += 1
             end
           #pbRefresh
           @sprites["background"].setBitmap(sprintf("Graphics/Pictures/charselect#{playerCharacter}"))
           @sprites["character"].setBitmap(sprintf("Graphics/Characters/trainer00#{playerCharacter}"))
           @sprites["minichar_#{playerCharacter}"].play
           end
        
         if Input.trigger?(Input::UP)
           prevCharacter = playerCharacter
           if playerCharacter <= 3
             playerCharacter += 4
           else
             playerCharacter -= 4
           end
          #pbRefresh
          @sprites["background"].setBitmap(sprintf("Graphics/Pictures/charselect#{playerCharacter}"))
          @sprites["character"].setBitmap(sprintf("Graphics/Characters/trainer00#{playerCharacter}"))
          @sprites["minichar_#{playerCharacter}"].play
        elsif Input.trigger?(Input::DOWN)
          prevCharacter = playerCharacter
             if playerCharacter > 3
               playerCharacter -= 4
             else
               playerCharacter += 4
             end
           #pbRefresh
           @sprites["background"].setBitmap(sprintf("Graphics/Pictures/charselect#{playerCharacter}"))
           @sprites["character"].setBitmap(sprintf("Graphics/Characters/trainer00#{playerCharacter}"))
           @sprites["minichar_#{playerCharacter}"].play
        end
         
         #Cancel
           if Input.trigger?(Input::X)
             return -1
           end
           
         # Confirm selection
         if Input.trigger?(Input::C)
           if playerCharacter<8
               #pbRefresh
               @sprites["background"].setBitmap(sprintf("Graphics/Pictures/charselect#{playerCharacter}"))
               return playerCharacter
           else
             return -1
           end
         end
       
         end
     end
end



class PokemonCharacterSelect
  attr_accessor :lastplayerCharacter
  attr_reader :playerCharacters

  def self.playerCharacterNames()
    #ret=POCKETNAMES
##### Unquote/edit this code to translate the playerCharacter names into another language.
   ret=["",
      "1","2","3","4",
      "5","6","7","8",
	  "9","10","11","12",
      "13","14","15","16"
   ]
    return ret
  end

  def self.numChars()
    return self.playerCharacterNames().length-1
  end

  def initialize
    @lastplayerCharacter=1
    @playerCharacters=[]
    @choices=[]
    # Initialize each playerCharacter of the array
    for i in 0..PokemonCharacterSelect.numChars
      @playerCharacters[i]=[]
      @choices[i]=0
    end
  end

  def playerCharacters
    rearrange()
    return @playerCharacters
  end

  def rearrange()
    if @playerCharacters.length==6 && PokemonCharacterSelect.numChars==16
      newplayerCharacters=[]
      for i in 0..16
        newplayerCharacters[i]=[]
        @choices[i]=0 if !@choices[i]
      end
      @playerCharacters=newplayerCharacters
    end
  end
end

#module playerTrainerClasses
#  Intern       = 0
#  Runner       = 1
#  Warrior      = 2
#  Assassin     = 3
#  Monk         = 4
#  Alchemist    = 5
#  Guardian     = 6
#  Hunter       = 7
#  Mechanist    = 8
#  Healer       = 9
#  Professor    = 10
#  Criminal     = 11
#  TimeLord     = 12
#  Names=[
#    "Intern",
#    "Runner",
#    "Warrior",
#    "Assassin",
#    "Monk",
#    "Alchemist",
#    "Guardian",
#    "Hunter",
#    "Mechanist",
#    "Healer",
#    "Professor",
#    "Criminal",
#    "Time Lord"
#  ]
#end