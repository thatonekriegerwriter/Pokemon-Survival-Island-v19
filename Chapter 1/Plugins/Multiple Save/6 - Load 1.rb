#----------------------------------------#
# Load                                   #
#----------------------------------------#
class PokemonLoadScreen
  def initialize(scene)
    @scene = scene
  end

	def pbStartLoadScreen
    commands = []
    cmd_continue     = -1
    cmd_new_game     = -1
    cmd_debug        = -1
    cmd_quit         = -1
    show_continue    = FileSave.count>0
    commands[cmd_continue = commands.length] = _INTL('Load Game') if show_continue
    commands[cmd_new_game = commands.length]  = _INTL('New Game')
    commands[cmd_debug = commands.length]     = _INTL('Debug') if $DEBUG
    commands[cmd_quit = commands.length]      = _INTL('Quit Game')
		@scene.pbStartScene(commands, false, nil, 0, nil, 0)
		@scene.pbStartScene2
    loop do
      command = @scene.pbChoose(commands)
      pbPlayDecisionSE if command != cmd_quit
      case command
      when cmd_continue
				pbFadeOutIn {
					file = ScreenChooseFileSave.new(FileSave.count)
					file.movePanel(1)
					@scene.pbEndScene if !file.staymenu
					file.endScene
					return if !file.staymenu
				}
      when cmd_new_game
		          @scene.pbEndScene
	commands = []
    cmd_psia     = -1
    cmd_demo     = -1
    commands[cmd_psia = commands.length] = _INTL('Play Pokemon SI: Adventures')
    commands[cmd_demo = commands.length]  = _INTL('Play Pokemon SI: Classic')
		@scene.pbStartScene(commands, false, nil, 0, nil, 0)
		@scene.pbStartScene2
    loop do
      command = @scene.pbChoose(commands)
      pbPlayDecisionSE if command != cmd_quit
      case command
      when cmd_psia
	     pbMessage(_INTL("Pokemon Survival Island: Adventures is a new game based on the original."))
	     pbMessage(_INTL("Some elements remain, but it is almost entirely a new game."))
	     if pbConfirmMessage(_INTL("Do wish to play PSI: Adventures?"))
		  $PokemonSystem.playermode = 1
		  $PokemonSystem.difficulty = 1
		  $PokemonSystem.nuzlockemode = 1
		  $PokemonSystem.survivalmode = 1
		  @scene.pbEndScene
				if Settings::LANGUAGES.length >= 2 && show_continue
					$PokemonSystem.language = pbChooseLanguage
					pbLoadMessages('Data/' + Settings::LANGUAGES[$PokemonSystem.language][1])
				end
		  $PokemonSystem.difficulty = 1
		  $PokemonSystem.nuzlockemode = 1
		  $PokemonSystem.survivalmode = 1
        Game.start_new
        return
		 else
		 end
      when cmd_demo
	     pbMessage(_INTL("Pokemon Survival Island: Classic is a minorly changed version of the original game."))
	     pbMessage(_INTL("It could be treated as a demo for the full game."))
	     pbMessage(_INTL("Due to lacking a lot of the same elements as the full game, it has an 8 ingame day timer."))
	     pbMessage(_INTL("You can then choose to use the Classic save in the Adventures mode."))
	     if pbConfirmMessage(_INTL("Do wish to play PSI: Classic?"))
		  $PokemonSystem.playermode = 0
		  $PokemonSystem.difficulty = 1
		  $PokemonSystem.nuzlockemode = 1
		  $PokemonSystem.survivalmode = 1
		          @scene.pbEndScene
				if Settings::LANGUAGES.length >= 2 && show_continue
					$PokemonSystem.language = pbChooseLanguage
					pbLoadMessages('Data/' + Settings::LANGUAGES[$PokemonSystem.language][1])
				end
		  $PokemonSystem.difficulty = 1
		  $PokemonSystem.nuzlockemode = 1
		  $PokemonSystem.survivalmode = 1
        Game.start_new
        return
		 else
		 end
      end
    end


      when cmd_debug
        pbFadeOutIn { pbDebugMenu(false) }
      when cmd_quit
        pbPlayCloseMenuSE
        @scene.pbEndScene
        $scene = nil
        return
      else
        pbPlayBuzzerSE
      end
    end
  end
end