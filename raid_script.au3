#RequireAdmin
#pragma compile(Icon, icon/see.ico)
#include <Processing.au3>
#include <WinAPI.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>

; Include Files:
#include <src/pixelPoints.au3>
#include <src/utilitiesFunction.au3>

;========================
; Mode:
; 0  -  Party  (Default)
; 1  -  Solo

Global $mode = 0
Global $win = WinGetHandle("Seven Knights 2")

Opt("MouseCoordMode", 2)
HotKeySet("{ESC}", "onExit")

While 1
	isRunning()
	Sleep(500)
WEnd

Func isRunning()
	If $mode == 0 Then
		color($member, $memberColor, 'member')
		color($start, $startColor, 20)
	Else
		color($start, $startColor, 20)

	EndIf

	color($ticket, $ticketColor)
	color($re, $reColor)
	color($alertMsg, $alertMsgColor, 20)
EndFunc
