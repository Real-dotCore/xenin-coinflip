# Last update : 18.08 at 00:16 by dotCore    
  
## How to change "vip" ranks ?    
1) Go in lua/coinflip/networking/server.lua  
2) Go at line 12, you should find the VIPRanksTable{}  
3) Edit groups here (there's example template, follow them)  
4) Go in lua/coinflip/ui/games.lua  
5) Go at line 7, you should find the VIPRanksTable{}  
6) Edit groups here (there's example template, follow them)  
  
## How to change the number of max coinflips for VIPs ?  
1) Go in lua/coinflip/configuration/config.lua  
2) Find cfg:SetMaxVIPCoinflips  
3) Edit num between ()  
  
  
#### Made by dotCore  
#### Thanks for using this !  
