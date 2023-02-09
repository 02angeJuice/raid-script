#requireAdmin
#pragma compile(Icon, icon/Mai4_Icon.ico)
#include <processing.au3>
#include <WinAPI.au3>
#include <Date.au3>
#include <Array.au3>
#include <GUIConstantsEx.au3>

global $gName = 'Seven Knights 2'
global $hWND = WinGetHandle($gName)
global $paused = false
global $isGoing = false
global $gTimer, $gSec, $gMin, $gHour, $gTime
global $count = 0
global $arrPlay[4] = ['🟡 🔹 🔹', '🔹 🟡 🔹', '🔹 🔹 🟡', '🔹 🔹 🔹']
global $arrIdle[3] = ['🟡  HOME : play & pause ', '🟡  END : exit ', '🟡  F5 : resize window ']

#include <src/pixelPoints.au3>

Opt("MouseCoordMode", 2)
HotKeySet("{END}", "onExit")
HotKeySet("{HOME}", "onGo")
HotKeySet("{F5}", "setWindowSize")

setWindowSize()
$gTimer = TimerInit()
AdlibRegister("titleUpdate", 250)

while 1
wend

func onGo()
	$paused = not $paused
	if $paused == true then
		setWindowSize()
		WinSetTitle($hWND, "", $gName&' '&'🔅 on')
		$isGoing = true
		AdlibRegister("findColors", 250)
	else
		WinSetTitle($hWND, "", $gName&' '&'🔅 off')
		$isGoing = false
		AdlibUnRegister("findColors")
	endif
endfunc

func findColors()
	color($member, $memberColor, 0, 0, 'member', 'active ready')
	color($start, $startColor, 0, 20, "", 'active start')
	color($ticket, $ticketColor, 0, 0, "", 'active ticket')
	color($retry, $retryColor, 0, 72, "", 'active retry')
endfunc

func titleUpdate()
	_TicksToTime(Int(TimerDiff($gTimer)), $gHour, $gMin, $gSec)
	local $sTime = $gTime
	local $gTime = timeFormat($gHour, $gMin, $gSec)

	if $sTime <> $gTime then
		local $titlAdd = $gTime

		if $isGoing <> true then
			if mod($gSec, 5) == 0 then
				WinSetTitle($hWND, "", $gName&' '&$arrIdle[1])
			else
				WinSetTitle($hWND, "", $gName&' '&$arrIdle[0]&' '&$arrIdle[2])
			endif
		else
			WinSetTitle($hWND, "", $gName&' '&$arrPlay[$count])
			$count += 1

			if $count == UBound($arrPlay) then
				$count = 0
			endif

		endif
	endif
endfunc

func timeFormat($h, $m, $s)
	if $h == 0 and $m == 0 then
		return StringFormat("%i", $s)
	elseif $h == 0 and $m <> 0 then
		return StringFormat("%i:%i", $m, $s)
	else
		return StringFormat("%i:%i:%i", $h, $m, $s)
	endif
endfunc

func color($position, $color, $addX = 0, $addY = 0, $optional ="", $msg ='')
	FFSnapShot(0, 0, 0, 0, 1, $hWND)
	$colorCode = Hex(FFGetPixel($position, 1))
	$trimCode = StringTrimLeft($colorCode, 2)
	$targetCode =  "0x"&$trimCode

	if $targetCode == $color then
		if $optional == 'member' then
			targetClickForMember()
		else
			targetClick(1, $position, $addX, $addY)
		endif
		return 1
	else
		return 0
	endif
endfunc

func targetClick($check, $position, $addX, $addY)
	local $savePos = MouseGetPos()

	if $check == 1 then
		BlockInput(1)
		WinActivate($hWND)
		click($position[0] + $addX,  $position[1] + $addY)
		altTab()
		MouseMove($savePos[0], $savePos[1], 1)
		BlockInput(0)
	endif
endfunc

func targetClickForMember()
	BlockInput(1)
	WinActivate($hWND)
	click(175, 315)
	click(375, 315)
	click(570, 315)
	click(765, 315)
	altTab()
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

func altTab()
	Send("{ALT DOWN}")
	Sleep(125)
	Send("{TAB}")
	Sleep(125)
	Send("{ALT UP}")
endfunc

func setWindowSize()
	WinActivate($hWND)
	$pos = WinGetPos($hWND)
	$newX = (@DesktopWidth - $pos[2]) / 2
	$newY = (@DesktopHeight - $pos[3]) / 2

	if $pos[2] <> 960 or $pos[3] <> 540 then
		WinMove($hWND, '', $newX, $newY, 960, 540)
	endif
	WinActivate($hWND)
endfunc

func onExit()
	$gName = 'Seven Knights 2'
	WinSetTitle($hWND, "", $gName)
	MsgBox(0, "Exit", "The app is shutting down.", .5)
	exit
endfunc