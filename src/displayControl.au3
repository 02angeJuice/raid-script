func sizeGUI($set)
	local $pos[2]
	local $x = IniRead($config, "Settings", "gui-x", "")
	local $y = IniRead($config, "Settings", "gui-y", "")

	if $x < 0 or $y < 0 then
		$pos[0] = @DesktopWidth/2
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
	global $dailyButton = GUICtrlCreateCheckbox("Daily", 24, 77, 75, 25, $BS_PUSHLIKE)
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
	global $ticketCheckbox = GUICtrlCreateCheckbox("Ticket", 28, 111, 150, 17)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")
	global $retryCheckbox = GUICtrlCreateCheckbox("Retry", 28, 141, 153, 17)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")
	global $clearButton = GUICtrlCreateButton("Clear", 376, 133, 75, 25)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")

	global $arenaCheckbox = GUICtrlCreateCheckbox("Arena", 184, 53, 97, 25)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")
	$shopCheckbox = GUICtrlCreateCheckbox("Shop", 184, 80, 97, 25)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")
	$towerCheckbox = GUICtrlCreateCheckbox("Tower", 184, 108, 97, 25)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")
	$guildCheckbox = GUICtrlCreateCheckbox("Guild", 288, 53, 97, 25)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")
	$friendsCheckbox = GUICtrlCreateCheckbox("Friends", 288, 80, 97, 25)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")

	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	appendLog('load loadGUI() successful.')
	ConsoleWrite("load loadGUI() successful." & @CRLF)
endfunc

func loadSettings()
	setWindowSize()

	local $dailySetting = rConfig('daily', 'Default')
	local $startSetting = rConfig('start', 'Default')
	local $ticketSetting = rConfig('ticket', 'Default')
	local $retrySetting = rConfig('retry', 'Default')
	local $arenaSetting = rConfig('arena', 'DailyArena')
	
	if $dailySetting == 1 then
		IniWrite($config, "Default", "daily", 0)
	endif
	if $startSetting == 1 then
		IniWrite($config, "Default", "start", 0)
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

	if $arenaSetting == 1 then
		GUICtrlSetState($arenaCheckbox, $GUI_CHECKED)
		appendLog('set arena - enable')
		ConsoleWrite("set arena - enable" & @CRLF)
	endif
endfunc

func guiEvent($msg, $boolean, $message='')
		switch ($msg)
			case $msg == 'daily'
				if $boolean == true then
					appendLog($message)
					ConsoleWrite($message & @CRLF)
					IniWrite($config, "Default", "daily", 1)
				else
					appendLog($message)
					ConsoleWrite($message & @CRLF)
					IniWrite($config, "Default", "daily", 0)
				endif

			case $msg == 'start'
				if $boolean == true then
					appendLog($message)
					ConsoleWrite($message & @CRLF)
					IniWrite($config, "Default", "start", 1)
				else
					appendLog($message)
					ConsoleWrite($message & @CRLF)
					IniWrite($config, "Default", "start", 0)
				endif

			case $msg == 'ticket'
				if $boolean == true then
					appendLog($message)
					ConsoleWrite($message & @CRLF)
					IniWrite($config, "Default", "ticket", 1)
				else
					appendLog($message)
					ConsoleWrite($message & @CRLF)
					IniWrite($config, "Default", "ticket", 0)
				endif

			case $msg == 'retry'
				if $boolean == true then
					appendLog($message)
					ConsoleWrite($message & @CRLF)
					IniWrite($config, "Default", "retry", 1)
				else
					appendLog($message)
					ConsoleWrite($message & @CRLF)
					IniWrite($config, "Default", "retry", 0)
				endif

			case $msg == 'arena'
				if $boolean == true then
					appendLog($message)
					ConsoleWrite($message & @CRLF)
					IniWrite($config, "Daily", "arena", 1)
				else
					appendLog($message)
					ConsoleWrite($message & @CRLF)
					IniWrite($config, "Daily", "arena", 0)
				endif
		endswitch
endfunc

;~ config
func rConfig($command, $section)
	local $read = IniRead($config, $section, $command, "")
	if $read == 1 then
		$order = 1
	else
		$order = 0
	endif
	return $order
endfunc

func wConfig($command, $section, $value=1)
	IniWrite($config, $section, $command, $value)
	rConfig($command, $section)
endfunc



