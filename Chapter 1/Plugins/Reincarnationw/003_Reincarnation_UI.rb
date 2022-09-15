###---craftS
class Reincarnation_UI
#################################
## Configuration
  craftNAMEBASECOLOR=Color.new(88,88,80)
  craftNAMESHADOWCOLOR=Color.new(168,184,184)
#################################
  
  def update
    pbUpdateSpriteHash(@sprites)
  end

  def pbPrepareWindow(window)
    window.visible=true
    window.letterbyletter=false
  end
  
  def pbStartScene
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @selection=0
    @reincarnpkmn=0
    @donApkmn=0
    @donBpkmn=0
    @pkmnnat1=0
    @pkmnnat2=0
    @pkmniv=0
    @reincarnpkmnsp=0
    @donApkmnsp=0
    @donBpkmnsp=0
    @pkmnnat1sp=0
    @pkmnnat2sp=0
    @pkmnivsp=0
    @pkmn1=false
    @pkmn2=false
    @pkmn3=false
    @sprites={}
    @icons={}
    @required=[]
    @sprites["background"]=IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap(ReincarnationConfig::CUSTOM_BG)
    @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    coord=0
    @imagepos=[]
    @selectX=100
    @selectY=168
    pbDeactivateWindows(@sprites)
    pbRefresh
    pbFadeInAndShow(@sprites)
	
	
	if ReincarnationConfig::CUSTOM_BG == "Graphics/Plugins/Reincarnation/ReincarnationBG"
    filenamSigil="Graphics/Plugins/Reincarnation/ReincarnationSigil"
    @sprites["pokeview"]=IconSprite.new(-30,25,@viewport)
    @sprites["pokeview"].setBitmap(filenamSigil)
    @sprites["pokeview"].visible = true
	end
	
    filenamBack="Graphics/Plugins/Reincarnation/ReincarnationBack"
    @sprites["back"]=IconSprite.new(0,0,@viewport)
    @sprites["back"].setBitmap(filenamBack)
    @sprites["back"].visible = true

	
    filenamA="Graphics/Plugins/Reincarnation/begin"
    #@sprites["begin"]=IconSprite.new(356,340,@viewport)
    @sprites["begin"]=IconSprite.new(356,350,@viewport)
    @sprites["begin"].setBitmap(filenamA)
    @sprites["begin"].visible = true
    
    filenamB="Graphics/Plugins/Reincarnation/ivs"
    @sprites["ivs"]=IconSprite.new(366,285,@viewport)
    @sprites["ivs"].setBitmap(filenamB)
    @sprites["ivs"].visible = true
    
    filenamC="Graphics/Plugins/Reincarnation/nature"
    @sprites["nature1"]=IconSprite.new(366,185,@viewport)
    @sprites["nature1"].setBitmap(filenamC)
    @sprites["nature1"].visible = true
    @sprites["nature2"]=IconSprite.new(366,235,@viewport)
    @sprites["nature2"].setBitmap(filenamC)
    @sprites["nature2"].visible = true
    
    filenamD="Graphics/Plugins/Reincarnation/reincarnator"
    @sprites["reincarnator"]=IconSprite.new(366,35,@viewport)
    @sprites["reincarnator"].setBitmap(filenamD)
    @sprites["reincarnator"].visible = true
    
    filenamE="Graphics/Plugins/Reincarnation/donator"
    @sprites["donatorA"]=IconSprite.new(366,85,@viewport)
    @sprites["donatorA"].setBitmap(filenamE)
    @sprites["donatorA"].visible = true
    @sprites["donatorB"]=IconSprite.new(366,135,@viewport)
    @sprites["donatorB"].setBitmap(filenamE)
    @sprites["donatorB"].visible = true
	

    filenamB="Graphics/Plugins/Reincarnation/ivsexpand"
    @sprites["ivse"]=IconSprite.new(266,285,@viewport)
    @sprites["ivse"].setBitmap(filenamB)
    @sprites["ivse"].visible = false
    
    filenamC="Graphics/Plugins/Reincarnation/natureexpand"
    @sprites["nature1e"]=IconSprite.new(266,185,@viewport)
    @sprites["nature1e"].setBitmap(filenamC)
    @sprites["nature1e"].visible = false
    @sprites["nature2e"]=IconSprite.new(266,235,@viewport)
    @sprites["nature2e"].setBitmap(filenamC)
    @sprites["nature2e"].visible = false
    
    filenamD="Graphics/Plugins/Reincarnation/reincarnatorexpand"
    @sprites["reincarnatore"]=IconSprite.new(266,35,@viewport)
    @sprites["reincarnatore"].setBitmap(filenamD)
    @sprites["reincarnatore"].visible = true
    
    filenamE="Graphics/Plugins/Reincarnation/donatorexpand"
    @sprites["donatorAe"]=IconSprite.new(266,85,@viewport)
    @sprites["donatorAe"].setBitmap(filenamE)
    @sprites["donatorAe"].visible = false
    @sprites["donatorBe"]=IconSprite.new(266,135,@viewport)
    @sprites["donatorBe"].setBitmap(filenamE)
    @sprites["donatorBe"].visible = false
	
	if @pkmnnat1!=0
	filenamF =GameData::Item.icon_filename(@pkmnnat1) 
	else
	filenamF ="Graphics/Items/000"
	end
    @icons["itemResult1"]=IconSprite.new(275,185,@viewport)
    @icons["itemResult1"].setBitmap(filenamF)
    @icons["itemResult1"].visible=false
      
	if @pkmnnat2!=0
	filenamG =GameData::Item.icon_filename(@pkmnnat2) 
	else
	filenamG ="Graphics/Items/000"
	end
    @icons["itemResult2"]=IconSprite.new(275,235,@viewport)
    @icons["itemResult2"].setBitmap(filenamG)
	
    if @pkmniv!=0
    filenamH =GameData::Item.icon_filename(@pkmniv)
	else
	filenamH ="Graphics/Items/000"
	end
    @icons["itemResult3"]=IconSprite.new(275,285,@viewport)
    @icons["itemResult3"].setBitmap(filenamH)
    @icons["itemResult2"].visible=false
    @icons["itemResult3"].visible=false
      

	
    @sprites["A"]=Window_UnformattedTextPokemon.new("")
    @sprites["B"]=Window_UnformattedTextPokemon.new("")
    @sprites["C"]=Window_UnformattedTextPokemon.new("")
    @sprites["D"]=Window_UnformattedTextPokemon.new("")
    @sprites["E"]=Window_UnformattedTextPokemon.new("")
    @sprites["F"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@sprites["A"])
    @sprites["A"].x=315
    @sprites["A"].y=35
    @sprites["A"].width=Graphics.width-48
    @sprites["A"].height=Graphics.height
    @sprites["A"].baseColor=Color.new(240,240,240)
    @sprites["A"].shadowColor=Color.new(40,40,40)
    @sprites["A"].visible=true
    @sprites["A"].viewport=@viewport
    @sprites["A"].windowskin=nil
    pbPrepareWindow(@sprites["B"])
    @sprites["B"].x=422
    @sprites["B"].y=85
    @sprites["B"].width=Graphics.width-48
    @sprites["B"].height=Graphics.height
    @sprites["B"].baseColor=Color.new(240,240,240)
    @sprites["B"].shadowColor=Color.new(40,40,40)
    @sprites["B"].visible=true
    @sprites["B"].viewport=@viewport
    @sprites["B"].windowskin=nil
    pbPrepareWindow(@sprites["C"])
    @sprites["C"].x=422
    @sprites["C"].y=135
    @sprites["C"].width=Graphics.width-48
    @sprites["C"].height=Graphics.height
    @sprites["C"].baseColor=Color.new(240,240,240)
    @sprites["C"].shadowColor=Color.new(40,40,40)
    @sprites["C"].visible=true
    @sprites["C"].viewport=@viewport
    @sprites["C"].windowskin=nil
    pbPrepareWindow(@sprites["D"])
    @sprites["D"].x=422
    @sprites["D"].y=185
    @sprites["D"].width=Graphics.width-48
    @sprites["D"].height=Graphics.height
    @sprites["D"].baseColor=Color.new(240,240,240)
    @sprites["D"].shadowColor=Color.new(40,40,40)
    @sprites["D"].visible=true
    @sprites["D"].viewport=@viewport
    @sprites["D"].windowskin=nil
    pbPrepareWindow(@sprites["E"])
    @sprites["E"].x=422
    @sprites["E"].y=235
    @sprites["E"].width=Graphics.width-48
    @sprites["E"].height=Graphics.height
    @sprites["E"].baseColor=Color.new(240,240,240)
    @sprites["E"].shadowColor=Color.new(40,40,40)
    @sprites["E"].visible=true
    @sprites["E"].viewport=@viewport
    @sprites["E"].windowskin=nil
    pbPrepareWindow(@sprites["F"])
    @sprites["F"].x=422
    @sprites["F"].y=285
    @sprites["F"].width=Graphics.width-48
    @sprites["F"].height=Graphics.height
    @sprites["F"].baseColor=Color.new(240,240,240)
    @sprites["F"].shadowColor=Color.new(40,40,40)
    @sprites["F"].visible=true
    @sprites["F"].viewport=@viewport
    @sprites["F"].windowskin=nil
	
