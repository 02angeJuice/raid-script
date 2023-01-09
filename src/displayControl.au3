func loadDisplay()
	#Region ### START Koda GUI section ### Form=c:\users\b0\desktop\raid_script_gui\raid-script-form.kxf
	global $Form1_1 = GUICreate("Raid Script", 471, 184, 310, 209, $GUI_SS_DEFAULT_GUI)
	GUISetFont(8, 400, 0, "consolas")
	global $Tab1 = GUICtrlCreateTab(8, 8, 457, 169, $TCS_FIXEDWIDTH)
	GUICtrlSetFont(-1, 12, 400, 0, "consolas")
	global $TabSheet1 = GUICtrlCreateTabItem("Main")
	global $startButton = GUICtrlCreateButton("Start", 24, 109, 75, 25)
	GUICtrlSetFont(-1, 13, 800, 0, "consolas")
	GUICtrlSetColor(-1, 0x99B4D1)
	global $Button2 = GUICtrlCreateButton("Clear", 24, 141, 75, 25)
	GUICtrlSetFont(-1, 13, 800, 0, "consolas")
	GUICtrlSetColor(-1, 0x99B4D1)
	;~ global $Edit1 = GUICtrlCreateEdit("", 120, 69, 345, 105, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN,$WS_VSCROLL), 0)
	;~ GUICtrlSetData(-1, "Edit1")
	;~ GUICtrlSetFont(-1, 10, 400, 0, "consolas")
	global $Label1 = GUICtrlCreateLabel("Log: ", 120, 45, 44, 22)
	GUICtrlSetFont(-1, 11, 400, 0, "consolas")
	global $TabSheet2 = GUICtrlCreateTabItem("Settings")
	global $Checkbox1 = GUICtrlCreateCheckbox("Re-enter", 28, 111, 97, 17)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")
	global $Checkbox2 = GUICtrlCreateCheckbox("Retry (Failed)", 28, 141, 153, 17)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")
	global $Button3 = GUICtrlCreateButton("Clear", 376, 133, 75, 25)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")
	;~ $Combo1 = GUICtrlCreateCombo("", 176, 52, 49, 25, $CBS_DROPDOWN)
	;~ GUICtrlSetFont(-1, 13, 400, 0, "consolas")
	global $Label2 = GUICtrlCreateLabel("Set party member", 24, 56, 148, 24)
	GUICtrlSetFont(-1, 13, 400, 0, "consolas")
	global $TabSheet3 = GUICtrlCreateTabItem("Help")
	GUICtrlCreateTabItem("")
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
endfunc


func onTest()
	MsgBox($MB_SYSTEMMODAL, "alert test", "test", 10)
endfunc