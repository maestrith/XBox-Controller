class xbox{
	static mousekeys:={LButton:"left",RButton:"right",WheelDown:"WheelDown",WheelUp:"WheelUp"}
	,Buttons:={Up:1,Down:2,Left:4,Right:8,Start:16,Back:32,LeftThumb:64,RightThumb:128,LeftShoulder:256,RightShoulder:512,A:0x1000,B:0x2000,X:0x4000,Y:0x8000}
	,axis:={lthumbx:8,lthumby:10,rthumbx:12,rthumby:14}
	,old:=["LThumbX","LThumbY"],triggers:={LTrigger:6,RTrigger:7},mode:="",keys:=[]
	,dead:={lthumb:50,rthumb:50,ltrigger:50,rtrigger:50}
	start(){
		SetTimer,getstate,30
	}
	stop(){
		SetTimer,getstate,Off
		xbox.program:=[],t()
	}
	__New(count=0){
		static
		this.library:=DllCall("LoadLibrary","str",InStr(A_OSVersion,8)?"Xinput1_4":"Xinput1_3"),this.ctrl:=[],VarSetCapacity(move,28),this.count:=count,main:=this,xbox.move:=&move,VarSetCapacity(State,16)
		main.ctrl:=[]
		NumPut(0,move,8),NumPut(0,move,12),NumPut(0x0001,move,16)
		if !(this.library){
			m("Error loading the DLL")
			ExitApp
		}
		for a,b in {xGetState:"XInputGetState",xBattery:"XInputGetBatteryInformation",xSetState:"XInputSetState",xinputid:"XInputGetKeystroke"}
			this[a]:=DllCall("GetProcAddress","ptr",this.library,"astr",b)
		xbox.mode:="edit_keys",xbox.main:=this,down:=hold:=value:=[]
		Return this
		getstate:
		DllCall(main.xGetState,"uint",0,uptr,&State),buttons:=NumGet(state,4)
		for a,b in xbox.mouse{
			for c,d in ["x","y"]
				value[d]:=Floor(NumGet(state,xbox.axis[b.read d],"short")/32767*10)
			if (Abs(value.x)>b.dead/10||Abs(value.y)>b.dead/10){
				if (b.hold&&hold[b.read,b.hold]!=1)
					hold[b.read,b.hold]:=1,xbox.Send(b.hold,"Down")
				value.y:=b.invert?value.y:value.y*-1
				NumPut(value.x,xbox.move,4),NumPut(value.y,xbox.move,8)
				speed:=Abs(value.x)>Abs(value.y)?Abs(value.x):Abs(value.y),speed:=speed?speed:1
				Loop,% Abs(speed/(b.speed/2))
					DllCall("User32\SendInput",uint,1,uptr,xbox.move,uint,28)
				movey:=b.yinvert?movey:movey*-1
			}else{
				for a in hold[b.read]
					xbox.Send(a,"up")
				hold.Remove(b.read)
			}
		}
		for _,a in xbox.buttons{
			for _,b in a{
				if (b.button&&buttons&xbox.buttons[b.button]=0)
					goto Bottom
				if (b.trigger&&NumGet(state,xbox.triggers[b.trigger],"uchar")<b.dead)
					goto Bottom
			}
			for c,b in a
				m(c,b.trigger,b.button)
			return m(a.press)
			if !down[A_Index,a.press]
				down[A_Index,a.press]:=a.press,xbox.Send(a.press,"down")
			Continue
			bottom:
			if down[A_Index,a.press]
				down[A_Index].Remove(a.press),xbox.Send(a.press,"up")
		}
		return
	}
	Battery(Controller){
		VarSetCapacity(batt,4),DllCall(this.xBattery,"uint",Controller,"uint",0,"uptr",&batt)
		Return NumGet(batt,1)
	}
	Send(key,state){
		if (key="")
			Return
		if this.mousekeys[key]{
			if InStr(key,"wheel")&&state="Down"
				MouseClick,% this.mousekeys[key]
			Else if !InStr(key,"wheel")
				MouseClick,% this.mousekeys[key],,,,,%state%
		}
		else{
			StringLower,key,key
			ControlSend,,{%key% %state%},A
		}
	}
}