#Viewport Stuff
	
	
	filenamPokeStat="Graphics/Plugins/Reincarnation/pokeview"
    @sprites["pokeview"]=IconSprite.new(0,120,@viewport)
    @sprites["pokeview"].setBitmap(filenamPokeStat)
    @sprites["pokeview"].visible = false
	
	
	
    @sprites["HPOld"]=Window_UnformattedTextPokemon.new("")
    @sprites["ATKOld"]=Window_UnformattedTextPokemon.new("")
    @sprites["DEFOld"]=Window_UnformattedTextPokemon.new("")
    @sprites["SATKOld"]=Window_UnformattedTextPokemon.new("")
    @sprites["SDEFOld"]=Window_UnformattedTextPokemon.new("")
    @sprites["SPDOld"]=Window_UnformattedTextPokemon.new("")
    @sprites["HPNew"]=Window_UnformattedTextPokemon.new("")
    @sprites["ATKNew"]=Window_UnformattedTextPokemon.new("")
    @sprites["DEFNew"]=Window_UnformattedTextPokemon.new("")
    @sprites["SATKNew"]=Window_UnformattedTextPokemon.new("")
    @sprites["SDEFNew"]=Window_UnformattedTextPokemon.new("")
    @sprites["SPDNew"]=Window_UnformattedTextPokemon.new("")
    @sprites["PkmnName"]=Window_UnformattedTextPokemon.new("")
    @sprites["PkmnLevel"]=Window_UnformattedTextPokemon.new("")
    @sprites["PkmnLevel50"]=Window_UnformattedTextPokemon.new("")
    @sprites["PkmnAbility"]=Window_UnformattedTextPokemon.new("")
    @sprites["HPOldN"]=Window_UnformattedTextPokemon.new("")
    @sprites["ATKOldN"]=Window_UnformattedTextPokemon.new("")
    @sprites["DEFOldN"]=Window_UnformattedTextPokemon.new("")
    @sprites["SATKOldN"]=Window_UnformattedTextPokemon.new("")
    @sprites["SDEFOldN"]=Window_UnformattedTextPokemon.new("")
    @sprites["SPDOldN"]=Window_UnformattedTextPokemon.new("")
    @sprites["HPNewN"]=Window_UnformattedTextPokemon.new("")
    @sprites["ATKNewN"]=Window_UnformattedTextPokemon.new("")
    @sprites["DEFNewN"]=Window_UnformattedTextPokemon.new("")
    @sprites["SATKNewN"]=Window_UnformattedTextPokemon.new("")
    @sprites["SDEFNewN"]=Window_UnformattedTextPokemon.new("")
    @sprites["SPDNewN"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@sprites["HPOld"])
    @sprites["HPOld"].x=315
    @sprites["HPOld"].y=35
    @sprites["HPOld"].width=Graphics.width-48
    @sprites["HPOld"].height=Graphics.height
    @sprites["HPOld"].baseColor=Color.new(240,240,240)
    @sprites["HPOld"].shadowColor=Color.new(40,40,40)
    @sprites["HPOld"].text=_INTL("HP") 
    @sprites["HPOld"].visible=false
    @sprites["HPOld"].viewport=@viewport
    @sprites["HPOld"].windowskin=nil
    pbPrepareWindow(@sprites["ATKOld"])
    @sprites["ATKOld"].x=422
    @sprites["ATKOld"].y=85
    @sprites["ATKOld"].width=Graphics.width-48
    @sprites["ATKOld"].height=Graphics.height
    @sprites["ATKOld"].baseColor=Color.new(240,240,240)
    @sprites["ATKOld"].shadowColor=Color.new(40,40,40)
    @sprites["HPOld"].text=_INTL("ATK") 
    @sprites["ATKOld"].visible=false
    @sprites["ATKOld"].viewport=@viewport
    @sprites["ATKOld"].windowskin=nil
    pbPrepareWindow(@sprites["DEFOld"])
    @sprites["DEFOld"].x=422
    @sprites["DEFOld"].y=135
    @sprites["DEFOld"].width=Graphics.width-48
    @sprites["DEFOld"].height=Graphics.height
    @sprites["DEFOld"].baseColor=Color.new(240,240,240)
    @sprites["DEFOld"].shadowColor=Color.new(40,40,40)
    @sprites["HPOld"].text=_INTL("DEF") 
    @sprites["DEFOld"].visible=false
    @sprites["DEFOld"].viewport=@viewport
    @sprites["DEFOld"].windowskin=nil
    pbPrepareWindow(@sprites["SATKOld"])
    @sprites["SATKOld"].x=422
    @sprites["SATKOld"].y=185
    @sprites["SATKOld"].width=Graphics.width-48
    @sprites["SATKOld"].height=Graphics.height
    @sprites["SATKOld"].baseColor=Color.new(240,240,240)
    @sprites["SATKOld"].shadowColor=Color.new(40,40,40)
    @sprites["HPOld"].text=_INTL("S. ATK") 
    @sprites["SATKOld"].visible=false
    @sprites["SATKOld"].viewport=@viewport
    @sprites["SATKOld"].windowskin=nil
    pbPrepareWindow(@sprites["SDEFOld"])
    @sprites["SDEFOld"].x=422
    @sprites["SDEFOld"].y=235
    @sprites["SDEFOld"].width=Graphics.width-48
    @sprites["SDEFOld"].height=Graphics.height
    @sprites["SDEFOld"].baseColor=Color.new(240,240,240)
    @sprites["SDEFOld"].shadowColor=Color.new(40,40,40)
    @sprites["HPOld"].text=_INTL("S. DEF") 
    @sprites["SDEFOld"].visible=false
    @sprites["SDEFOld"].viewport=@viewport
    @sprites["SDEFOld"].windowskin=nil
    pbPrepareWindow(@sprites["SPDOld"])
    @sprites["SPDOld"].x=315
    @sprites["SPDOld"].y=35
    @sprites["SPDOld"].width=Graphics.width-48
    @sprites["SPDOld"].height=Graphics.height
    @sprites["SPDOld"].baseColor=Color.new(240,240,240)
    @sprites["SPDOld"].shadowColor=Color.new(40,40,40)
    @sprites["HPOld"].text=_INTL("SPD") 
    @sprites["SPDOld"].visible=false
    @sprites["SPDOld"].viewport=@viewport
    @sprites["SPDOld"].windowskin=nil
    pbPrepareWindow(@sprites["HPNew"])
    @sprites["HPNew"].x=422
    @sprites["HPNew"].y=85
    @sprites["HPNew"].width=Graphics.width-48
    @sprites["HPNew"].height=Graphics.height
    @sprites["HPNew"].baseColor=Color.new(240,240,240)
    @sprites["HPNew"].shadowColor=Color.new(40,40,40)
    @sprites["HPOld"].text=_INTL("HP") 
    @sprites["HPNew"].visible=false
    @sprites["HPNew"].viewport=@viewport
    @sprites["HPNew"].windowskin=nil
    pbPrepareWindow(@sprites["ATKNew"])
    @sprites["ATKNew"].x=422
    @sprites["ATKNew"].y=135
    @sprites["ATKNew"].width=Graphics.width-48
    @sprites["ATKNew"].height=Graphics.height
    @sprites["ATKNew"].baseColor=Color.new(240,240,240)
    @sprites["ATKNew"].shadowColor=Color.new(40,40,40)
    @sprites["HPOld"].text=_INTL("ATK") 
    @sprites["ATKNew"].visible=false
    @sprites["ATKNew"].viewport=@viewport
    @sprites["ATKNew"].windowskin=nil
    pbPrepareWindow(@sprites["DEFNew"])
    @sprites["DEFNew"].x=422
    @sprites["DEFNew"].y=185
    @sprites["DEFNew"].width=Graphics.width-48
    @sprites["DEFNew"].height=Graphics.height
    @sprites["DEFNew"].baseColor=Color.new(240,240,240)
    @sprites["DEFNew"].shadowColor=Color.new(40,40,40)
    @sprites["HPOld"].text=_INTL("DEF") 
    @sprites["DEFNew"].visible=false
    @sprites["DEFNew"].viewport=@viewport
    @sprites["DEFNew"].windowskin=nil
    pbPrepareWindow(@sprites["SATKNew"])
    @sprites["SATKNew"].x=422
    @sprites["SATKNew"].y=235
    @sprites["SATKNew"].width=Graphics.width-48
    @sprites["SATKNew"].height=Graphics.height
    @sprites["SATKNew"].baseColor=Color.new(240,240,240)
    @sprites["SATKNew"].shadowColor=Color.new(40,40,40)
    @sprites["HPOld"].text=_INTL("S. ATK") 
    @sprites["SATKNew"].visible=false
    @sprites["SATKNew"].viewport=@viewport
    @sprites["SATKNew"].windowskin=nil
    pbPrepareWindow(@sprites["SPDNew"])
    @sprites["SPDNew"].x=315
    @sprites["SPDNew"].y=35
    @sprites["SPDNew"].width=Graphics.width-48
    @sprites["SPDNew"].height=Graphics.height
    @sprites["SPDNew"].baseColor=Color.new(240,240,240)
    @sprites["SPDNew"].shadowColor=Color.new(40,40,40)
    @sprites["HPOld"].text=_INTL("S. DEF") 
    @sprites["SPDNew"].visible=false
    @sprites["SPDNew"].viewport=@viewport
    @sprites["SPDNew"].windowskin=nil
    pbPrepareWindow(@sprites["PkmnName"])
    @sprites["PkmnName"].x=422
    @sprites["PkmnName"].y=85
    @sprites["PkmnName"].width=Graphics.width-48
    @sprites["PkmnName"].height=Graphics.height
    @sprites["PkmnName"].baseColor=Color.new(240,240,240)
    @sprites["PkmnName"].shadowColor=Color.new(40,40,40)
    @sprites["PkmnName"].visible=false
    @sprites["PkmnName"].viewport=@viewport
    @sprites["PkmnName"].windowskin=nil
    pbPrepareWindow(@sprites["PkmnLevel"])
    @sprites["PkmnLevel"].x=422
    @sprites["PkmnLevel"].y=135
    @sprites["PkmnLevel"].width=Graphics.width-48
    @sprites["PkmnLevel"].height=Graphics.height
    @sprites["PkmnLevel"].baseColor=Color.new(240,240,240)
    @sprites["PkmnLevel"].shadowColor=Color.new(40,40,40)
    @sprites["PkmnLevel"].visible=false
    @sprites["PkmnLevel"].viewport=@viewport
    @sprites["PkmnLevel"].windowskin=nil
    pbPrepareWindow(@sprites["PkmnLevel50"])
    @sprites["PkmnLevel50"].x=422
    @sprites["PkmnLevel50"].y=185
    @sprites["PkmnLevel50"].width=Graphics.width-48
    @sprites["PkmnLevel50"].height=Graphics.height
    @sprites["PkmnLevel50"].baseColor=Color.new(240,240,240)
    @sprites["PkmnLevel50"].shadowColor=Color.new(40,40,40)
    @sprites["PkmnLevel50"].visible=false
    @sprites["PkmnLevel50"].viewport=@viewport
    @sprites["PkmnLevel50"].windowskin=nil
    pbPrepareWindow(@sprites["PkmnAbility"])
    @sprites["PkmnAbility"].x=422
    @sprites["PkmnAbility"].y=235
    @sprites["PkmnAbility"].width=Graphics.width-48
    @sprites["PkmnAbility"].height=Graphics.height
    @sprites["PkmnAbility"].baseColor=Color.new(240,240,240)
    @sprites["PkmnAbility"].shadowColor=Color.new(40,40,40)
    @sprites["PkmnAbility"].visible=false
    @sprites["PkmnAbility"].viewport=@viewport
    @sprites["PkmnAbility"].windowskin=nil
    pbPrepareWindow(@sprites["HPOldN"])
    @sprites["HPOldN"].x=315
    @sprites["HPOldN"].y=35
    @sprites["HPOldN"].width=Graphics.width-48
    @sprites["HPOldN"].height=Graphics.height
    @sprites["HPOldN"].baseColor=Color.new(240,240,240)
    @sprites["HPOldN"].shadowColor=Color.new(40,40,40)
    @sprites["HPOldN"].visible=false
    @sprites["HPOldN"].viewport=@viewport
    @sprites["HPOldN"].windowskin=nil
    pbPrepareWindow(@sprites["ATKOldN"])
    @sprites["ATKOldN"].x=422
    @sprites["ATKOldN"].y=85
    @sprites["ATKOldN"].width=Graphics.width-48
    @sprites["ATKOldN"].height=Graphics.height
    @sprites["ATKOldN"].baseColor=Color.new(240,240,240)
    @sprites["ATKOldN"].shadowColor=Color.new(40,40,40)
    @sprites["ATKOldN"].visible=false
    @sprites["ATKOldN"].viewport=@viewport
    @sprites["ATKOldN"].windowskin=nil
    pbPrepareWindow(@sprites["DEFOldN"])
    @sprites["DEFOldN"].x=422
    @sprites["DEFOldN"].y=135
    @sprites["DEFOldN"].width=Graphics.width-48
    @sprites["DEFOldN"].height=Graphics.height
    @sprites["DEFOldN"].baseColor=Color.new(240,240,240)
    @sprites["DEFOldN"].shadowColor=Color.new(40,40,40)
    @sprites["DEFOldN"].visible=false
    @sprites["DEFOldN"].viewport=@viewport
    @sprites["DEFOldN"].windowskin=nil
    pbPrepareWindow(@sprites["SATKOldN"])
    @sprites["SATKOldN"].x=422
    @sprites["SATKOldN"].y=185
    @sprites["SATKOldN"].width=Graphics.width-48
    @sprites["SATKOldN"].height=Graphics.height
    @sprites["SATKOldN"].baseColor=Color.new(240,240,240)
    @sprites["SATKOldN"].shadowColor=Color.new(40,40,40)
    @sprites["SATKOldN"].visible=false
    @sprites["SATKOldN"].viewport=@viewport
    @sprites["SATKOldN"].windowskin=nil
    pbPrepareWindow(@sprites["SDEFOld"])
    @sprites["SDEFOldN"].x=422
    @sprites["SDEFOldN"].y=235
    @sprites["SDEFOldN"].width=Graphics.width-48
    @sprites["SDEFOldN"].height=Graphics.height
    @sprites["SDEFOldN"].baseColor=Color.new(240,240,240)
    @sprites["SDEFOldN"].shadowColor=Color.new(40,40,40)
    @sprites["SDEFOldN"].visible=false
    @sprites["SDEFOldN"].viewport=@viewport
    @sprites["SDEFOldN"].windowskin=nil
    pbPrepareWindow(@sprites["SPDOld"])
    @sprites["SPDOldN"].x=315
    @sprites["SPDOldN"].y=35
    @sprites["SPDOldN"].width=Graphics.width-48
    @sprites["SPDOldN"].height=Graphics.height
    @sprites["SPDOldN"].baseColor=Color.new(240,240,240)
    @sprites["SPDOldN"].shadowColor=Color.new(40,40,40)
    @sprites["SPDOldN"].visible=false
    @sprites["SPDOldN"].viewport=@viewport
    @sprites["SPDOldN"].windowskin=nil
    pbPrepareWindow(@sprites["HPNew"])
    @sprites["HPNewN"].x=422
    @sprites["HPNewN"].y=85
    @sprites["HPNewN"].width=Graphics.width-48
    @sprites["HPNewN"].height=Graphics.height
    @sprites["HPNewN"].baseColor=Color.new(240,240,240)
    @sprites["HPNewN"].shadowColor=Color.new(40,40,40)
    @sprites["HPNewN"].visible=false
    @sprites["HPNewN"].viewport=@viewport
    @sprites["HPNewN"].windowskin=nil
    pbPrepareWindow(@sprites["ATKNew"])
    @sprites["ATKNewN"].x=422
    @sprites["ATKNewN"].y=135
    @sprites["ATKNewN"].width=Graphics.width-48
    @sprites["ATKNewN"].height=Graphics.height
    @sprites["ATKNewN"].baseColor=Color.new(240,240,240)
    @sprites["ATKNewN"].shadowColor=Color.new(40,40,40)
    @sprites["ATKNewN"].visible=false
    @sprites["ATKNewN"].viewport=@viewport
    @sprites["ATKNewN"].windowskin=nil
    pbPrepareWindow(@sprites["DEFNew"])
    @sprites["DEFNewN"].x=422
    @sprites["DEFNewN"].y=185
    @sprites["DEFNewN"].width=Graphics.width-48
    @sprites["DEFNewN"].height=Graphics.height
    @sprites["DEFNewN"].baseColor=Color.new(240,240,240)
    @sprites["DEFNewN"].shadowColor=Color.new(40,40,40)
    @sprites["DEFNewN"].visible=false
    @sprites["DEFNewN"].viewport=@viewport
    @sprites["DEFNewN"].windowskin=nil
    pbPrepareWindow(@sprites["SATKNew"])
    @sprites["SATKNewN"].x=422
    @sprites["SATKNewN"].y=235
    @sprites["SATKNewN"].width=Graphics.width-48
    @sprites["SATKNewN"].height=Graphics.height
    @sprites["SATKNewN"].baseColor=Color.new(240,240,240)
    @sprites["SATKNewN"].shadowColor=Color.new(40,40,40)
    @sprites["SATKNewN"].visible=false
    @sprites["SATKNewN"].viewport=@viewport
    @sprites["SATKNewN"].windowskin=nil
    pbPrepareWindow(@sprites["SPDNew"])
    @sprites["SPDNewN"].x=315
    @sprites["SPDNewN"].y=35
    @sprites["SPDNewN"].width=Graphics.width-48
    @sprites["SPDNewN"].height=Graphics.height
    @sprites["SPDNewN"].baseColor=Color.new(240,240,240)
    @sprites["SPDNewN"].shadowColor=Color.new(40,40,40)
    @sprites["SPDNewN"].visible=false
    @sprites["SPDNewN"].viewport=@viewport
    @sprites["SPDNewN"].windowskin=nil
	
