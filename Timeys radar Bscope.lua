--ARGOS MK1 RADAR BY TIMEY
tau=0.95
filazi=0
filelev=0
filran=0
buffer={}
timer=0
RIB=false
ROB=false
rT=0
S={}
S[1]=0
S[2]=0
R=0
A=0
FIL=false
AL=0
function onTick()
range=input.getNumber(1)
azi=input.getNumber(2)*360
elev=input.getNumber(3)*360
res=input.getNumber(5)
GZ=input.getNumber(10)
DEG=input.getBool(3)
filazi=tau*azi+(1-tau)*filazi
filelev=tau*elev+(1-tau)*filelev
filran=tau*range+(1-tau)*filran
output.setNumber(2,filazi)
output.setNumber(3,filelev)
X=((filazi+80)/160)*80+8
Y=(filran/res)*(-68)+74
A2=GZ+filran*math.sin(filelev*(3.14/180))
if filran>2 and filran<9600 then
table.insert(buffer, {x=X,y=Y,e=filelev,age=0,Fa=filazi,Fr=filran,A1=A2})
if FIL==true then
for i, data in pairs(buffer) do
for j, otherData in pairs(buffer) do
if data ~= otherData and math.abs(data.x-otherData.x)<3 and math.abs(data.y-otherData.y)<3 then
table.remove(buffer, i)
break
end
end
end
end
end
timer=timer+1
if timer==90 then
for i, data in pairs(buffer) do
data.age=data.age+1.5
end
timer=0
end
for i, data in pairs(buffer) do
if data.age>1.5 then
table.remove(buffer,i)
end
end
RIB=input.getBool(1)
if RIB then
rT=rT+1
else
rT=0
end
if rT>30 then
ROB=true
else
ROB=false
end
output.setBool(1,ROB)
MonX=input.getNumber(6)
MonY=input.getNumber(7)
MonP=input.getBool(2)
if (MonX>7 and MonX<89) and (MonY>5 and MonY<74) and MonP==true then
S[1]=MonX
S[2]=MonY
else if MonP==true then
S[1]=0
S[2]=0
end
end
if S[1]>0 then
for i, data in pairs(buffer) do
if data.x<S[1]+6 and data.x>S[1]-6 and data.y<S[2]+6 and data.y>S[2]-6 then
R=data.Fr
A=GZ+R*math.sin(data.e*(3.14/180))
output.setNumber(5,data.Fa)
output.setNumber(6,data.e)
output.setNumber(7,data.Fr)
end
end
end
if (MonX>89) and (MonY>6 and MonY<30) and MonP==true and FIL==false and timer>10 and timer<80 then
FIL=true
timer=85
else if (MonX>89) and (MonY>6 and MonY<30) and MonP==true and FIL==true and timer>10 and timer<80 then
FIL=false
timer=85
end
end
end
function onDraw()
screen.setColor(255,255,255,255)
if DEG==true then
screen.drawText(8,76,"16090")
else
screen.drawText(8,76,"16043")
end
screen.drawLine(8,6,88,6)
screen.drawLine(8,74,88,74)
screen.drawLine(88,74,88,5)
screen.drawLine(8,74,8,6)
screen.drawText(47,0,"0")
screen.drawText(60,0,"+40")
screen.drawText(20,0,"-40")
screen.drawText(2,0,"-80")
screen.drawText(80,0,"+80")
screen.setColor(255,255,255,80)
screen.drawLine(48,0,48,10)
screen.drawLine(9,0,9,10)
screen.drawLine(87,0,87,10)
screen.drawLine(68,0,68,10)
screen.drawLine(28,0,28,10)
if FIL==false then
screen.setColor(195,25,10,255)
else
screen.setColor(125,25,150,255)
end
screen.drawRectF(89,6,10,23)
screen.setColor(255,255,255,255)
if res==9600 then
screen.setColor(255,255,255,255)
screen.drawText(65,76,"9.6km")
screen.drawText(0,46,"3k")
screen.drawText(0,24,"6k")
screen.setColor(255,255,255,80)
screen.drawLine(-1,51,97,51)
screen.drawLine(-1,29,97,29)
else
screen.drawText(65,76,"3.2km")
screen.drawText(0,46,"1k")
screen.drawText(0,24,"2k")
screen.setColor(255,255,255,80)
screen.drawLine(-1,51,97,51)
screen.drawLine(-1,29,97,29)
end
for i, data in pairs(buffer) do
screen.setColor(255,0,0,255)
if data.A1>15 then
screen.drawCircle(data.x,data.y,2)
else
screen.drawCircleF(data.x,data.y,2)
end
end
if RIB==true then 
screen.setColor(255,95,31)
screen.drawText(91,30,"P")
screen.drawText(91,36,"I")
screen.drawText(91,41,"N")
screen.drawText(91,46,"G")
end
if ROB==true then
screen.drawText(33,38,"MISSILE")
end
if S[1]>1 then
S[1]=MonX
S[2]=MonY
screen.setColor(20,90,255)
screen.drawText(32,76,"TWS/SEL")
screen.drawText(8,82,"RNG:")
screen.drawText(24,82,string.format("%iM",math.floor(R)))
screen.drawText(8,88,"ALT:")
screen.drawText(24,88,string.format("%iM",math.floor(A)))
screen.drawCircle(S[1], S[2], 6)
else if FIL==false then
screen.setColor(255,255,255,255)
screen.drawText(42,76,"SRC")
else
screen.setColor(125,25,150,255)
screen.drawText(32,76,"SRC+FIL")
end
end
end
