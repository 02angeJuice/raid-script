func targetClick($check, $position, $addX, $addY)
	local $savePos = MouseGetPos()

	if $check == 1 then
		BlockInput(1)
		WinActivate($win)
		click($position[0] + $addX,  $position[1] + $addY)
		Send("{ALT DOWN}")
		Sleep(125)
		Send("{TAB}")
		Sleep(125)
		Send("{ALT UP}")
		MouseMove($savePos[0], $savePos[1], 1)
		BlockInput(0)
	endif
endfunc

func targetClickForMember()
	BlockInput(1)
	WinActivate($win)
	click(175, 315)
	click(375, 315)
	click(570, 315)
	click(765, 315)
	Send("{ALT DOWN}")
	Sleep(125)
	Send("{TAB}")
	Sleep(125)
	Send("{ALT UP}")
	BlockInput(0)
endfunc

func click($positionX, $positionY)
	BlockInput(1)
	MouseMove($positionX, $positionY, 1)
	Sleep(50)
	MouseClick("left")
	Sleep(125)
	BlockInput(0)
endfunc

func color($position, $color, $addX = 0, $addY = 0, $optional ="", $msg ='')
	FFSnapShot(0, 0, 0, 0, 1, $win)
	$colorCode = Hex(FFGetPixel($position, 1))
	$trimCode = StringTrimLeft($colorCode, 2)
	$targetCode =  "0x"&$trimCode

	if $targetCode == $color then
		if $optional == 'member' then
			appendLog($msg & " '" & $color & "' [" & $position[0] & ',' & $position[1] & ']')
			ConsoleWrite($msg & " '" & $color & "' [" & $position[0] & ',' & $position[1] & ']' & @CRLF)
			targetClickForMember()
		else
			appendLog($msg & " '" & $color & "' [" & $position[0] & ',' & $position[1] & ']')
			ConsoleWrite($msg & " '" & $color & "' [" & $position[0] & ',' & $position[1] & ']' & @CRLF)
			targetClick(1, $position, $addX, $addY)
		endif
	else
		return 0
	endif
endfunc

func setWindowSize()
	WinActivate($win)
	$pos = WinGetPos($win)
	$newX = (@DesktopWidth - $pos[2]) / 2
	$newY = (@DesktopHeight - $pos[3]) / 2

	if $pos[2] <> 960 and $pos[3] <> 540 then
		WinMove($win, '', $newX, $newY, 960, 540)
	endif

	appendLog('load setWindowSize() successful.')
	ConsoleWrite("load setWindowSize() successful." & @CRLF)
endfunc

func onExit()
	$set = WinGetPos("")
	IniWrite($config, 'Settings', 'setX', $set[0])
	IniWrite($config, 'Settings', 'setY', $set[1])
	appendLog("set window position [" & $set[0] & ',' & $set[1] & "]" )
	appendLog("app exit")
	MsgBox(0, "Alert", "Exit Macro.", 10)
	exit
endfunc

func appendLog($msg)
	_GUICtrlEdit_AppendText($Edit1, $msg & '' & @CRLF)
	_FileWriteLog(@ScriptDir & "\message.log", $msg)
endfunc