-- xmobar config used by Vic Fryzel
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config
--
-- customized by Jesse Hallett
-- http://github.com/hallettj/config_files

-- This is setup for 1920x1080 monitors
Config {
    font = "xft:Ubuntu Mono derivative Powerline:size=8:antialias=true"
    bgColor = "#002b36",
    fgColor = "#839496",
    position = Static { xpos = 0, ypos = 0, width = 1808, height = 16 },
    lowerOnStart = True,
    commands = [
        Run Weather "KPAO" ["-t","<tempC>°C <skyCondition>","-L","64","-H","77","-n","#859900","-h","#cb4b16","-l","#2aa198"] 36000,
        Run MultiCpu ["-t","Cpu: <total0> <total1> <total2> <total3>","-L","30","-H","60","-h","#859900","-l","#859900","-n","#859900","-w","3"] 10,
        Run Memory ["-t","Mem: <usedratio>%","-H","8192","-L","4096","-h","#859900","-l","#859900","-n","#859900"] 10,
        Run Swap ["-t","Swap: <usedratio>%","-H","1024","-L","512","-h","#FFB6B0","-l","#859900","-n","#FFFFCC"] 10,
        Run Network "eth0" ["-t","Net: <rx>, <tx>","-H","200","-L","10","-h","#FFB6B0","-l","#859900","-n","#FFFFCC"] 10,
        Run Date "%a %b %_d %l:%M" "date" 10,
        Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = "%StdinReader% }{ %memory%   %swap%   <fc=#93a1a1>%date%</fc>   %KPAO%"
}
