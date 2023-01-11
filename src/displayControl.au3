func loadDisplay()
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
	global $testButton = GUICtrlCreateCheckbox("On", 24, 141, 75, 25, $BS_PUSHLIKE)
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


func onTest()
	MsgBox($MB_SYSTEMMODAL, "alert test", "test", 10)
endfunc

func loadConfig()
	global $config = @ScriptDir & "\config.ini"
	global $ticketConfig = IniRead($config,"DefaultConfig", "ticket", "")
	global $retryConfig = IniRead($config,"DefaultConfig", "retry", "")

	if $ticketConfig == 1 then
		GUICtrlSetState($ticketCheckbox, $GUI_CHECKED)
	else
		GUICtrlSetState($ticketCheckbox, $GUI_UNCHECKED)
		IniWrite($config, "DefaultConfig", "ticket", 0)
	endif

	if $retryConfig == 1 then
		GUICtrlSetState($retryCheckbox, $GUI_CHECKED)
	else
		GUICtrlSetState($retryCheckbox, $GUI_UNCHECKED)
		IniWrite($config, "DefaultConfig", "retry", 0)
	endif
endfunc

func display()
	while 1
		$gMsg = GUIGetMsg()
		
		switch $gMsg
			case $GUI_EVENT_CLOSE
				exitloop

			case $startButton
				while (1)
					switch GUICtrlRead($startButton)
						case $GUI_CHECKED
							GUICtrlSetData($startButton, "Pause")
							isRunning()
							Sleep(500)
						case else
							GUICtrlSetData($startButton, "Start")
							exitloop
					endswitch
				wend

			case $testButton
				switch GUICtrlRead($testButton)
					case $GUI_CHECKED
						GUICtrlSetData($testButton, "Off")
					case else
						GUICtrlSetData($testButton, "On")
				endswitch

			case $ticketCheckbox
				switch GUICtrlRead($ticketCheckbox)
					case $GUI_CHECKED
						IniWrite($config, "DefaultConfig", "ticket", 1)
						$ticketConfig = 1
					case else
						IniWrite($config, "DefaultConfig", "ticket", 0)
						$ticketConfig = 0
				endswitch

			case $retryCheckbox
				switch GUICtrlRead($retryCheckbox)
					case $GUI_CHECKED
						IniWrite($config, "DefaultConfig", "retry", 1)
					case else
						IniWrite($config, "DefaultConfig", "retry", 0)
				endswitch

			case $clearButton
				if $clearButton then
					IniWrite($config, "DefaultConfig", "ticket", 0)
					IniWrite($config, "DefaultConfig", "retry", 0)
					loadConfig()
				endif


		endswitch
	wend

	GUIDelete($gMsg)

endfunc