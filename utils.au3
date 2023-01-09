Func targetClick($check, $position, $addition)
	Local $savePos = MouseGetPos()

	If $check == 1 Then
		BlockInput(1)
		WinActivate($win)
		click($position[0],  $position[1]+$addition)
		send("{ALT DOWN}")
		Sleep(125)
		send("{TAB}")
		Sleep(125)
		send("{ALT UP}")
		MouseMove($savePos[0], $savePos[1], 1)
		BlockInput(0)
	EndIf
EndFunc

Func targetClickForMember()
	BlockInput(1)
	WinActivate($win)
	click(175, 314)
	click(373, 314)
	click(569, 317)
	click(764, 316)
	send("{ALT DOWN}")
	Sleep(125)
	send("{TAB}")
	Sleep(125)
	send("{ALT UP}")
	BlockInput(0)
EndFunc

Func click($positionX, $positionY)
	BlockInput(1)
	MouseMove($positionX, $positionY, 1)
	Sleep(50)
	MouseClick("left")
	Sleep(125)
	BlockInput(0)
EndFunc

Func color($position, $color, $addition=0)
	FFSnapShot(0, 0, 0, 0, 1, $win)
	$colorCode = Hex(FFGetPixel($position, 1))
	$trimCode = StringTrimLeft($colorCode, 2)
	$targetCode =  "0x"&$trimCode

	If $targetCode == $color Then
		If $addition == 'member' Then
			targetClickForMember()
		Else
			targetClick(1, $position, $addition)
		EndIf
	Else
		Return 0
	EndIf
EndFunc

Func onExit()
	MsgBox($MB_SYSTEMMODAL, "Alert", "Exit Macro.", 10)
	Exit
EndFunc