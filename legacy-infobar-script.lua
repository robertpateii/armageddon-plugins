--[[

###INSTALLATION INSTRUCTIONS###

Step 1: Save this file to your hard drive. I recommend the MushClient/Script directory.

Steps 2-4: Connect to Armageddon. Hit shift-ctrl-6 to open the scripting settings menu in mushclient. Make sure your scripting language is Lua (it's default), set your script prefix to forward slash (/), then click the browse button. Find where you downloaded this file and select it. Click OK to close the script dialogue.

Step 5: Connect to your character and send this command to Armageddon: /InstallInfobar()

Step 6: If you want mana to display, send this command: /ManaOn() (Send /ManaOff() to disable Mana)

Note: If you're currently using a detailed status prompt, installing this Infobar will will overwrite it, hide it, and suck all the information out of its brains.

Note: If your character dies, you just need to send /ManaOn() OR /ManaOff() to fix the infobar.

Note: I highly recommend optional Step 7! (it's the descriptive infobar. i use it exclusively.)

If you have problems email me - robert.pate+alsokanks@gmail.com

Optional Step 7:  use this command: /SwapInfobar() to change between Detailed and Descriptive versions. Detailed offers a detailed list of numbers. Descriptive drops all numbers and instead says stuff like "You're hurting, exhausted, woozy, armed, mounted, and set for running. Also you're Fighting: Amos. It's late afternoon."

USERS OF PREVIOUS VERSIONS: Remove the old triggers (they start with ^PROMPT_...) then replace your old script file, then run /InstallInfobar().

###CODE EXPLANATION###
Unless you want to learn how this thing works or need to configure it beyond the defaults, stop reading.

here is the Status Prompt; enter the entire following line into armageddon after you have logged into your character.
prompt PROMPT_%a_%o_%O_%k_%e_LINEONE\n
PROMPT_%E_%A_%w_%h_%H_%t_%T_%v_%V_%m_%M_LINETWO\n
PROMPT_%s_manaoff_LINE3\n
btw, this is a really important piece. changing even the order will break everything in both DetailedInfobar and DescriptiveInfobar.


the following line is the new matching string. Create a new trigger and put it into the matching field at the top. Don't save and close it yet though.
^PROMPT_([^_]+)_([^_]+)_([^_]+)_riding: ([^_]+)_([^_]+)_LINEONE\n
PROMPT_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_LINETWO\n
PROMPT_([^_]+)_([^_]+)_LINE3$
While still in the same trigger, check these options: regular expression, omit from output, and optionally omit from log.
Lastly you must put the name of the function (script) you want to use in the "script:" field for the trigger. Either DetailedInfobar or DescriptiveInfobar depending on which you want to use.

Again, this is a really important piece. That's because this pattern is regex code for the prompt information. If you change something it may not recognize your prompt info anymore and you'll get a bunch of nil values.

An author's todo list:
* better variable scoping?
* possible speed enhancements?


]]--



function installinfobar()
InstallInfobar()
end --end installinfobar

function installInfobar()
InstallInfobar()
end --end installinfobar

function Installinfobar()
InstallInfobar()
end --end installinfobar

function InstallInfobar()
--Prototype for trigger class: long AddTriggerEx(BSTR TriggerName, BSTR MatchText, BSTR ResponseText, long Flags, short Colour, short Wildcard, BSTR SoundFileName, BSTR ScriptName, short SendTo, short Sequence);
AddTriggerEx ("DetailedInfobarTrigger", "^PROMPT_([^_]+)_([^_]+)_([^_]+)_riding: ([^_]+)_([^_]+)_LINEONE\\nPROMPT_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_LINETWO\\nPROMPT_([^_]+)_([^_]+)_LINE3$", "", 41, -1, 0, "", "DetailedInfobar", 0, 10)
--above line sets up trigger to read in the data from the prompt and feed it to the script.
SetTriggerOption ("DetailedInfobarTrigger","multi_line", 1)
SetTriggerOption ("DetailedInfobarTrigger","lines_to_match", 3)
--above two lines enable multi-line matching which is neeeded due to the length of the prompt - it won't fit all on one line
--also note that it's important to set these triggers to 'keep evaluating' otherwise it will only act on each line once.
AddTriggerEx ("DetailedInfobarTriggerGag1", "^PROMPT_([^_]+)_([^_]+)_([^_]+)_riding: ([^_]+)_([^_]+)_LINEONE$", "", 47, -1, 0, "", "", 0, 20)
AddTriggerEx ("DetailedInfobarTriggerGag2", "^PROMPT_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_([^_]+)_LINETWO$", "", 47, -1, 0, "", "", 0, 20)
AddTriggerEx ("DetailedInfobarTriggerGag3", "^PROMPT_([^_]+)_([^_]+)_LINE3$", "", 47, -1, 0, "", "", 0, 20)
--above three lines gag the prompt lines - multi-line triggers can't gag text.
SendImmediate ("prompt PROMPT_%a_%o_%O_%k_%e_LINEONE\\nPROMPT_%E_%A_%w_%h_%H_%t_%T_%v_%V_%m_%M_LINETWO\\nPROMPT_%s_manaoff_LINE3\\n")
--above creates Prompt ingame. Notice the \\n to create linebreaks in the prompt. The extra \ is needed otherwise the SendImmediate command will hit the enter key, so to speak, when it reads \n.
ShowInfoBar (true)
--above Turns on infobar in case it's off.
SendImmediate ("inv")
--above sends just any input to trigger a prompt in game.
Tell ("You should now see your stats in the infobar at the bottom of your mushclient window. If not, email me - robert.pate+alsokanks@gmail.com")

end --end InstallInfobar

function SwapInfobar()
--http://www.gammon.com.au/scripts/function.php?name=GetTriggerOption
local InfobarTriggerScript      
InfobarTriggerScript = GetTriggerOption ("DetailedInfobarTrigger", "script")
        if InfobarTriggerScript == "DetailedInfobar" then
                SetTriggerOption ("DetailedInfobarTrigger", "script", "DescriptiveInfobar")
		SendImmediate ("inv")
        elseif InfobarTriggerScript == "DescriptiveInfobar" then
                SetTriggerOption ("DetailedInfobarTrigger", "script", "DetailedInfobar")
		SendImmediate ("inv")
        else Note ("something is rotten in the state of SwapInfobar()")
end -- if statement
end --end SwapInfobar

function ManaOff()
SendImmediate ("prompt PROMPT_%a_%o_%O_%k_%e_LINEONE\\nPROMPT_%E_%A_%w_%h_%H_%t_%T_%v_%V_%m_%M_LINETWO\\nPROMPT_%s_manaoff_LINE3\\n")
SendImmediate ("inv")
end

function ManaOn()
SendImmediate ("prompt PROMPT_%a_%o_%O_%k_%e_LINEONE\\nPROMPT_%E_%A_%w_%h_%H_%t_%T_%v_%V_%m_%M_LINETWO\\nPROMPT_%s_manaon_LINE3\\n")
SendImmediate ("inv")
end

function DetailedInfobar(thename, theoutput, wildcards)

--Now creating variables with "local" command then filling them with the data from the prompt and trigger:
--The numbers here match the corresponding entry into your prompt. i.e. %a (accent) is first, so it becomes wildcards[1], %o (language) is wildcards[2]
--But it doesn't get assigned a number until it passes through the regex in the trigger:  which is why you can't change one without changing all three.
--From here on out, the info from your prompt is contained in the variables created below. i.e. your current health, %h from your prompt, is stored in CurrentHealth.
local CurrentAccent
CurrentAccent = wildcards [1]
local CurrentLanguage
CurrentLanguage = wildcards [2]
local CurrentMood
CurrentMood = wildcards [3]
local CurrentRiding
CurrentRiding = wildcards [4]--used by default.
local CurrentTime
CurrentTime = wildcards [5]--used by default.
local CurrentEncumbrance
CurrentEncumbrance = wildcards [6]
local CurrentArmed
CurrentArmed = wildcards [7]--used by default.
local CurrentSpeed
CurrentSpeed = wildcards [8]--used by default.
local CurrentHealth
CurrentHealth = tonumber(wildcards [9])--used by default.
local CurrentHealthMax
CurrentHealthMax = tonumber(wildcards [10])--used by default.
local CurrentStun
CurrentStun = tonumber(wildcards [11])--used by default.
local CurrentStunMax
CurrentStunMax = tonumber(wildcards [12])--used by default.
local CurrentStamina
CurrentStamina = tonumber(wildcards [13])--used by default.
local CurrentStaminaMax
CurrentStaminaMax = tonumber(wildcards [14])--used by default.
local CurrentMana
CurrentMana = tonumber(wildcards [15])--used by default.
local CurrentManaMax
CurrentManaMax = tonumber(wildcards [16])--used by default.
local CurrentPosition
CurrentPosition = wildcards [17]--used by default.
local DisplayMana
DisplayMana = wildcards [18]-- string used to toggle mana display


--Setting up default look
InfoClear ()
InfoBackground ("wheat")
-- Disabling the font command because it's not required on windows and causes problems on linux.
-- InfoFont ("Arial",10,1) --Font, Size, Style

--Add a Text Variable - in the line after next, replace 'TextVariable' with the variable you want to add from the list above. Then uncomment them both.
--InfoColour ("black")
--Info ("abbreviation",TextVariable)

--Riding Status
InfoColour ("black")
Info ("Riding: ",CurrentRiding," ")


--CurrentHealth
if (CurrentHealth/CurrentHealthMax) < 20/100 then
InfoColour ("crimson")
elseif (CurrentHealth/CurrentHealthMax) < 40/100 then
InfoColour ("firebrick")
elseif (CurrentHealth/CurrentHealthMax) < 70/100 then
InfoColour ("darkorange")
elseif (CurrentHealth/CurrentHealthMax) < 100/100 then
InfoColour ("darkgreen")
elseif CurrentHealth then
InfoColour ("black")
end
Info ("Health:",CurrentHealth)

--Uncomment the next line and comment in the following that deal with the max value if you want to remove the max but keep the current value.
--Info (" ")
--following 7 lines will add the corresponding max value to the display.
if CurrentHealthMax then
InfoColour ("black")
Info ("/",CurrentHealthMax," ")
else
InfoColour ("black")
Info (" ")
end
--End CurrentHealth with Max

if (DisplayMana == "manaon") then
--CurrentMana
if (CurrentMana/CurrentManaMax) < 20/100 then
InfoColour ("crimson")
elseif (CurrentMana/CurrentManaMax) < 40/100 then
InfoColour ("firebrick")
elseif (CurrentMana/CurrentManaMax) < 70/100 then
InfoColour ("darkorange")
elseif (CurrentMana/CurrentManaMax) < 100/100 then
InfoColour ("darkgreen")
elseif CurrentMana then
InfoColour ("black")
end
Info ("Mana:",CurrentMana)

--Uncomment the next line and comment in the following that deal with the max value if you want to remove the max but keep the current value.
--Info (" ")
--following 7 lines will add the corresponding max value to the display.
if CurrentManaMax then
InfoColour ("black")
Info ("/",CurrentManaMax," ")
else
InfoColour ("black")
Info (" ")
end
--End CurrentMana with Max
end

--CurrentStun
if (CurrentStun/CurrentStunMax) < 20/100 then
InfoColour ("crimson")
elseif (CurrentStun/CurrentStunMax) < 40/100 then
InfoColour ("firebrick")
elseif (CurrentStun/CurrentStunMax) < 70/100 then
InfoColour ("darkorange")
elseif (CurrentStun/CurrentStunMax) < 90/100 then
InfoColour ("darkgreen")
elseif CurrentStun then
InfoColour ("black")
end
Info ("Stun:",CurrentStun)

--Uncomment the next line and comment in the following that deal with the max value if you want to remove the max but keep the current value.
--Info (" ")
--following 7 lines will add the corresponding max value to the display.
if CurrentStunMax then
InfoColour ("black")
Info ("/",CurrentStunMax," ")
else
InfoColour ("black")
Info (" ")
end
--End CurrentStun with Max

--CurrentStamina
if (CurrentStamina/CurrentStaminaMax) < 20/100 then
InfoColour ("crimson")
elseif (CurrentStamina/CurrentStaminaMax) < 40/100 then
InfoColour ("firebrick")
elseif (CurrentStamina/CurrentStaminaMax) < 70/100 then
InfoColour ("darkorange")
elseif (CurrentStamina/CurrentStaminaMax) < 90/100 then
InfoColour ("darkgreen")
elseif CurrentStamina then
InfoColour ("black")
end
Info ("Stam:",CurrentStamina)

--Uncomment the next line and comment in the following that deal with the max value if you want to remove the max but keep the current value.
--Info (" ")
--following 7 lines will add the corresponding max value to the display.
if CurrentStaminaMax then
InfoColour ("black")
Info ("/",CurrentStaminaMax," ")
else
InfoColour ("black")
Info (" ")
end
--End CurrentStamina with Max

--Adding Extra Spacing
InfoColour ("black")
Info (" | ")

--Time of Day
InfoColour ("black")
if CurrentTime == "dusk" then
InfoColour ("firebrick")
Info (CurrentTime, " ")
elseif CurrentTime == "late afternoon" then
InfoColour ("darkorange")
Info (CurrentTime , " ")
elseif CurrentTime == "unknown" then
InfoColour ("black")
Info ("underground", " ")
elseif CurrentTime then
InfoColour ("black")
Info (CurrentTime , " ")
end

--Walking/Running Status
InfoColour ("black")
if CurrentSpeed == "running" then
InfoColour ("firebrick")
elseif CurrentSpeed == "sneaking" then
InfoColour ("darkorange")
elseif CurrentSpeed then
InfoColour ("black")
end
Info (CurrentSpeed, " ")

--Armed/Unarmed Status
InfoColour ("black")
if CurrentArmed == "armed" then
InfoColour ("firebrick")
elseif CurrentArmed == "unarmed" then
InfoColour ("black")
elseif CurrentArmed then
InfoColour ("black")
end
Info (CurrentArmed, " ")


--Position. I.e. Standing or Fighting:Target Status
InfoColour ("black")
if CurrentPosition == "Fighting" then
InfoColour ("firebrick")
elseif CurrentPosition == "sleeping" then
InfoColour ("darkorange")
elseif CurrentPosition == "resting" then
InfoColour ("darkblue")
elseif CurrentPosition == "sitting" then
InfoColour ("darkgreen")
elseif CurrentPosition then
InfoColour ("black")
end
Info (CurrentPosition, " ")


end --- end detailed infobar ---

function DescriptiveInfobar(thename, theoutput, wildcards)

local CurrentAccent
CurrentAccent = wildcards [1]
local CurrentLanguage
CurrentLanguage = wildcards [2]
local CurrentMood
CurrentMood = wildcards [3]
local CurrentRiding
CurrentRiding = wildcards [4]
local CurrentTime
CurrentTime = wildcards [5]
local CurrentEncumbrance
CurrentEncumbrance = wildcards [6]
local CurrentArmed
CurrentArmed = wildcards [7]
local CurrentSpeed
CurrentSpeed = wildcards [8]
local CurrentHealth
CurrentHealth = tonumber(wildcards [9])
local CurrentHealthMax
CurrentHealthMax = tonumber(wildcards [10])
local CurrentStun
CurrentStun = tonumber(wildcards [11])
local CurrentStunMax
CurrentStunMax = tonumber(wildcards [12])
local CurrentStamina
CurrentStamina = tonumber(wildcards [13])
local CurrentStaminaMax
CurrentStaminaMax = tonumber(wildcards [14])
local CurrentMana
CurrentMana = tonumber(wildcards [15])
local CurrentManaMax
CurrentManaMax = tonumber(wildcards [16])
local CurrentPosition
CurrentPosition = wildcards [17]
local DisplayMana
DisplayMana = wildcards [18]-- string used to toggle mana display


--Setting up default look
InfoClear ()
InfoBackground ("wheat")
-- Disabling the font command because it's not required on windows and causes problems on linux.
-- InfoFont ("Arial",10,1) --Font, Size, Style
Info ("You're ")

--CurrentHealth
        if (CurrentHealth/CurrentHealthMax) < 5/100 then
                InfoColour ("crimson")
                Info ("at Death's door, ")
        elseif (CurrentHealth/CurrentHealthMax) < 15/100 then
                InfoColour ("crimson")
                Info ("nearly dead, ")
        elseif (CurrentHealth/CurrentHealthMax) < 30/100 then
                InfoColour ("firebrick")
                Info ("dying, ")
        elseif (CurrentHealth/CurrentHealthMax) < 66/100 then
                InfoColour ("darkorange")
                Info ("damaged, ")
        elseif (CurrentHealth/CurrentHealthMax) < 85/100 then
                InfoColour ("darkgreen")
                Info ("hurting, ")
        elseif (CurrentHealth/CurrentHealthMax) < 100/100 then
                InfoColour ("black")
                Info ("mostly unharmed, ")
end

--CurrentMana
        if (CurrentMana/CurrentManaMax) < 9/100 then
                InfoColour ("crimson")
                Info ("emptied, ")
        elseif (CurrentMana/CurrentManaMax) < 15/100 then
                InfoColour ("crimson")
                Info ("nearly tapped, ")
        elseif (CurrentMana/CurrentManaMax) < 35/100 then
                InfoColour ("firebrick")
                Info ("harmless, ")
        elseif (CurrentMana/CurrentManaMax) < 45/100 then
                InfoColour ("firebrick")
                Info ("weakened, ")
        elseif (CurrentMana/CurrentManaMax) < 55/100 then
                InfoColour ("darkorange")
                Info ("half yourself, ")
        elseif (CurrentMana/CurrentManaMax) < 60/100 then
                InfoColour ("darkgreen")
                Info ("somewhat strong, ")
        elseif (CurrentMana/CurrentManaMax) < 75/100 then
                InfoColour ("darkgreen")
                Info ("potent, ")
        elseif (CurrentMana/CurrentManaMax) < 100/100 then
                InfoColour ("black")
                Info ("brimming with power, ")
end

---CurrentStamina
        if (CurrentStamina/CurrentStaminaMax) < 5/100 then
                InfoColour ("crimson")
                Info ("done for, ")
        elseif (CurrentStamina/CurrentStaminaMax) < 15/100 then
                InfoColour ("crimson")
                Info ("practically crawling, ")
        elseif (CurrentStamina/CurrentStaminaMax) < 35/100 then
                InfoColour ("firebrick")
                Info ("exhausted, ")
        elseif (CurrentStamina/CurrentStaminaMax) < 65/100 then
                InfoColour ("darkorange")
                Info ("wearing down, ")
        elseif (CurrentStamina/CurrentStaminaMax) < 80/100 then
                InfoColour ("darkgreen")
                Info ("lightly fatigued, ")
end

--CurrentStun
        if (CurrentStun/CurrentStunMax) < 5/100 then
                InfoColour ("crimson")
                Info ("see only black, ")
        elseif (CurrentStun/CurrentStunMax) < 15/100 then
                InfoColour ("crimson")
                Info ("nearly unconcious, ")
        elseif (CurrentStun/CurrentStunMax) < 30/100 then
                InfoColour ("firebrick")
                Info ("mentally wracked, ")
        elseif (CurrentStun/CurrentStunMax) < 45/100 then
                InfoColour ("darkorange")
                Info ("woozy, ")
        elseif (CurrentStun/CurrentStunMax) < 65/100 then
                InfoColour ("darkgreen")
                Info ("dizzy, ")
end

--Armed/Unarmed Status
InfoColour ("black")
        if CurrentArmed == "armed" then
                InfoColour ("firebrick")
                Info ("armed, ")
        elseif CurrentArmed == "unarmed" then
                InfoColour ("black")
                Info ("unarmed, ")
end

--Riding
InfoColour ("black")
        if Riding then
                Info ("mounted, ")
        else 
                Info ("")
end


--Walking/Running Status
InfoColour ("black")
Info ("and set for ")
        if CurrentSpeed == "running" then
                InfoColour ("firebrick")
        elseif CurrentSpeed == "sneaking" then
                InfoColour ("darkorange")
        elseif CurrentSpeed then
                InfoColour ("black")
end
Info (CurrentSpeed, ". ")


--Position. I.e. Standing or Fighting:Target Status
InfoColour ("black")
Info ("Also, you're ")
if CurrentPosition == "Fighting" then
InfoColour ("firebrick")
elseif CurrentPosition == "sleeping" then
InfoColour ("darkorange")
elseif CurrentPosition == "resting" then
InfoColour ("darkblue")
elseif CurrentPosition == "sitting" then
InfoColour ("darkgreen")
elseif CurrentPosition then
InfoColour ("black")
end
Info (CurrentPosition, ". ")

--Time of Day
InfoColour ("black")
Info ("It's ")
if CurrentTime == "dusk" then
InfoColour ("firebrick")
Info (CurrentTime, " ")
elseif CurrentTime == "late afternoon" then
InfoColour ("darkorange")
Info (CurrentTime , " ")
elseif CurrentTime == "unknown" then
InfoColour ("black")
Info ("underground", " ")
elseif CurrentTime then
InfoColour ("black")
Info (CurrentTime , ". ")
end

end --- end descriptive infobar ---
