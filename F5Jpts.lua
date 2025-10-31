--[[ 
=======
==F5J==
=======

Riccardo Airbass70

Telemetry script per calcolare il punteggio di una prova di allenamento F5J.
Il punteggio corrisponde ai secondi di volo meno la quota di lancio divisa per due.
Operando da solo, il lancio inizia allo start del motore. Il lancio termina allo stop del motore. La quota di lancio è la massima raggiunta nei 10 secondi successivi al termine del lancio. Il volo terminina quando viene disarmato il protocollo.
Il programma non tiene conto dei punti di atterraggio.

IL display (128x64) 
--]]

--	=== Variabili==

local StartTime
local Phase
local FlighTime
local TmotIsExpired
local MotoffTime
local LaunchAlt
local MotBeepTime=nil
local Motbeep=nil
local Attempt
--local ThrId = getFieldInfo("thr").id           -- $$$$$$PROVVISORIO$$$$$
local Score
local w={"ready", "launch", "gliding", "landed"}
local y={}
local AltSteps={}

local function getv()
  return getValue("RxBt")
end

local function getFlightTime(p)
  if p==2 or p==3 then
    local t=getTime()
      FlightTime=(t-StartTime)/100
  end
  return FlightTime
end

local function getAlt()    
  --return math.floor(getValue(ThrId)/1024*100)   --sostituisce la telemetria alt
  return math.floor(getValue("Alt"))
end

local function ready()
    
end

local function launch()
  local t=getTime()
  local tmot=t-StartTime
  for i=1,6 do
    if tmot>MotBeepTime[i] and Motbeep[i] then
      Motbeep[i]=false
      playTone(2550, 50, 0, 3, 0, 3) -- play tone, use Beep volume 5
    elseif tmot>MotBeepTime[6] then
      TmotIsExpired=true               
    end
  end
end

local function get_launch_alt()
  local t=getTime()
  local tpostlaunch=t-MotoffTime
  if tpostlaunch<1000 and getAlt()>LaunchAlt then
    LaunchAlt=getAlt()
  end
  if tpostlaunch>1010 and not AltLaunchCalled then
    playNumber(LaunchAlt,9,0,3)
    AltLaunchCalled=true
  end
  return LaunchAlt
end

local function CallAltSteps()
  for i=1,10 do
    local a=i*20
    if getAlt()>a and AltSteps[i] then
      playNumber(a,9,0,3)
      AltSteps[i]=false
    elseif
      getAlt()<a-5 and AltSteps[i+1] then
      AltSteps[i]=true
    end
  end
end

local function landed()
  Score=math.floor(FlightTime-LaunchAlt/2)
  local s=Score<0
  local c= s or TmotIsExpired
  if c then
    Score=0
  end
end

local function ResetFlight()
  FlightTime=0
  LaunchAlt=0
  MotBeepTime={2400,2500,2600,2700,2800,3000}  
  Motbeep={true,true,true,true,true,true}   
  TmotIsExpired=false
  AltLaunchCalled=false
  for i=1,10 do
    AltSteps[i]=false
  end
  AltSteps[11]=true
  --ResetTelemetry Alt. Anche dal modello.
  Attempt=Attempt+1
end

local function DrawValueBox(x,y,label,value)
  local l=string.len(value)
  local x1=2+(6-l)/2*8                                          -- 
  lcd.drawText(x+2,y+2,label,SMLSIZE)
  lcd.drawText(x+x1,y+10,value,MIDSIZE)
  lcd.drawRectangle(x, y, 48, 25)
end

local function tMinSec(timer)
  local m=math.floor(timer/60)
  local mm=string.format("%02d", m)
  local s=timer%60
  local ss=string.format("%02d", s)
  local t=mm..":"..ss
  return t
end

local function getClockTime()
  local h=getDateTime()["hour"]
  local hh=string.format("%02d",h)
  local m=getDateTime()["min"]
  local mm=string.format("%02d", m)
  clocktime=tostring(hh..":"..mm)
  return clocktime
end

local function gliding()
  get_launch_alt()
  CallAltSteps()
end

local function ground()

end

task={ready,launch,gliding, ground}


--      === inizializzazione===

local function init()

  y[1]=true
  Attempt=0
  ResetFlight()
  
end	 		

--      === run ===

local function run ()

  moton=getLogicalSwitchValue(4)
  armed=getLogicalSwitchValue(2)
  
  if y[1] and moton then
    y[2]=true
    y[1]=false
    StartTime=getTime()               --funzione one time.
  elseif y[2] and not moton then
    y[3]=true
    y[2]=false
    MotoffTime=getTime()               --funzione one time.      
  elseif y[3] and not armed then
    y[4]=true
    y[3]=false
    landed()                          --funzione one time.
  elseif y[3] and moton then
    y[2]=true
    y[3]=false
    ResetFlight()
    StartTime=getTime()               --funzione one time
  elseif y[4] and armed then
    y[1]=true
    y[4]=false
    ResetFlight()                     --funzione one time
    
  end

  for i=1,4 do                        --trova l'indice (1-4) del valore true di y e lo scrive su una variabile globale 
    if y[i] then Phase=i break end
  end

  
  task[Phase]()                       --funzioni in loop

  lcd.clear()
  lcd.drawText(1, 0, "Bat "..string.format("%.2f",getv()).." V                                    ", INVERS)  -- 38 caratteri
  lcd.drawText(102, 0,getClockTime(), INVERS)                                      -- 38 caratteri
  lcd.drawText(1, 56, "Alt Launch "..LaunchAlt.." m                    ", INVERS)  -- 38 caratteri
  lcd.drawText(5,10,w[Phase],MIDSIZE)
  lcd.drawText(115,10,tostring(Attempt),MIDSIZE)
  if Phase==4 then
    DrawValueBox(10,26,"SCORE",Score)
  else
    DrawValueBox(10,26,"ALT       m",getAlt())
  end
  DrawValueBox(68,26,"Fl. Timer",tMinSec(getFlightTime(Phase)))

end

return {run=run, init=init}
