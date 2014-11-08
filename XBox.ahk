#SingleInstance,Force
Gui(),xx:=new xbox()
;FileDelete,program.xml
program:=new xml("program")
if !top:=program.ssn("//game[@name='default']"){
	top:=program.Add({path:"game",att:{name:"default"}})
	next:=program.under({under:top,node:"input",att:{type:"mouse"}})
	program.under({under:next,node:"action",att:{speed:4,read:"Rthumb",dead:24}}) ;,hold:"LButton"
	next:=program.under({under:top,node:"input",att:{type:"Button",press:"LButton"}})
	program.under({under:next,node:"action",att:{button:"x"}})
	program.under({under:next,node:"action",att:{button:"a"}})
	next:=program.under({under:top,node:"input",att:{type:"Button",press:"RButton"}})
	program.under({under:next,node:"action",att:{button:"y"}})
	program.under({under:next,node:"action",att:{button:"x"}})
	next:=program.under({under:top,node:"input",att:{type:"Button",press:"LButton"}})
	program.under({under:next,node:"action",att:{trigger:"LTrigger",dead:"5"}})
}
xbox.buttons:=[],xbox.mouse:=[]
Loop,2
	program.Transform()
syn:=program.sn("//input")
LV_Add("",program.ssn("//game/@name").text)
while,ss:=syn.Item[A_Index-1]{
	con:=sn(ss,"action")
	ea:=xml.ea(ss)
	if (ea.type="mouse"){
		root:=TV_Add("Mouse")
		pgm:=xbox.mouse[A_Index]:=[],list:=sn(ss,"*")
		while,ll:=list.Item[A_Index-1]
			for a,b in xml.ea(ll)
				pgm[a]:=b,TV_Add(a " = " b,root,"Vis")
	}
	if (ea.type="Button"){
		root:=TV_Add("Button Press = " ea.press)
		pgm:=xbox.buttons[A_Index]:=[],list:=sn(ss,"*"),pgm.press:=ea.press
		while,ll:=list.Item[A_Index-1]{
			index:=A_Index
			for a,b in xml.ea(ll)
				pgm[Index,a]:=b,TV_Add(a " = " b,root,"Vis")
		}
	}
}
OnExit,Exit
;SetTimer,start,-1
return
exit:
;program.save(1)
ExitApp
return
#Include Class XML.ahk
#Include Gui.ahk
#Include Hwnd.ahk
#Include Msgbox.ahk
#Include Start.ahk
#Include Class XBox.ahk