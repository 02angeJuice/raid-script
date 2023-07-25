#requireAdmin
#pragma compile(Icon, ./src/icon.ico)
#include <./src/image-process.au3>
#include <WinAPI.au3>
#include <Date.au3>
#include <Array.au3>
#include <GUIConstantsEx.au3>
#Include <StaticConstants.au3>
#Include <WindowsConstants.au3>

#include "./src/animate.au3"

global $gName = 'Seven Knights 2', $hWND = WinGetHandle($gName)
global $paused = false, $titlePaused = false
global $gTimer, $gSec, $gMin, $gHour, $gTime
global $count = 0
global $arrPlay[16] = ['🔸 🔸 🔸', '🟡 🔸 🔸', '🟡 🟡 🔸', '🟡 🟡 🟡', '🔸 🔸 🔸', '🟨 🔸 🔸', '🟨 🟨 🔸', '🟨 🟨 🟨', '🔸 🔸 🔸', '⚙️ 🔸 🔸', '⚙️ ⚙️ 🔸', '⚙️ ⚙️ ⚙️', '🔸 🔸 🔸', '❤️ 🔸 🔸', '❤️ ❤️ 🔸', '❤️ ❤️ ❤️']
global $arrIdle[3] = ['🟡  HOME : play & pause ', '🟡  END : exit ', '🟡  F5 : resize window ']

; raid party's lobby
global $start = [835, 459], $startColor = '0xFCFCFD'
global $member = [773, 461], $memberColor = '0xFBFBFC'

; raid party select
global $ticket = [386, 343], $ticketColor = '0x121622'
global $retry = [713, 254], $retryColor = '0xDC9598'
global $issue = [471, 150], $issueColor = '0x383D46'

Opt('MustDeclareVars', 1)
Opt('TrayAutoPause', 0)

Opt("MouseCoordMode", 2)

HotKeySet("{END}", "onExit")
HotKeySet("{HOME}", "togglePlay")
HotKeySet("{F5}", "setWindowSize")

setWindowSize()
trayAnimate('gear','on', 40)

$gTimer = TimerInit()
AdlibRegister("fetchTitle", 1000)

while Sleep(1500)
	if $paused <> true then
		TraySetIcon("./src/icon.ico")
		_Animate_Stop()
		$titlePaused = false
	else
		_Animate_Start("", 1)
		$titlePaused = true

		color($member, $memberColor, 0, 0, 'member', 'active ready')
		color($start, $startColor, 0, 20, "", 'active start')
		color($ticket, $ticketColor, 0, 0, "", 'active ticket')
		color($retry, $retryColor, 0, 72, "", 'active retry')
		color($issue, $issueColor, 0, 190, "", 'active issue')
	endif
wend

func togglePlay()
	$paused = not $paused
	if $paused <> true then
		WinSetTitle($hWND, "", $gName&' '&'🔅 off')
	else
		WinSetTitle($hWND, "", $gName&' '&'🔅 on')
	endif
	return $paused
endfunc

func trayAnimate($name, $order, $frames=0)
	local $n = '\' & $name & '\' & $name & '-'
	if $order == 'on' then
		For $i = 0 To $frames
			_Animate_AddIcon('./src'& $n & $i & '.ico', 0)
		Next
		return 1
	else
		return 0
	endif
endfunc

func fetchTitle()
	_TicksToTime(Int(TimerDiff($gTimer)), $gHour, $gMin, $gSec)
	local $sTime = $gTime
	local $gTime = timeFormat($gHour, $gMin, $gSec)

	if $sTime <> $gTime then
		local $titlAdd = $gTime

		if $titlePaused <> true then
			WinSetTitle($hWND, "", $gName&' '&$arrIdle[0]&' '&$arrIdle[2]&' '&$arrIdle[1])
		else
			WinSetTitle($hWND, "", $gName&' '&$arrPlay[$count])
			$count += 1

			if $count == UBound($arrPlay) then	;~ $count == $arrPlay.length
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
	local $colorCode = Hex(FFGetPixel($position, 1))
	local $trimCode = StringTrimLeft($colorCode, 2)
	local $targetCode =  "0x"&$trimCode

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
	local $pos = WinGetPos($hWND)
	if UBound($pos) <> 0 then
		local $newX = (@DesktopWidth - $pos[2]) / 2
		local $newY = (@DesktopHeight - $pos[3]) / 2

		if $pos[2] <> 960 or $pos[3] <> 540 then
			WinMove($hWND, '', $newX, $newY, 960, 540)
		endif

		WinActivate($hWND)
	endif
endfunc

func onExit()
	AdlibUnRegister("fetchTitle")
	$gName = 'Seven Knights 2'
	WinSetTitle($hWND, "", $gName)
	MsgBox(0, "Exit", "The app is shutting down.", .5)
	exit
endfunc