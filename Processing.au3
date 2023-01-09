#cs ----------------------------------------------------------------------------
 FastFind Version: 2.2
 Author:         	FastFrench
 Some Wrappers:		frank10
 AutoIt Version: 3.3.8.1

 Script function:
	All FastFind.dll wrapper functions.
    This dll provides optimized screen processing. All actions implies at least 2 dll calls : one to copy the screen data into memory, and a second to make specific action.
	This way, you can make several actions even faster when they apply to the same screen data.

 functions exported in FastFind.dll 1.8 are :

   	SnapShot (Makes captures of the screen, a Window - partial or full - into memory, required before using any of the following.)

	ColorPixelSearch (Search the closest pixel with a given color)
	ColorCount (Count how many pixels with a given color exist in the SnapShot.)

	HasChanged (Says if two snapshots are exactly the same or not. Usefull to check if some changes occured in a given area. )
	LocalizeChanges (Same has HasChanged, but returns precisely the smallest rectangle that includes all the changes, and the number of pixels that are different).

	GetPixel (Gives the color of a pixel in the SnapShot. Much faster than PixelGetColor if you use this a lot.)

	AddColor
	RemoveColor (Those 3 functions allow management of a list of colors, instead of using only one)
	ResetColors (Tou can have up to 1024 colors active in the list)

	AddExcludedArea (Those functions add exceptions in the processing of screen areas, with rectangles that are ignored)
	ResetExcludedAreas (You can have up to 1024 areas in the list)
	IsExcluded

	ColorsSearch (Close to ColorSearch, except that instead of a single color, all colors of the current list are in use)
	ColorsPixelSearch (Similar to ColorPixelSearch, except that instead of a single color, all colors of the current list are in use)

	ColorSearch (it's the most versatile and powerful function (in 1.3) : you can, at the same time, check for as many colors as you want,
	             with possibly a "ShadeVariation",  multiple subareas to ignore... will Find the closest spot with a all specified criteria.
				 The spot is a square area of NxN pixels with at least P pixels that are as close as allowed by ShadeVariation
				 from any of the colors in the list).

	ProgressiveSearch (new with 1.4 : similar to ColorSearch, except that if the "ideal" spot can't be found, can still search for the best spot available).

	GetLastErrorMsg
	FFVersion

	-- New in version 1.6
	SaveBMP
	SaveJPG
	GetLastFileSuffix

	KeepChanges
	KeepColor

	-- New in version 1.7
	DrawSnapShot
	FFSetPixel

	DuplicateSnapShot
	GetRawData

	-- New in version 2.0

	function with an additionnal parameter (ShadeVariation) :
	KeepChanges
	LocalizeChanges
	HasChanged

	New functions :
	DrawSnapShotXY (same as DrawSnapShot, with specific top-left position for drawing).
	ComputeMeanValues (Gives mean Red, Green and Blue values)
	ApplyFilterOnSnapShot (apply a AND filter on each pixels in the SnapShot)
	FFGetRawData (gets direct access to all pixel data of a ScreenShot)

	Bug fix :
	FFColorCount with ShadeVariation

	-- 2.2

	Detects more error patterns (wrong coordinates)

#ce ----------------------------------------------------------------------------

; User global variables (can be changes by user)
global $FFDefaultSnapShot = 0 	 ; Default SnapShot Nb


global $FFDefautDebugMode = 00 ; Si below to the meaning of this value. To remove all debug features (file traces, graphical feedback..., use 0 here)


; System global variables ** do not change them **
global $FFDllHandle = -1
global $FFLastSnap = 0
global const $FFNbSnapMax = 1024
global $FFLastSnapStatus[$FFNbSnapMax] ; array used to automatically make a SnapShot when needed

global const $FFCurrentVersion="2.2"

InitFFDll()



; Loading the the dll and initialisation of the wrapper
; -----------------------------------------------------
func InitFFDll()
	for $i = 0 To $FFNbSnapMax-1
		$FFLastSnapStatus[$i] = 0
		next
	if @AutoItX64 then
		global $DllName = "pixel-processing-x64.dll"
	else
		global $DllName = "pixel-processing.dll"
	endif
		$FFDllHandle = DllOpen($DllName)
	if $FFDllHandle=-1 then
		$FFDllHandle=$DllName
		MsgBox(0,"Error","Failed to load "&$DllName&", application probably won't properly work. "&@LF&"Check if the file "&$DllName&"is installed near this script")
		exit(100)
		return
	endif
	if ($FFCurrentVersion<>FFGetVersion()) then
		MsgBox(0, "Error", "Wrong version of "&$DllName&". The dll is version "&FFGetVersion()&" while version "&$FFCurrentVersion&" is required.");
		Exit(101)
		endif
	FFSetDebugMode($FFDefautDebugMode)
endfunc

func CloseFFDll()
	if $FFDllHandle<>-1 then DllClose($FFDllHandle)
endfunc

; Determines the debugging mode.
; ------------------------------------------------- --------------------
; The 4 bits determine the channel debugging enabled, they have the following meanings:
; 0x00 = no debug
; 0x01 = Information sent to the console (RequireAdmin)
; 0x02 = debug information sent to a file (trace.txt)
; 0x04 = Graphic display of points / areas identified
; 0x08 = Display MessageBox (blocking)
; note that in case of error, a MessageBox is displayed in the DLL if DebugMode> 0

; The following 4 bits are used to filter based on the origin of the debug message
; 0x0010 / / Excludes internal traces of the DLL
; 0x0020 / / Excludes detailed internal traces of the DLL
; 0x0040 / / Excludes external traces (those of the application)
; 0x0080 / / Error message (priority)
;
; Errors (serious) are displayed on all available channels (file, console and MessageBox) if $ DebugMode> 0
;
; Proto C function: void SetDebugMode (int NewMode)
func FFSetDebugMode($DebugMode)
	DllCall($FFDllHandle, "none", "SetDebugMode", "int", $DebugMode)
endfunc

; The DLL also exposes its debugging functions, allowing the AutoIt application share same traces
func FFTrace($DebugString)
	DllCall($FFDllHandle, "none", "DebugTrace", "str", $DebugString)
endfunc


; This function allows you to handle errors (the text appears in the logfile, the console and a MessageBox if $ DebugMode> 0)
func FFTraceError($DebugString)
	DllCall($FFDllHandle, "none", "DebugError", "str", $DebugString)
endfunc


; Sets the current window to use
; -----------------------------------
; By default, the entire screen is used. You can select a particular window. By default, we will always use the last Window set.
; if $WindowsHandle = 0, the entire screen : GetDesktopWindow ()
; if ClientOnly = true, then only the client part of the Window will be capturable, and coordinates will be relative to top-left
; corner of the client area (client area is the full Window except title bar, possibly menu area, borders...)
; if ClientOnly = false, then the full Window will be used.
;
; Proto C function: void SetHWnd(HWND NewWindowHandle, bool bClientArea);
func FFSetWnd($WindowHandle, $ClientOnly=true)
	DllCall($FFDllHandle, "none", "SetHWnd", "HWND", $WindowHandle, "BOOLEAN", $ClientOnly)
endfunc


; Choose the Default SnapShot that will by used in the next operations. This avoid to specify the number of the SnapShot every time when you always work on the same
func FFSetDefaultSnapShot($NewSnapShot)
	$FFDefaultSnapShot = $NewSnapShot
endfunc

; Managing the list of colors
; ================================
; When a parameter is proposed Dane Color function, the value -1 means that all colors in the list are taken into account

; Add one or more colors in the list maintained by FastFind
; Proto C function: int addColor (int newColor)
func FFAddColor(const $NewColor)
	local $res
	if (IsArray($NewColor)) then
		for $Color In $NewColor
			$res = DllCall($FFDllHandle, "int", "AddColor", "int", $Color)
		next
	Else
		$res = DllCall($FFDllHandle, "int", "AddColor", "int", $NewColor)
	endif
	if IsArray($res) then return $res[0]
	return $res
endfunc

; Remove a color (if any) from the list of colors
;
; Proto C function: int RemoveColor (int newColor)
func FFRemoveColor(const $OldColor)
	local $res = DllCall($FFDllHandle, "int", "RemoveColor", "int", $OldColor)
	if IsArray($res) then return $res[0]
	return $res
endfunc

; Totally Empty the list of colors
;
; Proto C function: int ResetColors ()
func FFResetColors()
	DllCall($FFDllHandle, "none", "ResetColors")
endfunc


; Exclusion areas management
; ==========================
; Exclusion zones can restrict searches with all functions
; Search
; It is possible to have up to 1024 rectangles of exclusion, thereby removing precisely
; Any search area. for example, with flash, the mouse cursor will usually appears on the snapshots
; (unlike cursors managed by Windows API). You can use an Exclusion rectangle established according to the position
; of the mouse so the cursor does not affect the Search results.
;
; Adds an exclusion zone
;
; Proto C function: void WINAPI AddExcludedArea (int x1, int y1, int x2, int y2)
func FFAddExcludedArea(const $x1, const $y1, const $x2, const $y2)
	local $Res = DllCall($FFDllHandle, "int", "AddExcludedArea", "int", $x1, "int", $y1, "int", $x2, "int", $y2)
	if IsArray($res) then return $res[0]
	return $res
endfunc

; Clears the list of all zones
;
; Proto C function: void WINAPI ResetExcludedAreas()
func FFResetExcludedAreas()
	DllCall($FFDllHandle, "none", "ResetExcludedAreas")
endfunc

; Through the list of exclusion zones to determine if the point passed as a parameter is excluded or not.
;
; Proto C function: bool WINAPI IsExcluded(int x, int y, HWND hWnd)
func FFIsExcluded(const $x, const $y, const $hWnd)
	local $Res = DllCall($FFDllHandle, "BOOLEAN", "IsExcluded", "int", $x, "int", $y, "HWND", $hWnd)
	if IsArray($res) then return $res[0]
	return $res
endfunc


; FFSnapShot function - This function allows you to make a copy of the screen, window or only a part in memory
; - All other functions of FF running from memory, it should first run FFSnapShot (either explicitly or implicitly as designed within this wrapper)
; It is possible to perform several different catches and work on any thereafter.
;
; Input:
; The area to capture (in coordinates relative to the boundaries of the window if a window handle nonzero indicated) [optional, the entire screen by default]
; if the area indicated is 0,0,0,0 then this is the entire window (or screen) to be captured
; The ID to use SnapShot (optional, default to the last used, 0 initially)
; And a window handle [optional, the same screen as the previous time by default. Initially, the entire screen.]
;
; Warning: Graphic data is stored in memory, the use of this feature consumes memory. It takes about 1.8 MB of RAM to capture 800x600.
; Therefore it should preferably always reuse the same No. SnapShot. Nevertheless, it is possible to store up to 1024 screens.
;
; return Values: if unsuccessful, returns 0 and sets @Error.
; if successful, returns 1
; Proto C function: int WINAPI SnapShot(int aLeft, int aTop, int aRight, int aBottom, int NoSnapShot)
func FFSnapShot(const $Left=0, const $Top=0, const $Right=0, const $Bottom=0, const $NoSnapShot=$FFDefaultSnapShot, const $WindowHandle=-1)
	if ($WindowHandle <> -1) then FFSetWnd($WindowHandle)
	$FFDefaultSnapShot = $NoSnapShot ; On m�morise le no du SnapShot utilis�, cela restera le SnapShop par d�faut pour les prochains appels
	local $Res = DllCall($FFDllHandle, "int", "SnapShot", "int", $Left, "int", $Top, "int", $Right, "int", $Bottom, "int", $NoSnapShot)
	if ( ((not IsArray($Res)) AND ($Res=0)) OR $Res[0]=0) then
		MsgBox(0, "FFSnapShot", "SnapShot ("&$Left&","&$Top&","&$Right&","&$Bottom&","&$NoSnapShot&","&Hex($WindowHandle,8)&") failed ")
		if (IsArray($Res)) then
			MsgBox(0, "FFSnapShot Error", "IsArray($Res):"&IsArray($Res)&" - Ubound($Res):"&UBound($Res)&" - $Res[0]:"&$Res[0])
		else
			MsgBox(0, "FFSnapShot Error", "IsArray($Res):"&IsArray($Res)&" - $Res:"&$Res)
		endif
		$FFLastSnapStatus[$NoSnapShot] = -1
		SetError(2)
		return false
	endif
	$FFLastSnapStatus[$NoSnapShot] = 1
	$FFLastSnap  = $NoSnapShot
	return true
endfunc


; Internal function, don't use it directly
func SnapShotPreProcessor($Left, $Top, $Right, $Bottom, $forceNewSnap, $NoSnapShot, $WindowHandle)
	; Si on impose une nouvelle capture ou si aucun SnapShot valide n'a d�j� �t� effectu� pour ce N�
	if ($forceNewSnap OR $FFLastSnapStatus[$NoSnapShot] <> 1) then return FFSnapShot($Left, $Top, $Right, $Bottom, $NoSnapShot, $WindowHandle)
	return true
endfunc

; FFNearestPixel function - This function works like PixelSearch, except that instead of returning the first pixel found,
; it returns the closest from a given position ($PosX,$PosY)
; return Values: if unsuccessful, returns 0 and sets @Error.
; if successful, an array of 2 elements:
;		[0] : X coordinate of the pixel found the nearest
; 		[1] : Y coordinate of the pixel
; Example: To find the pixel with color 0x00AB0C45 as close as possible from 500, 500 in full screen
;  $Res = FFNearestPixel(500, 500, 0x00AB0C45)
; if not @Error then MsgBox (0, "Resource", "Found in" & $PosX & "," & $PosY)
;
; Proto C function: int WINAPI ColorPixelSearch(int &XRef, int &YRef, int ColorToFind, int NoSnapShot)
func FFNearestPixel($PosX, $PosY, $Color, $forceNewSnap=true, $Left=0, $Top=0, $Right=0, $Bottom=0, $NoSnapShot=$FFLastSnap, $WindowHandle=-1)
 	;local $NoSnapShot = 2 ; Slot utilis� pour les captures d'�cran (entre 0 et 3), choisi arbitrairement
	if not SnapShotPreProcessor($Left, $Top, $Right, $Bottom, $forceNewSnap, $NoSnapShot, $WindowHandle) then
		SetError(2)
		return false
	endif
	local $Result = DllCall($FFDllHandle, "int", "ColorPixelSearch", "int*", $PosX, "int*",$PosY, "int", $Color, "int", $NoSnapShot)
	if ( not IsArray($Result) OR $Result[0]<>1) then
		SetError(1)
		return false
	endif
	local $CoordResult[2] = [$Result[1], $Result[2]] ; PosX, PosY
	return $CoordResult
endfunc

; FFNearestSpot function - This feature allows you to find, among all the area (or "spots") containing a minimum number of pixels
; a given color, the one that is closest to a reference point.
; return Values: if unsuccessful, returns 0 and sets @Error.
; if successful, an array of 3 elements: [0] : X coordinate of the nearest spot   [1] : Y coordinate of the nearest spot   [2] : Number of pixels found in the nearest spot
; for example, suppose you want to detect a blue circle (Color = 0x000000FF) partially obscured, diameter 32 pixels (say with at least 45 pixels having the right color)
; and the closest possible to the position x = 198 and y = 543, in a full screen, so the function is called as follows:
; FFNearestSpot $Res = (32, 45, 198, 543, 0x000000FF)
; if not @Error then MsgBox (0, "Blue Circle", "The blue circle closest to the position 198, 543 is at "&$PosX&","&$PosY&@LF&" and contains "&$NbPixel&" blue pixels")
;
; Proto C function: int WINAPI GenericColorSearch(int SizeSearch, int &NbMatchMin, int &XRef, int &YRef, int ColorToFind, int ShadeVariation, int NoSnapShot)
func FFNearestSpot($SizeSearch, $NbPixel, $PosX, $PosY, $Color, $ShadeVariation=0, $forceNewSnap=true, $Left=0, $Top=0, $Right=0, $Bottom=0, $NoSnapShot=$FFLastSnap, $WindowHandle=-1)
	if not SnapShotPreProcessor($Left, $Top, $Right, $Bottom, $forceNewSnap, $NoSnapShot, $WindowHandle) then
		SetError(2)
		return false
	endif
	local $Result = DllCall($FFDllHandle, "int", "GenericColorSearch", "int", $SizeSearch, "int*", $NbPixel, "int*", $PosX, "int*",$PosY, "int", $Color, "int", $ShadeVariation, "int", $NoSnapShot)
	if ((not IsArray($Result)) OR $Result[0]<>1) then
		SetError(1)
		return false
	endif
	local $CoordResult[3] = [$Result[3], $Result[4], $Result[2]] ; PosX, PoxY, Nombre de pixels
	return $CoordResult
endfunc

; FFBestSpot function - This feature is similar to FFNearestSpot, but even more powerful.
;    Suppose for instance that you want to find a spot with ideally 200 blue pixels in a 50x50 area, but some of those pixels may be covered, and also for transparency reasons, the color may be a bit different.
;    So, if it can't find a spot with 200 pure blue pixels, you could accept "lower" results, like only 120 blue pixels minimum, and - if enough pure blue pixels can't be found - try to find something close enough
;    with ShadeVariation.
;    FFBestSpot will do that all for you.
;    Here is how it works :
;      Only one additionnal parameters compared to FFNearestSpot : you give the minimum acceptable number of pixels to find, and then the "optimal" number. All other parameters are the same, with same meaning.
;      First, FFBestSpot will try to find if any spot exist with at least the optimal number of pixels and pure color (or colors). if yes, then it return the one that as the shorter distance with $PoxX/$PosY
;     Otherwise, it will try to find the spots that has the better number of pixels in the pure Color (or colors). if it can find a spot with at least the minimum acceptable number of pixels, then it returns this spot.
;     Otherwise, it will try again the two same searches, but now with ShadeVariation as set in the parameter (if this parameter is not 0)
;     if no proper spot can be found, returns 0 in the first element of the array and set @Error=1.
;
; Proto C function: int WINAPI ProgressiveSearch(int SizeSearch, int &NbMatchMin, int NbMatchMax, int &XRef, int &YRef, int ColorToFind/*-1 if several colors*/, int ShadeVariation, int NoSnapShot)
func FFBestSpot($SizeSearch, $MinNbPixel, $OptNbPixel, $PosX, $PosY, $Color, $ShadeVariation=0, $forceNewSnap=true, $Left=0, $Top=0, $Right=0, $Bottom=0, $NoSnapShot=$FFLastSnap, $WindowHandle=-1)
	if not SnapShotPreProcessor($Left, $Top, $Right, $Bottom, $forceNewSnap, $NoSnapShot, $WindowHandle) then
		SetError(2)
		return false
		endif
	local $Result = DllCall($FFDllHandle, "int", "ProgressiveSearch", "int", $SizeSearch, "int*", $MinNbPixel, "int", $OptNbPixel, "int*", $PosX, "int*",$PosY, "int", $Color, "int", $ShadeVariation, "int", $NoSnapShot)
	if ((not IsArray($Result)) OR $Result[0]<>1) then
		SetError(1)
		return false
		endif
	local $CoordResult[3] = [$Result[4], $Result[5], $Result[2]] ; PosX, PoxY, Nombre de pixels
	return $CoordResult
endfunc


; FFColorCount function - This function counts the number of pixels with the specified color, exact or approximate (ShadeVariation).
;
; Proto C  : int WINAPI ColorCount(int ColorToFind, int NoSnapShot, int ShadeVariation)
func FFColorCount($ColorToCount, $ShadeVariation=0, $forceNewSnap=true, $Left=0, $Top=0, $Right=0, $Bottom=0, $NoSnapShot=$FFLastSnap, $WindowHandle=-1)
	if not SnapShotPreProcessor($Left, $Top, $Right, $Bottom, $forceNewSnap, $NoSnapShot, $WindowHandle)  then
		SetError(2)
		return false
	endif
	$Result = DllCall($FFDllHandle, "int", "ColorCount", "int", $ColorToCount, "int", $NoSnapShot, "int", $ShadeVariation)
	if (not IsArray($Result)) then return false
	return $Result[0]
endfunc

; FFIsDifferent function - This function compares two SnapShots of the same window and return whether they have different or not .
; modified by frank10
; Proto C : int WINAPI HasChanged(int NoSnapShot, int NoSnapShot2, int ShadeVariation);  // ** Changed in version 2.0 : ShadeVariation added **
func FFIsDifferent($NoSnapShot1, $NoSnapShot2, $ShadeVariation=0)
	$Result = DllCall($FFDllHandle, "int", "HasChanged", "int", $NoSnapShot1, "int", $NoSnapShot2, "int", $ShadeVariation)
	if (not IsArray($Result)) then return false
	return $Result[0]
endfunc

; FFLocalizeChanges function - This function compares two SnapShots and specifies the number of different pixels and the smallest rectangle containing all changes.
; modified by frank10
; if unsuccessful, @Error = 1 and returns 0
; In case of differences, returns an array of 5 elements thus formed:
; [0]: left edge of the rectangle
; [1]: upper edge of the rectangle
; [2]: right edge of the rectangle
; [3]: lower edge of the rectangle
; [4]: Number of pixels that changed
; Proto C : int WINAPI LocalizeChanges(int NoSnapShot, int NoSnapShot2, int &xMin, int &yMin, int &xMax, int &yMax, int &nbFound, int ShadeVariation);  // ** Changed in version 2.0 : ShadeVariation added **
func FFLocalizeChanges($NoSnapShot1, $NoSnapShot2, $ShadeVariation=0)
	$Result = DllCall($FFDllHandle, "int", "LocalizeChanges", "int", $NoSnapShot1, "int", $NoSnapShot2, "int*", 0, "int*", 0, "int*", 0, "int*", 0, "int*", 0, "int" , $ShadeVariation )
	if ((not IsArray($Result)) OR $Result[0]<>1) then
		SetError(1)
		return false
	endif
	local $TabRes[5] = 	[$Result[3], $Result[4], $Result[5], $Result[6], $Result[7]];
	return $TabRes
endfunc


; FFGetPixel function - Cette fonction est close to PixelGetColor, except it works on a SnapShot.
;                       In order to make this function as fast as possible, you should explicitely make the snapshot before using it (cf benchmark.au3)
;
; Proto C : int WINAPI FFgetPixel(int X, int Y, int NoSnapShot)
func FFGetPixel($pos, $NoSnapShot=$FFLastSnap)
	$Result = DllCall($FFDllHandle, "int", "FFGetPixel", "int", $pos[0], "int", $pos[1], "int", $NoSnapShot)
	if ( (not IsArray($Result)) or ($Result[0]=-1) ) then
		SetError(2)
		return -1
	endif
	return $Result[0]
endfunc

; FFGetVersion function - This function returns the version Nb of FastFind DLL
;
; Proto C : LPCTSTR WINAPI FFVersion(void)
func FFGetVersion()
	$Result = DllCall($FFDllHandle, "str", "FFVersion")
	if ( (not IsArray($Result))  ) then
		SetError(2)
		return "???"
	endif
	return $Result[0]
endfunc

; FFGetLastError function - This function will return the last error message, if any (won't work if all debug are disabled, as error strings won't be initialized).
;
; Proto C : LPCTSTR WINAPI GetLastErrorMsg(void)
func FFGetLastError()
	$Result = DllCall($FFDllHandle, "str", "GetLastErrorMsg")
	if ( (not IsArray($Result))  ) then
		SetError(2)
		return ""
	endif
	return $Result[0]
endfunc

global $LastFileNameParam=""

; New in version 1.6 => Save a SnapShot in a .BMP file.
; Exemple of usage: FFSaveBMP("TOTO")
func FFSaveBMP($FileNameWithNoExtension, $forceNewSnap=false, $Left=0, $Top=0, $Right=0, $Bottom=0, $NoSnapShot=$FFLastSnap, $WindowHandle=-1)
	if not SnapShotPreProcessor($Left, $Top, $Right, $Bottom, $forceNewSnap, $NoSnapShot, $WindowHandle) then
		SetError(2)
		return false
	endif
	local $Result = DllCall($FFDllHandle, "BOOLEAN", "SaveBMP", "int", $NoSnapShot, "str", $FileNameWithNoExtension)
	if ((not IsArray($Result)) OR $Result[0]<>1) then
		SetError(1)
		return false
	endif
	local $Suffixe = DllCall($FFDllHandle, "int", "GetLastFileSuffix")
	if (IsArray($Result)) then
		if ($Result[0]>0) then
			$LastFileNameParam = $FileNameWithNoExtension+".BMP"
		Else
			$LastFileNameParam = $FileNameWithNoExtension+"_"+$Result[0]+".BMP"
		endif
	endif
	return true
endfunc

; New in version 1.6 => Save a SnapShot in a JPEG file.
; Exemple of usage: FFSaveJPG("TOTO")
func FFSaveJPG($FileNameWithNoExtension, $QualityFactor=85, $forceNewSnap=true, $Left=0, $Top=0, $Right=0, $Bottom=0, $NoSnapShot=$FFLastSnap, $WindowHandle=-1)
	if not SnapShotPreProcessor($Left, $Top, $Right, $Bottom, $forceNewSnap, $NoSnapShot, $WindowHandle) then
		SetError(2)
		return false
	endif
	local $Result = DllCall($FFDllHandle, "BOOLEAN", "SaveJPG", "int", $NoSnapShot, "str", $FileNameWithNoExtension, "ULONG", $QualityFactor)
	if ((not IsArray($Result)) OR $Result[0]<>1) then
		SetError(1)
		return false
	endif
	local $Suffixe = DllCall($FFDllHandle, "int", "GetLastFileSuffix")
	if (IsArray($Result)) then
		if ($Result[0]>0) then
			$LastFileNameParam = $FileNameWithNoExtension+".JPG"
		Else
			$LastFileNameParam = $FileNameWithNoExtension+"_"+$Result[0]+".JPG"
		endif
	endif
	return true
endfunc

; Gives the FileName of the last file written with FFSaveJPG of FFSaveBMP
func FFGetLastFileName()
	return $LastFileNameParam
endfunc

; Change a SnapShot so that it keeps only the pixels that are different from another SnapShot.
; modified by frank10
; Exemple :
;   FFSnapShot(0, 0, 0, 0, 1) ; Takes FullScreen SnapShot N�1
;   Sleep(1000)				  ; Wait 1 second
;   FFSnapShot(0, 0, 0, 0, 2) ; Takes another SnapShot (N�2)
;   FFKeepChanges(1, 2, 8)       ; SnapShot N�1 will have all pixels black, except those that have changed between the 2 SnapShots with a shadevariation of 8. SnapShot N�2 is kept unchanged.
;   FFSaveBMP("snapshot", false, 0,0,0,0, 1) ; Saves the result into snapshot.bmp
;
;Prototype : int WINAPI KeepChanges(int NoSnapShot, int NoSnapShot2, int ShadeVariation);  // ** Changed in version 2.0 : ShadeVariation added **
func FFKeepChanges($NoSnapShot1, $NoSnapShot2, $ShadeVariation=0)
	$Result = DllCall($FFDllHandle, "int", "KeepChanges", "int", $NoSnapShot1, "int", $NoSnapShot2, "int", $ShadeVariation)
	if ((not IsArray($Result)) OR $Result[0]<>1) then
		SetError(1)
		return false
	endif
	return true
endfunc

; Change a SnapShot so that it keeps only the color (or colors if a list is used) asked. All other pixels will be black.
; Exemple :
;   FFSnapShot(0, 0, 0, 0, 1) ; Takes FullScreen SnapShot N�1
;   Sleep(1000)				  ; Wait 1 second
;   FFSnapShot(0, 0, 0, 0, 2) ; Takes another SnapShot (N�2)
;   FFKeepChanges(1, 2)       ; SnapShot N�1 will have all pixels black, except those that have changed between the 2 SnapShots. SnapShot N�2 is kept unchanged.
;   FFResetColors()           ; Rest of the list of colors
;   local $Couleurs[2]=[0x00FF0000, 0x000000FF] ; Pure blue and pure red
;   FFAddColor($Couleurs)
;   FFKeepColor(-1, 60, false, 0,0,0,0, 1, -1) ;  As the SnapShot N�1 now has only very few pixels (only changes), we can now make de detection with very high ShadeVariation value
;                                              ;  After this step, the SnapShot N�1 will only have blue and red pixels left.
;Prototype : int WINAPI KeepColor(int NoSnapShot, int ColorToFind, int ShadeVariation);
func FFKeepColor($ColorToFind, $ShadeVariation=0, $forceNewSnap=true, $Left=0, $Top=0, $Right=0, $Bottom=0, $NoSnapShot=$FFLastSnap, $WindowHandle=-1)
	if not SnapShotPreProcessor($Left, $Top, $Right, $Bottom, $forceNewSnap, $NoSnapShot, $WindowHandle) then
		SetError(2)
		return false
	endif
	$Result = DllCall($FFDllHandle, "int", "KeepColor", "int", $NoSnapShot, "int", $ColorToFind, "int", $ShadeVariation)
	if ((not IsArray($Result)) OR $Result[0]<>1) then
		SetError(1)
		return false
	endif
	return true
endfunc

; FFDrawSnapShot will draw the SnapShot back on screen (using the same Window and same position).
; Can also be used on modified SnapShots (after use of FFsetPixel, FFKeepChanges or FFKeepColor)
; Proto C: bool WINAPI DrawSnapShot(int NoSnapShot);
func FFDrawSnapShot($NoSnapShot=$FFLastSnap)
	if $FFLastSnapStatus[$NoSnapShot] <> 1 then
		SetError(2)
		return false
	endif
	$Result = DllCall($FFDllHandle, "BOOLEAN", "DrawSnapShot", "int", $NoSnapShot)
	if ((not IsArray($Result)) OR $Result[0]<>1) then
		SetError(1)
		return false
	endif
	return true
endfunc

; FFSetPixel will change the color of a pixel in a given SnapShot
;bool WINAPI FFSetPixel(int x, int y, int Color, int NoSnapShot);
func FFSetPixel($x, $y, $Color, $NoSnapShot=$FFLastSnap)
	if $FFLastSnapStatus[$NoSnapShot] <> 1 then
		SetError(2)
		return false
	endif
	$Result = DllCall($FFDllHandle, "BOOLEAN", "FFSetPixel", "int", $x, "int", $y, "int", $Color, "int", $NoSnapShot)
	if ((not IsArray($Result)) OR $Result[0]<>1) then
		SetError(1)
		return false
	endif
	return true
endfunc

;bool WINAPI DuplicateSnapShot(int Src, int Dst);
func FFDuplicateSnapShot($NoSnapShotSrc, $NoSnapShotDst)
	; if $NoSnapShotSrc do not exist, then make the capture
	if not SnapShotPreProcessor(0, 0, 0, 0, false, $NoSnapShotSrc, -1) then
		SetError(2)
		return false
	endif
	$Result = DllCall($FFDllHandle, "BOOLEAN", "DuplicateSnapShot", "int", $NoSnapShotSrc, "int", $NoSnapShotDst)
	if ((not IsArray($Result)) OR $Result[0]<>1) then
		SetError(1)
		return false
	endif
	return true
endfunc

; GetRawData function - Gives RawBytes of the SnapShot
; Wrapper made by frank10
; if unsuccessful, @Error = 1 and returns 0
; Success: 	it returns a string stride with the Raw bytes of the SnapShot in 8 Hex digits (BGRA) of pixels from left to right, top to bottom
;           every pixel can be accessed like this:   StringMid($sStride, $pixelNo *8 +1  ,8)  and you get 685E5B00 68blue 5Egreen 5Bred 00alpha
;Proto C: int * WINAPI GetRawData(int NoSnapShot, int &NbBytes);
func FFGetRawData($NoSnapShot=$FFLastSnap)
	$aResult = DllCall($FFDllHandle, "ptr", "GetRawData", "int", $NoSnapShot, "int*", 0)
	if ( not IsArray($aResult) ) then
		SetError(1)
		return false
	endif
	Local $t_Raw  = DllStructCreate('ubyte['&  $aResult[2]  &  ']',$aResult[0])
	Local $sStride = DllStructGetData($t_Raw, 1)
	$sStride = StringRight($sStride,StringLen($sStride)-2)
	return $sStride
endfunc

; FFComputeMeanValues function - Gives mean Red, Green and Blue values, useful for detecting changed areas
; Wrapper made by frank10
; if unsuccessful, @Error = 1 and returns 0
; It returns an array with:
; [0]: MeanRed
; [1]: MeanGreen
; [2]: MeanBlue
; Proto C : int WINAPI ComputeMeanValues(int NoSnapShot, int &MeanRed, int &MeanGreen, int &MeanBlue);
func FFComputeMeanValues($NoSnapShot=$FFLastSnap)
	$aResult = DllCall($FFDllHandle, "int", "ComputeMeanValues", "int", $NoSnapShot, "int*", 0, "int*", 0, "int*", 0)
	if ( not IsArray($aResult) OR $aResult[0]<>1) then
		SetError(1)
		return false
	endif
	local $MeanResult[3] = [$aResult[2], $aResult[3], $aResult[4]] ; MeanRed, MeanGreen, MeanBlue
	return $MeanResult
endfunc

; FFApplyFilterOnSnapshot function - apply an AND filter on each pixels in the SnapShot
; Wrapper made by frank10
; if unsuccessful, @Error = 1 and returns 0
; Success: It returns 1
;Proto C : int WINAPI ApplyFilterOnSnapShot(int NoSnapShot, int Red, int Green, int Blue); // ** New in version 2.0 **
func FFApplyFilterOnSnapShot($Red, $Green, $Blue, $NoSnapShot=$FFLastSnap)
	$aResult = DllCall($FFDllHandle, "int", "ApplyFilterOnSnapShot", "int", $NoSnapShot, "int", $Red, "int", $Green, "int", $Blue)
	if ( not IsArray($aResult) OR $aResult[0]<>1) then
		SetError(1)
		return false
	endif
	return true
endfunc

; FFDrawSnapShotXY function - same as DrawSnapShot, with specific top-left position for drawing
; Wrapper made by frank10
; if unsuccessful, @Error = 1 and returns 0
; Success: returns 1
;Proto C : bool WINAPI DrawSnapShotXY(int NoSnapShot, int X, int Y); // ** New in version 2.0 **
func FFDrawSnapShotXY($iX, $iY, $NoSnapShot = $FFLastSnap)
	if $FFLastSnapStatus[$NoSnapShot] <> 1 then
		SetError(2)
		return false
	endif
	$Result = DllCall($FFDllHandle, "BOOLEAN", "DrawSnapShotXY", "int", $NoSnapShot, "int", $iX, "int", $iY)
	if ((not IsArray($Result)) OR $Result[0]<>1) then
		SetError(1)
		return false
	endif
	return true
endfunc
