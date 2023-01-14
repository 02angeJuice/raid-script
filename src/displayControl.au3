func sizeGUI($set)
	local $pos[2]
	local $x = IniRead($config, "Settings", "setX", "")
	local $y = IniRead($config, "Settings", "setY", "")

	if $x < 0 or $y < 0 then
		$pos[0] = @DesktopWidth/ 2
		$pos[1] = @DesktopHeight/2
	else
		$pos[0] = $x
		$pos[1] = $y
	endif
	if $set == 'x' then
		return $pos[0] 
	else
		return $pos[1] 
	endif
endfunc

func loadGUI()
	#Region ### START Koda GUI section ### Form=c:\users\b0\desktop\raid_script_gui\raid-script-form.kxf
	GUICreate("RaidScript", 471, 184, sizeGUI('x'), sizeGUI('y'), $GUI_SS_DEFAULT_GUI)

	GUISetFont(8, 400, 0, "consolas")
	global $Tab1 = GUICtrlCreateTab(8, 8, 457, 169, $TCS_FIXEDWIDTH)
	GUICtrlSetFont(-1, 12, 400, 0, "consolas")

	;~ TabSheet 1
	global $TabSheet1 = GUICtrlCreateTabItem("Main")
	global $windowButton = GUICtrlCreateButton("Window", 24, 45, 75, 25)
	GUICtrlSetFont(-1, 13, 800, 0, "consolas")
	GUICtrlSetColor(-1, 0x99B4D1)
	global $dailyButton = GUICtrlCreateButton("Daily", 24, 77, 75, 25)
	GUICtrlSetFont(-1, 13, 800, 0, "consolas")
	GUICtrlSetColor(-1, 0x99B4D1)
	global $startButton = GUICtrlCreateCheckbox("Start", 24, 109, 75, 25, $BS_PUSHLIKE)
	GUICtrlSetFont(-1, 13, 800, 0, "consolas")
	GUICtrlSetColor(-1, 0x99B4D1)
	global $exitButton = GUICtrlCreateButton("Exit", 24, 141, 75, 25)
	GUICtrlSetFont(-1, 13, 800, 0, "consolas")
	GUICtrlSetColor(-1, 0x99B4D1)
	global $Edit1 = GUICtrlCreateEdit("", 115, 45, 345, 120,BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN,$WS_VSCROLL), 0)
	GUICtrlSetData(-1, '')
	GUICtrlSetFont(-1, 10, 400, 0, "consolas")

	;~ TabSheet 2
	global $TabSheet2 = GUICtrlCreateTabItem("Settings")
	global $ticketCheckbox = GUICtrlCreateCheckbox("Re-enter ticket", 28, 111, 150, 17)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")
	global $retryCheckbox = GUICtrlCreateCheckbox("Retry (Failed)", 28, 141, 153, 17)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")
	global $clearButton = GUICtrlCreateButton("Clear", 376, 133, 75, 25)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")

	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	appendLog('load loadGUI() successful.')
	ConsoleWrite("load loadGUI() successful." & @CRLF)
endfunc

func loadSettings()
	setWindowSize()

	local $startSetting = control('start')
	local $ticketSetting = control('ticket')
	local $retrySetting = control('retry')
	
	if $startSetting == 1 then
		IniWrite($config, "DefaultConfig", "start", 0)
	endif
	if $ticketSetting == 1 then
		GUICtrlSetState($ticketCheckbox, $GUI_CHECKED)
		appendLog('set ticket - enable')
		ConsoleWrite("set ticket - enable" & @CRLF)
	endif
	if $retrySetting == 1 then
		GUICtrlSetState($retryCheckbox, $GUI_CHECKED)
		appendLog('set retry - enable')
		ConsoleWrite("set retry - enable" & @CRLF)
	endif
endfunc

func guiEvent($msg, $boolean, $message='')
		switch ($msg)
			case $msg == 'start'
				if $boolean == true then
					appendLog($message)
					ConsoleWrite($message & @CRLF)
					IniWrite($config, "DefaultConfig", "start", 1)
				else
					appendLog($message)
					ConsoleWrite($message & @CRLF)
					IniWrite($config, "DefaultConfig", "start", 0)
				endif

			case $msg == 'ticket'
				if $boolean == true then
					appendLog($message)
					ConsoleWrite($message & @CRLF)
					IniWrite($config, "DefaultConfig", "ticket", 1)
				else
					appendLog($message)
					ConsoleWrite($message & @CRLF)
					IniWrite($config, "DefaultConfig", "ticket", 0)
				endif

			case $msg == 'retry'
				if $boolean == true then
					appendLog($message)
					ConsoleWrite($message & @CRLF)
					IniWrite($config, "DefaultConfig", "retry", 1)
				else
					appendLog($message)
					ConsoleWrite($message & @CRLF)
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



