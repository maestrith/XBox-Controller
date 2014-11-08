Gui(){
	Gui,+hwndhwnd
	hwnd(1,hwnd)
	Gui,Add,ListView,w150 h300,Program
	Gui,Add,TreeView,x+5 w300 h300
	Gui,Add,Button,xm w455 gstart Default,Start
	Gui,Show,x3 y300,XBox 360
	return
	GuiEscape:
	GuiClose:
	ExitApp
	return
}