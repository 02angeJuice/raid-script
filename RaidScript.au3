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

global $win = WinGetHandle("Seven Knights 2")
global $config = @ScriptDir & "\config.ini"

;~ global $startConfig = IniRead($config,"DefaultConfig", "start", "")
;~ global $ticketConfig = IniRead($config,"DefaultConfig", "ticket", "")
;~ global $retryConfig = IniRead($config,"DefaultConfig", "retry", "")

;~ Include Files:
#include <src/pixelPoints.au3>
#include <src/utilitiesFunction.au3>
#include <src/displayControl.au3>

Opt("MouseCoordMode", 2)
HotKeySet("{ESC}", "onExit")


setWindowSize()
loadGUI()
loadSettings()
	
while 1
	$loadStart = control('start')
	$loadTicket = control('ticket')
	$loadRetry = control('retry')

	$gMsg = GUIGetMsg()
	switch $gMsg
		case $GUI_EVENT_CLOSE
			onExit()

		case $startButton
			switch GUICtrlRead($startButton)
				case $GUI_CHECKED
					GUICtrlSetData($startButton, "Pause")
					guiEvent('start', true)
				case else
					GUICtrlSetData($startButton, "Start")
					guiEvent('start', false)
			endswitch

		case $ticketCheckbox
			switch GUICtrlRead($ticketCheckbox)
				case $GUI_CHECKED
					GUICtrlSetState($ticketCheckbox, $GUI_CHECKED)
					guiEvent('ticket', true)
				case else
					GUICtrlSetState($ticketCheckbox, $GUI_UNCHECKED)
					guiEvent('ticket', false)
			endswitch

		case $retryCheckbox
			switch GUICtrlRead($retryCheckbox)
				case $GUI_CHECKED
					GUICtrlSetState($retryCheckbox, $GUI_CHECKED)
					guiEvent('retry', true)
				case else
					GUICtrlSetState($retryCheckbox, $GUI_UNCHECKED)
					guiEvent('retry', false)
			endswitch

		case $clearButton
			if GUICtrlRead($clearButton) then
				GUICtrlSetState($ticketCheckbox, $GUI_UNCHECKED)
				GUICtrlSetState($retryCheckbox, $GUI_UNCHECKED)
				guiEvent('ticket', false)
				guiEvent('retry', false)
			endif

		case $exitButton
			if GUICtrlRead($exitButton) then
				IniWrite($config, "DefaultConfig", "start", 0)
				onExit()
			endif
	endswitch

	if $loadStart == 1 then
		color($member, $memberColor, 0, 0, 'member')
		color($start, $startColor, 0, 20)

		if $loadTicket == 1 then
			color($ticket, $ticketColor)
		endif

		if $loadRetry == 1 then
			color($retry, $retryColor, 0, 72)
		endif
	endif

wend
GUIDelete($gMsg)

ConsoleWrite("outside while")

func onExit()
	MsgBox(0, "Alert", "Exit Macro.", 10)
	exit
endfunc

