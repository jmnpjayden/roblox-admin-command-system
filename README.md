# | Demo
https://youtu.be/U9_097GbTu0
![Demo](https://raw.githubusercontent.com/jmnpjayden/roblox-admin-command-system/main/Admin%20Command%20System%20GIF.gif)# Roblox Admin Command System
A modular admin command system built in Lua for Roblox, designed to manage game states, player data, and custom administrative controls in real time. 

# | Features
- Command-based admin system using chat prefixes (;)
- Group-based permission system
- Real-time game state control (Permanent Death System)
- Player Data Manipulation:
  - Set currency (Ryo)
  - Set skill points
  - Set rank, title, village, and gender
- Dynamic UI feedback using Tween animations anad custom made user-interface
- Intergrated notification system
- Partial username matching

# | Example Commands
- ;pdon
- ;pdoff
- ;setryo username 1000
- ;setsp username 1000
- ;setrank username 5
- ;setvillage username Leaf

# | System Design
- Modular command handler using a command table
- Event-driven architecture using RemoteEvents
- Input validation for all commands
- Separation between UI, logic, and data handling
