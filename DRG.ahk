#SingleInstance Force

State := 0	; Starting state
States := ["Scout", "Gunner", "Driller", "Engineer"]

Gui, -Caption +AlwaysOnTop +Disabled -SysMenu +Owner
Gui, Font, s32
Gui, Add, Text, vInfoTeksti, Scout
ShowInfoText(States[State + 1]) ; First index in arrays is 1

ShowInfoText(text) {
	Gui 9:Font, s32			; Getting the size for new text control, because text control doesn't resize automatically
    	Gui 9:Add, Text, R1, %text%
    	GuiControlGet SizeForText, 9:Pos, Static1
    	Gui 9:Destroy

	GuiControl, Text, InfoTeksti, %text%
	GuiControl Move, InfoTeksti, % "h" SizeForTextH " w" SizeForTextW
	
	Gui, Show, NoActivate X0 Y0 AutoSize
	SetTimer, HideInfoText, 1000
	return

	HideInfoText:
		Gui, Cancel
	return
}

F4:: 
	State := Mod(State + 1, States.Length())
	ShowInfoText(States[State + 1]) ; First index is 1, but States start from 0
return

; State dependent keys
#If (State = 0)			; Scout
	*XButton2::		; flare gun
		Send, 4
		Sleep, 490
		KeyWait, XButton2
		Click
		Send, q
	return
	*XButton1::		; zip gun
		Send, 3
		Click, Down
		KeyWait, XButton1
		Click, Up
		Send, q
	return
#If (State = 1) 		; Gunner
	*XButton2::		; Shield
		Send, 4
		KeyWait, XButton2
		Click
	return
	*XButton1:: 		; Zipline
		Send, 3
		Sleep, 470
		KeyWait, XButton1
		Click
		Send, q
	return
#If (State = 2)			; Driller
	*XButton2::		; C4
		Send, 4
		Click
		startTime := A_TickCount
		KeyWait, XButton2
		if (A_TickCount - startTime > 700) {
			Click
			Send, q
		}
	return
	*XButton1::		; Drills
		Send, 3
		Click, Down
		KeyWait, XButton1
		Click, Up
		Send, q
	return
#If (State = 3)			; Engineer
	*XButton2::		; Turret
		Send, 4
		KeyWait, XButton2
		Click
	return
	*XButton1::		; Platform gun
		Send, 3
		KeyWait, XButton1
		Send, q
	return
#If


; Shared hotkeys
b::
	Send, {e Down}
	;Sleep, 1
	Send, {e Up}
	Click, Right
return


; Script controls
F10::
	Suspend
	If A_IsSuspended {
		SoundBeep
     		ShowInfoText("Suspended")
	} Else {
		ShowInfoText("Unsuspended")
		SoundBeep, 650
	}
Return

^F10::
	ShowInfoText("Exiting")
	SoundBeep, 300, 500
	ExitApp
Return