#finishing
	pbBGMFade(1.0)
	pbBGMStop
    pbBGMPlay(ReincarnationConfig::CUSTOM_MUSIC)
  end

  def pbEndScene
    pbFadeOutAndHide(@icons)
    pbDisposeSpriteHash(@icons)

    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end


# Script that manages button inputs  
  def pbSelectreincarnation
    delay = 0
	i = 0
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    pbSetSystemFont(overlay)
    pbDrawImagePositions(overlay,@imagepos)
    while true
    Graphics.update
      Input.update
      self.update
    @sprites["A"].text=_INTL("{1}",@reincarnpkmn) 
    @sprites["B"].text=_INTL("{1}",@donApkmn)
    @sprites["C"].text=_INTL("{1}",@donBpkmn)
	if @reincarnpkmnsp!=0
    @sprites["A"].text=_INTL("{1} ♂",@reincarnpkmn) if @reincarnpkmnsp.male?
    @sprites["A"].text=_INTL("{1} ♀",@reincarnpkmn) if @reincarnpkmnsp.female?
    @sprites["A"].text=_INTL("{1}",@reincarnpkmn) if @reincarnpkmnsp.genderless?
	end
	if @donApkmnsp!=0
    @sprites["B"].text=_INTL("{1} ♂",@donApkmn) if @donApkmnsp.male?
    @sprites["B"].text=_INTL("{1} ♀",@donApkmn) if @donApkmnsp.female?
    @sprites["B"].text=_INTL("{1} ",@donApkmn) if @donApkmnsp.genderless?
	end
	if @donBpkmnsp!=0
    @sprites["C"].text=_INTL("{1} ♂",@donBpkmn) if @donBpkmnsp.male?
    @sprites["C"].text=_INTL("{1} ♀",@donBpkmn) if @donBpkmnsp.female?
    @sprites["C"].text=_INTL("{1} ",@donBpkmn) if @donBpkmnsp.genderless?
	end
    @sprites["D"].text=_INTL("{1}", @pkmnnat1) if @pkmnnat1!=0 ||  @pkmnnat1!=-1
    @sprites["E"].text=_INTL("{1}",@pkmnnat2) if @pkmnnat2!=0 ||  @pkmnnat2!=-1
    @sprites["F"].text=_INTL("{1}",@pkmniv) if @pkmniv!=0 ||  @pkmniv!=-1
	@sprites["A"].text=_INTL("Recipient",@reincarnpkmn) if @reincarnpkmn==0 ||  @reincarnpkmn==-1  ||  @reincarnpkmn==""  ||  @reincarnpkmn==nil
    @sprites["B"].text=_INTL("Donor 1",@donApkmn) if @donApkmn==0 ||  @donApkmn==-1  ||  @donApkmn==""  ||  @donApkmn==nil
    @sprites["C"].text=_INTL("Donor 2",@donBpkmn) if @donBpkmn==0 ||  @donBpkmn==-1  ||  @donBpkmn==""  ||  @donBpkmn==nil
    @sprites["D"].text=_INTL("Stat Boon", @pkmnnat1) if @pkmnnat1==0 ||  @pkmnnat1==-1  ||  @pkmnnat1==""  ||  @pkmnnat1==nil
    @sprites["E"].text=_INTL("Stat Bane",@pkmnnat2) if @pkmnnat2==0 ||  @pkmnnat2==-1  ||  @pkmnnat2==""  ||  @pkmnnat2==nil
    @sprites["F"].text=_INTL("Stat Modifier",@pkmniv) if @pkmniv==0 ||  @pkmniv==-1  ||  @pkmniv==""  ||  @pkmniv==nil
	  
      #_INTL("♂") : _INTL("♀")
      selectionNum=@selection
      if Input.trigger?(Input::UP)
	    if @selection==0 && @reincarnpkmn!=0 && @donApkmn!=0 && @donBpkmn!=0
		  pbSEPlay("GUI party switch")
          @sprites["reincarnatore"].visible = false
          @sprites["icon_#{4}"].visible = false
          @sprites["begin"].y=340
          @sprites["A"].x=422
          @sprites["A"].y=35
          @selection=6
	    elsif @selection==0
		  pbSEPlay("GUI party switch")
          @selection=5
		  @sprites["ivse"].visible = true
          @icons["itemResult3"].visible=true
		  if @sprites["icon_#{4}"]!=nil
          @sprites["icon_#{4}"].visible = false
		  end
          @sprites["reincarnatore"].visible = false
          @sprites["F"].x=315
          @sprites["F"].y=285
          @sprites["A"].x=422
          @sprites["A"].y=35
        elsif @selection==1
		  pbSEPlay("GUI party switch")
          @selection-=1
          @sprites["reincarnatore"].visible = true
          @sprites["donatorAe"].visible = false
		  if @sprites["icon_#{4}"]!=nil
          @sprites["icon_#{4}"].visible = true
		  end
		  if @sprites["icon_#{5}"]!=nil
          @sprites["icon_#{5}"].visible = false
		  end
          @sprites["A"].x=315
          @sprites["A"].y=35
          @sprites["B"].x=422
          @sprites["B"].y=85
        elsif @selection==2
		  pbSEPlay("GUI party switch")
          @sprites["donatorAe"].visible = true
          @sprites["donatorBe"].visible = false
		  if @sprites["icon_#{5}"]!=nil
          @sprites["icon_#{5}"].visible = true
		  end
		  if @sprites["icon_#{6}"]!=nil
          @sprites["icon_#{6}"].visible = false
		  end
          @sprites["B"].x=315
          @sprites["B"].y=85
          @sprites["C"].x=422
          @sprites["C"].y=135
          @selection-=1
        elsif @selection==3
		  pbSEPlay("GUI party switch")
          @sprites["donatorBe"].visible = true
          @sprites["nature1e"].visible = false
          @icons["itemResult1"].visible=false
		  if @sprites["icon_#{6}"]!=nil
          @sprites["icon_#{6}"].visible = true
		  end
          @sprites["C"].x=315
          @sprites["C"].y=135
          @sprites["D"].x=422
          @sprites["D"].y=185
          @selection-=1
        elsif @selection==4
		  pbSEPlay("GUI party switch")
          @sprites["nature1e"].visible = true
          @sprites["nature2e"].visible = false
          @icons["itemResult1"].visible=true
          @icons["itemResult2"].visible=false
          @sprites["D"].x=315
          @sprites["D"].y=185
          @sprites["E"].x=422
          @sprites["E"].y=235
          @selection-=1
		elsif @selection==6
		  pbSEPlay("GUI party switch")
          @sprites["begin"].y=350
          @sprites["F"].x=315
          @sprites["F"].y=285
		  @sprites["ivse"].visible = true
          @selection-=1
        else
		  pbSEPlay("GUI party switch")
          @sprites["nature2e"].visible = true
		  @sprites["ivse"].visible = false
          @icons["itemResult2"].visible=true
          @icons["itemResult3"].visible=false
		  if @sprites["icon_#{4}"]!=nil
          @sprites["icon_#{4}"].visible = false
		  end
          @sprites["F"].x=422
          @sprites["F"].y=285
          @sprites["E"].x=315
          @sprites["E"].y=235
          @selection-=1
        end
      end
      if Input.trigger?(Input::DOWN)
        if @selection==0
		  pbSEPlay("GUI party switch")
		  @sprites["reincarnatore"].visible = false
          @sprites["donatorAe"].visible = true
          @sprites["A"].x=422
          @sprites["A"].y=35
          @sprites["B"].x=315
          @sprites["B"].y=85
		  if @sprites["icon_#{4}"]!=nil
          @sprites["icon_#{4}"].visible = false
		  end
		  if @sprites["icon_#{5}"]!=nil
          @sprites["icon_#{5}"].visible = true
		  end
          @selection+=1
        elsif @selection==1
		  pbSEPlay("GUI party switch")
          @sprites["donatorAe"].visible = false
          @sprites["donatorBe"].visible = true
          @sprites["B"].x=422
          @sprites["B"].y=85
          @sprites["C"].x=315
          @sprites["C"].y=135
		  if @sprites["icon_#{5}"]!=nil
          @sprites["icon_#{5}"].visible = false
		  end
		  if @sprites["icon_#{6}"]!=nil
          @sprites["icon_#{6}"].visible = true
		  end
          @selection+=1
        elsif @selection==2
		  pbSEPlay("GUI party switch")
          @sprites["donatorBe"].visible = false
          @sprites["nature1e"].visible = true
          @icons["itemResult1"].visible=true
          @selection+=1
          @sprites["C"].x=422
          @sprites["C"].y=135
          @sprites["D"].x=315
          @sprites["D"].y=185
		  if @sprites["icon_#{6}"]!=nil
          @sprites["icon_#{6}"].visible = false
		  end
        elsif @selection==3
		  pbSEPlay("GUI party switch")
          @sprites["nature1e"].visible = false
          @sprites["nature2e"].visible = true
          @icons["itemResult2"].visible=true
          @icons["itemResult1"].visible=false
          @sprites["D"].x=422
          @sprites["D"].y=185
          @sprites["E"].x=315
          @sprites["E"].y=235
          @selection+=1
        elsif @selection==4
		  pbSEPlay("GUI party switch")
          @sprites["nature2e"].visible = false
          @icons["itemResult2"].visible=false
          @icons["itemResult3"].visible=true
          @sprites["E"].x=422
          @sprites["E"].y=235
          @sprites["F"].x=315
          @sprites["F"].y=285
		  @sprites["ivse"].visible = true
          @selection+=1
		elsif @selection==5 && @reincarnpkmn!=0 && @donApkmn!=0 && @donBpkmn!=0 
		  @sprites["ivse"].visible = false
		  pbSEPlay("GUI party switch")
          @icons["itemResult3"].visible=false
          @sprites["F"].x=422
          @sprites["F"].y=285
          @sprites["begin"].y=340
          @selection+=1
		elsif @selection==6
		  pbSEPlay("GUI party switch")
		  @sprites["reincarnatore"].visible = true
          @sprites["A"].x=315
          @sprites["A"].y=35
          @sprites["icon_#{4}"].visible = true
          @sprites["begin"].y=350
          @selection=0
        else
		  pbSEPlay("GUI party switch")
		  @sprites["ivse"].visible = false
		  @sprites["reincarnatore"].visible = true
          @icons["itemResult3"].visible=false
          @sprites["F"].x=422
          @sprites["F"].y=285
          @sprites["A"].x=315
          @sprites["A"].y=35
		  if @sprites["icon_#{4}"]!=nil
          @sprites["icon_#{4}"].visible = true
		  end
          @selection=0
        end
      end
      if Input.trigger?(Input::ACTION)
        if @selection==0
		loop do
		  pbChoosePokemon(1,3)
		  if @reincarnpkmnsp!= 0
          @sprites["icon_#{0}"].visible = false
		  @reincarnpkmnsp = 0
		  end
		  @reincarnpkmn = $game_variables[3]
		  if $game_variables[1] != -1
		  @reincarnpkmnsp = ($player.party[pbGet(1)])
		  if @reincarnpkmnsp == @donApkmnsp || @reincarnpkmnsp == @donBpkmnsp
              pbMessage(_INTL("{1} has already been chosen! Choose Another!", @reincarnpkmn))
			  @reincarnpkmnsp = 0
		  else
		  i = @reincarnpkmnsp.species_data
		  @sprites["icon_#{0}"] = PokemonSpeciesIconSprite.new(i.id,@viewport)
		  @sprites["icon_#{0}"].x = 116
		  @sprites["icon_#{0}"].y = 76
          @sprites["icon_#{0}"].visible = true
		  @sprites["icon_#{4}"] = PokemonSpeciesIconSprite.new(i.id,@viewport)
		  @sprites["icon_#{4}"].x = 270
		  @sprites["icon_#{4}"].y = 15
          @sprites["icon_#{4}"].visible = true
		  $game_variables[3] = 0
		  $game_variables[1] = 0
			  break
		  end
		end
		  end
        elsif @selection==1
		loop do
		  pbChoosePokemon(1,3)
		  if @donApkmnsp!= 0
          @sprites["icon_#{1}"].visible = false
		  @donApkmnsp = 0
		  end
		  @donApkmn = $game_variables[3]
		  if $game_variables[1] != -1
		  @donApkmnsp = ($player.party[pbGet(1)])
		  if @donApkmnsp == @reincarnpkmnsp|| @donApkmnsp == @donBpkmnsp
              pbMessage(_INTL("{1} has already been chosen! Choose Another!", @donApkmn))
			  @donApkmnsp = 0
		  else
		  i = @donApkmnsp.species_data
		  @sprites["icon_#{1}"] = PokemonSpeciesIconSprite.new(i.id,@viewport)
		  @sprites["icon_#{1}"].x = 50
		  @sprites["icon_#{1}"].y = 200
          @sprites["icon_#{1}"].visible = true
		  @sprites["icon_#{5}"] = PokemonSpeciesIconSprite.new(i.id,@viewport)
		  @sprites["icon_#{5}"].x = 270
		  @sprites["icon_#{5}"].y = 65
          @sprites["icon_#{5}"].visible = true
		  $game_variables[3] = 0
		  $game_variables[1] = 0
			  break
		  end
		 end
		  end
        elsif @selection==2
		 loop do
		  pbChoosePokemon(1,3)
		  if @donBpkmnsp != 0
          @sprites["icon_#{2}"].visible = false
		  @donBpkmnsp = 0
		  end
		  @donBpkmn = $game_variables[3]
		  if $game_variables[1] != -1
		  @donBpkmnsp = ($player.party[pbGet(1)])
		  if @donBpkmnsp == @donApkmnsp || @donBpkmnsp == @reincarnpkmnsp
              pbMessage(_INTL("{1} has already been chosen! Choose Another!", @donBpkmn))
			  @donBpkmnsp = 0
		  else
		  i = @donBpkmnsp.species_data
		  @sprites["icon_#{2}"] = PokemonSpeciesIconSprite.new(i.id,@viewport)
		  @sprites["icon_#{2}"].x = 177
		  @sprites["icon_#{2}"].y = 200
          @sprites["icon_#{2}"].visible = true
		  @sprites["icon_#{6}"] = PokemonSpeciesIconSprite.new(i.id,@viewport)
		  @sprites["icon_#{6}"].x = 270
		  @sprites["icon_#{6}"].y = 115
          @sprites["icon_#{6}"].visible = true
		  $game_variables[3] = 0
		  $game_variables[1] = 0
			  break
		  end
		  end
		  end
        elsif @selection==3
          pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
