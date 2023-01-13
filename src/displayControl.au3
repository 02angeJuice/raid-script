func loadGUI()
	#Region ### START Koda GUI section ### Form=c:\users\b0\desktop\raid_script_gui\raid-script-form.kxf
	global $Form1_1 = GUICreate("RaidScript", 471, 184, 310, 209, $GUI_SS_DEFAULT_GUI)
	GUISetFont(8, 400, 0, "consolas")
	global $Tab1 = GUICtrlCreateTab(8, 8, 457, 169, $TCS_FIXEDWIDTH)
	GUICtrlSetFont(-1, 12, 400, 0, "consolas")


	;~ TabSheet 1
	global $TabSheet1 = GUICtrlCreateTabItem("Main")
	global $startButton = GUICtrlCreateCheckbox("Start", 24, 109, 75, 25, $BS_PUSHLIKE)
	GUICtrlSetFont(-1, 13, 800, 0, "consolas")
	GUICtrlSetColor(-1, 0x99B4D1)
	global $exitButton = GUICtrlCreateButton("Exit", 24, 141, 75, 25)
	GUICtrlSetFont(-1, 13, 800, 0, "consolas")
	GUICtrlSetColor(-1, 0x99B4D1)
	global $Edit1 = GUICtrlCreateEdit("", 120, 45, 345, 105)
	GUICtrlSetData(-1, "Edit1")
	GUICtrlSetFont(-1, 10, 400, 0, "consolas")

	;~ TabSheet 2
	global $TabSheet2 = GUICtrlCreateTabItem("Settings")
	global $ticketCheckbox = GUICtrlCreateCheckbox("Re-enter ticket", 28, 111, 150, 17)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")
	global $retryCheckbox = GUICtrlCreateCheckbox("Retry (Failed)", 28, 141, 153, 17)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")
	global $clearButton = GUICtrlCreateButton("Clear", 376, 133, 75, 25)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")
	;~ $Combo1 = GUICtrlCreateCombo("", 176, 52, 49, 25, $CBS_DROPDOWN)
	;~ GUICtrlSetFont(-1, 13, 400, 0, "consolas")
	global $labelTab2 = GUICtrlCreateLabel("Set party member", 24, 56, 148, 24)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")

	;~ TabSheet 3
	global $TabSheet3 = GUICtrlCreateTabItem("Help")
	GUICtrlCreateTabItem("")
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
endfunc

func loadSettings()
	local $startSetting = control('start')
	local $ticketSetting = control('ticket')
	local $retrySetting = control('retry')
	
	if $startSetting == 1 then
		IniWrite($config, "DefaultConfig", "start", 0)
	endif
	if $ticketSetting == 1 then GUICtrlSetState($ticketCheckbox, $GUI_CHECKED)
	if $retrySetting == 1 then GUICtrlSetState($retryCheckbox, $GUI_CHECKED)
endfunc

func guiEvent($msg, $boolean)
		switch ($msg)
			case $msg == 'start'
				if $boolean == true then
					IniWrite($config, "DefaultConfig", "start", 1)
				else
					IniWrite($config, "DefaultConfig", "start", 0)	
				endif

			case $msg == 'ticket'
				if $boolean == true then
					IniWrite($config, "DefaultConfig", "ticket", 1)
				else
					IniWrite($config, "DefaultConfig", "ticket", 0)
				endif

			case $msg == 'retry'
				if $boolean == true then
					IniWrite($config, "DefaultConfig", "retry", 1)
				else
					IniWrite($config, "DefaultConfig", "retry", 0)
				endif
		endswitch
endfunc

;~ Control
func control($command)
	Local $loadConf = IniRead($config,"DefaultConfig", $command, "")

	if $loadConf == 1 then
		$order = 1
	else
		$order = 0
	endif
	return $order
endfunc

