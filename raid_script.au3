#RequireAdmin
#pragma compile(Icon, icon/see.ico)

#include <Processing.au3>
#include <WinAPI.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>

#include <utils.au3>
	;========================
	; Mode:
	; 0  -  Party  (Default)
	; 1  -  Solo
Global $mode = 0
Global $win = WinGetHandle("Seven Knights 2")

Global $start = [829, 438]
Global $startColor = '0x5C79D5'
Global $member = [773, 461]
Global $memberColor = '0xFBFBFC'
Global $ticket = [379, 345]
Global $ticketColor = '0x121722'
Global $re = [601, 326]
Global $reColor = '0x5671CF'

	; Alert: Party invalid state.
Global $alertMsg = [469, 314]
Global $alertMsgColor = '0x5C79D2'

	;========================

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
