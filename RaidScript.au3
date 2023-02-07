#requireAdmin
#pragma compile(Icon, icon/Irin6_Icon.ico)
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
#include <File.au3>
#include <GuiEdit.au3>
#include <WinAPIFiles.au3>

global $win = WinGetHandle("Seven Knights 2")
global $config = @ScriptDir & "\config.ini"

;~ Include Files:
#include <src/pixelPoints.au3>
#include <src/displayControl.au3>
#include <src/tools.au3>

Opt("MouseCoordMode", 2)
HotKeySet("{HOME}", "onExit")

loadGUI()
loadSettings()

while 1
	$dailyCtrl = rConfig('daily', 'Default')
	$startCtrl = rConfig('start', 'Default')
	$ticketCtrl = rConfig('ticket', 'Default')
	$retryCtrl = rConfig('retry', 'Default')
	
	;~ Arena
	$arenaCtrl = rConfig('arena', 'Daily')
	$arenaNormalCtrl = rConfig('normal', 'Daily')
	$arenaPrepareCtrl = rConfig('prepare', 'Daily')
	$arenaAutoCtrl = rConfig('auto', 'Daily')
	$arenaBattleCtrl = rConfig('battle', 'Daily')
	$arenaOkCtrl = rConfig('ok', 'Daily')

	$gMsg = GUIGetMsg()
	switch $gMsg
		case $GUI_EVENT_CLOSE
			onExit()


		case $startButton
			switch GUICtrlRead($startButton)
				case $GUI_CHECKED
					GUICtrlSetData($startButton, "Pause")
					guiEvent('start', true, 'app start')
				case else
					GUICtrlSetData($startButton, "Start")
					guiEvent('start', false, 'app pause')
			endswitch

		case $ticketCheckbox
			switch GUICtrlRead($ticketCheckbox)
				case $GUI_CHECKED
					GUICtrlSetState($ticketCheckbox, $GUI_CHECKED)
					guiEvent('ticket', true, 'set ticket - enable')
				case else
					GUICtrlSetState($ticketCheckbox, $GUI_UNCHECKED)
					guiEvent('ticket', false, 'set ticket - disable')
			endswitch

		case $retryCheckbox
			switch GUICtrlRead($retryCheckbox)
				case $GUI_CHECKED
					GUICtrlSetState($retryCheckbox, $GUI_CHECKED)
					guiEvent('retry', true, 'set retry - enable')
				case else
					GUICtrlSetState($retryCheckbox, $GUI_UNCHECKED)
					guiEvent('retry', false, 'set retry - disable')
			endswitch

		case $clearButton
			if GUICtrlRead($clearButton) then
				GUICtrlSetState($ticketCheckbox, $GUI_UNCHECKED)
				GUICtrlSetState($retryCheckbox, $GUI_UNCHECKED)
				guiEvent('ticket', false, 'set ticket - disable')
				guiEvent('retry', false, 'set retry - disable')
			endif

		case $exitButton
			if GUICtrlRead($exitButton) then
				onExit()
			endif
		case $windowButton
			if GUICtrlRead($windowButton) then
				setWindowSize()
			endif
	endswitch


	if $startCtrl == 1 then
		color($member, $memberColor, 0, 0, 'member', 'active ready')
		color($start, $startColor, 0, 20, "", 'active start')

		if $ticketCtrl == 1 then
			color($ticket, $ticketColor, 0, 0, "", 'active ticket')
		endif

		if $retryCtrl == 1 then
			color($retry, $retryColor, 0, 72, "", 'active retry')
		endif
	endif


wend
GUIDelete($gMsg)

ConsoleWrite("outside while")



