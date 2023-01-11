#requireAdmin
#pragma compile(Icon, icon/see.ico)
#include <processing.au3>
#include <WinAPI.au3>
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <AutoItConstants.au3>

#include <WinAPIFiles.au3>
#include <File.au3>

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
	loadConfig()
	setWindowSize()
	display()

	; Delete the previous GUI and all controls.
	
endfunc

func isRunning()
	$gMsg = GUIGetMsg()
	
	if $retryCheckbox then
		switch GUICtrlRead($retryCheckbox)
			case $GUI_CHECKED
				IniWrite($config, "DefaultConfig", "retry", 1)
			case else
				IniWrite($config, "DefaultConfig", "retry", 0)
		endswitch
	endif

	if $ticketCheckbox then
		switch GUICtrlRead($ticketCheckbox)
			case $GUI_CHECKED
				IniWrite($config, "DefaultConfig", "ticket", 1)
			case else
				IniWrite($config, "DefaultConfig", "ticket", 0)
		endswitch
	endif

	loadConfig()

	if $mode == 0 then
		color($member, $memberColor, 0, 0, 'member')
		color($start, $startColor, 0, 20)
	else
		color($start, $startColor, 0, 20)
	endif

	if $ticketConfig == 1 then
		color($ticket, $ticketColor)
	endif

	if $retryConfig == 1 then
		color($retry, $retryColor, 0, 72)
	endif
	
	color($alertMsg, $alertMsgColor, 0, 20)
endfunc
