#requireAdmin
#pragma compile(Icon, icon/see.ico)
#include <processing.au3>
#include <WinAPI.au3>
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <AutoItConstants.au3>

;~ ========================
;~ Mode:
;~ 0  -  Party  (Default)
;~ 1  -  Solo

global $mode = 0
global $win = WinGetHandle("Seven Knights 2")

;~ Include Files:
#include <src/pixelPoints.au3>
#include <src/utilitiesFunction.au3>
#include <src/displayControl.au3>

Opt("MouseCoordMode", 2)
HotKeySet("{ESC}", "onExit")

main()

func main()
	loadDisplay()

	while 1
		$gMsg = GUIGetMsg()
		
		switch $gMsg
			case $GUI_EVENT_CLOSE
				exitloop

			case $startButton
				while 1
					isRunning()
					Sleep(500)
				wend
		endswitch
	wend

	; Delete the previous GUI and all controls.
	GUIDelete($gMsg)
endfunc

func isRunning()
	if $mode == 0 then
		color($member, $memberColor, 0, 0, 'member')
		color($start, $startColor, 0, 20)
	else
		color($start, $startColor, 0, 20)
	endif

	color($ticket, $ticketColor)
	color($re, $reColor, 0, 72)
	color($alertMsg, $alertMsgColor, 0, 20)
endfunc