@pkmnnat1 = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_reinboon? })
}
if @pkmnnat1 != nil
item = @pkmnnat1
filenamF =GameData::Item.icon_filename(@pkmnnat1) 
@icons["itemResult1"].setBitmap(filenamF)
@pkmnnat1sp = @pkmnnat1
@pkmnnat1 = GameData::Item.get(item).name
end
        elsif @selection==4
           pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
@pkmnnat2 = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_reinbane? })
}
if @pkmnnat2 != nil
item = @pkmnnat2
filenamG =GameData::Item.icon_filename(@pkmnnat2) 
@pkmnnat2sp = @pkmnnat2
@pkmnnat2 = GameData::Item.get(item).name
@icons["itemResult2"].setBitmap(filenamG)
end
		elsif @selection==6
		Reincarnation.begin_reincarnation(@reincarnpkmnsp, @donApkmnsp, @donBpkmnsp, @pkmnivsp, @pkmnnat1sp, @pkmnnat2sp)
		pbSEPlay("GUI naming confirm")
        else
          pbFadeOutIn(99999){
scene = PokemonBag_Scene.new
screen = PokemonBagScreen.new(scene,$PokemonBag)
@pkmniv = screen.pbChooseItemScreen(proc { |item| GameData::Item.get(item).is_rein_stone? })
}
if @pkmniv != nil
item = @pkmniv
filenamH =GameData::Item.icon_filename(@pkmniv) 
@pkmnivsp = @pkmniv
@pkmniv = GameData::Item.get(item).name
@icons["itemResult3"].setBitmap(filenamH)
end
        end
      end
       #Cancel
      if Input.trigger?(Input::BACK)
		map_id = $game_map.map_id
		map = load_data(sprintf("Data/Map%03d.rxdata",map_id))
		pbBGMPlay(map.bgm)
        return -1
      end     
	  if Input.trigger?(Input::SPECIAL)
	  end
    end
  end
  
def pbRefresh
end



end

#Call Crafts.craftWindow
module Reincarnate
  def self.reincarnationWindow
          pbFadeOutIn {
  reScene=Reincarnation_UI.new
  reScene.pbStartScene
  recar=reScene.pbSelectreincarnation
  reScene.pbEndScene}
 end
end