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
HotKeySet("{ESC}", "onExit")

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

		case $dailyButton
			switch GUICtrlRead($dailyButton)
				case $GUI_CHECKED
					GUICtrlSetData($dailyButton, "Pause")
					guiEvent('daily', true, 'app daily')
				case else
					GUICtrlSetData($dailyButton, "Daily")
					guiEvent('daily', false, 'app pause')
			endswitch

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

		case $arenaCheckbox
			switch GUICtrlRead($arenaCheckbox)
				case $GUI_CHECKED
					GUICtrlSetState($arenaCheckbox, $GUI_CHECKED)
					guiEvent('arena', true, 'set arena - enable')
				case else
					GUICtrlSetState($arenaCheckbox, $GUI_UNCHECKED)
					guiEvent('arena', false, 'set arena - disable')
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

	if $dailyCtrl == 1 then
		if $arenaCtrl == 1 then


			do
				$arenaCheck = color($arena, $arenaColor, 0, 0, "", 'active arena')
			until $arenaCheck == 0
			wConfig('arena', 'Daily', 0)
			

			do
				$normalCheck = color($arenaNormal, $arenaNormalColor, 0, 0, "", 'active arena normal')
			until	$normalCheck == 0
			wConfig('normal', 'Daily', 0)

			do
				$prepareCheck = color($arenaPrepare, $arenaPrepareColor, 0, 0, "", 'active arena prepare')
			until $prepareCheck == 0
			wConfig('prepare', 'Daily', 0)

			do
				$autoCheck = color($arenaAuto, $arenaAutoColor, 0, 0, "", 'active arena auto')
			until $autoCheck == 0
			wConfig('auto', 'Daily', 0)


			do
				$battleCheck = color($arenaBattle, $arenaBattleColor, 0, 0, "", 'active arena battle')
			until $battleCheck == 0
			wConfig('battle', 'Daily', 0)


			do
				$okCheck = color($arenaOk, $arenaOkColor, 0, 0, "", 'active arena ok')
			until $okCheck == 0
			wConfig('ok', 'Daily', 0)


		endif
	endif


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



