FindColor(c1)
{
	global
	MinDistance := 9999
	ColorInd := 0
	Loop, %PalletteSize% {
		tempDist := ColorDistance(Array%A_Index%, c1)
		if(tempDist < MinDistance) {
			;MsgBox % "Dist: " . tempDist . " Index: " . A_Index . " MinDist: " . MinDistance
			MinDistance := tempDist
			ColorInd := A_Index
		}
	}
	return ColorInd
}

ColorDistance(c1, c2)
{
	distance := 0
	Loop, 3 {
		t0 := "0x" . SubStr(c1,1+(2*A_Index),2)
		t0 := t0 + 0
		t1 := "0x" . SubStr(c2,1+(2*A_Index),2)
		t1 := t1 + 0
		distance := distance + Abs(t0-t1)
	}
	return distance
}

Esc::ExitApp
^!c::
; Write to the array:
PalletteSize = 0
Loop, Read, C:\Users\Tyler\Desktop\SandDraw\Pallette.txt   ; This loop retrieves each line from the file, one at a time.
{
	PalletteSize += 1  ; Keep track of how many items are in the array.
	Array%PalletteSize% := A_LoopReadLine  ; Store this line in the next array element.
}
CoordMode Pixel
CoordMode Mouse
MouseGetPos StartX, StartY
X_Index := 0
Y_Index := 0
ColorIndex := 0
Loop, 392 {
	X_Index = %A_Index%
	X_Pos := X_Index + StartX
	Loop, 292 {
		Y_Index = %A_Index%
		Y_Pos := Y_Index + StartY
		PixelGetColor RefColor, StartX-432+X_Index, StartY+Y_Index, Slow RGB
		;MsgBox % "pixel color " . RefColor
		;MouseMove, StartX-432+X_Index, StartY+Y_Index 
		newColorIndex := FindColor(RefColor)
		;MsgBox % newColorIndex . " " . ColorIndex
		if (newColorIndex != ColorIndex) {
			if(BeginY = Y_Pos-1) {
				MouseClickDrag, L, BeginX, BeginY, BeginX, BeginY-1, 0
			}
			MouseClickDrag, L, BeginX, BeginY, X_Pos, Y_Pos-1, 0
			ColorIndex:= newColorIndex
			BeginX := X_Pos
			BeginY := Y_Pos
			SelectX := StartX+20+(55*Floor((ColorIndex-1)/10))
			SelectY := StartY+305+(14*Mod(ColorIndex-1,10))
			MouseMove, SelectX, SelectY, 0
			Sleep 50
			Click down
			Sleep 50
			Click up
			Sleep 50
			MouseMove, BeginX, BeginY, 0
		} else if (BeginX != X_Pos){
			MouseClickDrag, L, BeginX, BeginY, BeginX, 292, 0
			BeginX := X_Pos
			BeginY := Y_Pos
			MouseMove, BeginX, BeginY, 0
		}
	}
}
; Read from the array:
Loop %PalletteSize%
{
    ; The following line uses the := operator to retrieve an array element:
    element := Array%A_Index%  ; A_Index is a built-in variable.
    ; Alternatively, you could use the "% " prefix to make MsgBox or some other command expression-capable:
    MsgBox % "Element number " . A_Index . " is " . Array%A_Index%
}
return




!F1::
CoordMode Pixel
CoordMode Mouse
MouseGetPos MouseX, MouseY
PixelGetColor colour, MouseX, MouseY, Slow RGB
MsgBox % colour
return