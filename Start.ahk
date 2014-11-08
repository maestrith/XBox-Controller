Start(){
	Start:
	ControlGetText,start,Button1,% hwnd([1])
	if (start="start"){
		ControlSetText,Button1,Stop,% hwnd([1])
		xbox.start()
	}else{
		ControlSetText,Button1,Start,% hwnd([1])
		xbox.stop()
	}
	return
}