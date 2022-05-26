#include <GUIConstants.au3>
#include <AutoItConstants.au3>
#include <Misc.au3>

Opt("GUIOnEventMode", 1)

$GUI = GUICreate("LoL AutoAccept by edshot#8683", 350, 50, 0, 0)
	$G_status = GUICtrlCreateLabel("Status: ?", 10, 10, 220, 20)
	$G_res = GUICtrlCreateLabel("League Res: ?", 10, 30, 210, 50)
GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
GUISetState(@SW_SHOW, $GUI)
WinSetOnTop($GUI, "", $WINDOWS_ONTOP)

$clicked = False
$reset_timer = False
$prev = 0
$prevX = 0
$oldres = "0x0"

while 1
	if (ProcessExists("LeagueClient.exe")) Then
		$status = "Attached to League"
	Else
		$status = "League is not running"
		GUICtrlSetData($G_res, "League Client Resolution: ?")
	EndIf
	$league = WinExists("League of Legends")
	If (WinActive("League of Legends") or WinActive("League AutoAccept")) Then
		$league_pos = WinGetPos("League of Legends")
		$coords = getCoords($league_pos)
		if ($coords <> False) Then
			$clr = PixelGetColor($coords[0], $coords[1], $league)
			if $clr <> $prev Then ConsoleWrite("Accept: 0x" & hex($clr) & @lf)
			$prev = $clr
			$clrX = PixelGetColor($coords[2], $coords[3], $league)
			If $clrX <> $prevX Then ConsoleWrite("ColorX: 0x" & hex($clrX) & @lf)
			if ($clrX = 0x000ac5e1) Then
				$status = "Status: Searching for game..."
			Else
				$status = "Status: In lobby/main menu"
			EndIf
			$prevX = $clrX
			if (($clr = 0x001e252a or $clr = 0x0001587f) And Not $clicked) Then
				Beep(2000, 50)
				_MouseTrap($coords[0], $coords[1])
				MouseClick("Left", $coords[0], $coords[1], $league, 1)6
				_MouseTrap()
				$clicked = True
				$reset_timer = TimerInit()
			endif
		EndIf
	Else
		$clicked = False
	EndIf
	if ($reset_timer) Then
		If (TimerDiff($reset_timer) > 10000) Then $reset_timer = False
	EndIf
	GUICtrlSetData($G_status, $status)
	sleep(200)
WEnd

func getCoords($lpos)
	$res = $lpos[2] & "x" & $lpos[3]
	if ($lpos[2] = 1600 And $lpos[3] = 900) Then
		if $res <> $oldres Then
			ConsoleWrite("LeagueClient Res: " & $res & @LF)
			GUICtrlSetData($G_res, "League Client Resolution: " & $res)
			$oldres = $res
		EndIf
		Local $arr = [$lpos[0] + 800, $lpos[1] + 720, $lpos[0] + 1425, $lpos[1] + 65]
		Return $arr
	ElseIf ($lpos[2] = 1280 And $lpos[3] = 720) Then
		if $res <> $oldres Then
			ConsoleWrite("LeagueClient Res: " & $res & @LF)
			GUICtrlSetData($G_res, "League Client Resolution: " & $res)
			$oldres = $res
		EndIf
		Local $arr = [$lpos[0] + 640, $lpos[1] + 576, $lpos[0] + 1139, $lpos[1] + 53]
		Return $arr
	ElseIf ($lpos[2] = 1024 And $lpos[3] = 576) Then
		if $res <> $oldres Then
			ConsoleWrite("LeagueClient Res: " & $res & @LF)
			GUICtrlSetData($G_res, "League Client Resolution: " & $res)
			$oldres = $res
		EndIf
		Local $arr = [$lpos[0] + 510, $lpos[1] + 460, $lpos[0] + 912, $lpos[1] + 42]
		Return $arr
	Else
		Return false
	EndIf
EndFunc

func _exit()
	Exit
EndFunc

