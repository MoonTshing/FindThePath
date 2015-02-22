# FindThePath
Game Design


Objective

Created based on puzzle game theory. Player finds the path to problems and then chooses types of questions, solves it and gains the access to next level. Levels are “randomly” unlocked based on the performance of previous level.


Gameplay Mechanics

The game uses normal platformer physics. A player uses key the open a right door to enter the problems room. To get the key, the player needs to move the jigsaw puzzle pieces to determine the movement path and then move, jump, climb to get the key. After gaining the key, the player deduces the right door to open. In the problems room, the player chooses a category of questions and answers it to unlock next level.

The player can restart the current level to the first point when he got stuck by questions. Or they can use coins earned from pervious levels to buy a hint.

Level Design

The key point of level design would be the way to get key and the hint to open the right door. In addition, player need to figure out the right path to get 

Since this is a game of combination of puzzle game and active game, levels should be laid out horizontally. The default level is the newest level, but the player can whichever level among choose looked levels.

Technical

Scenes

Main Menu
Level Select
Gameplay

Controls/Input

Tap and swipe based controls
Tap and hold to move the puzzle pieces
Swipe down to slide
Tap to jump
When near ladder, swipe up/down to climb
Tap the restart button to renew the level


Classes/CCBs

Scenes
Main Menu
Level Select
Gameplay

Nodes/Sprites
Entity (abstract superclass)
Player
WorldObject (abstract superclass)
Keys
Doors
Puzzle pieces
Coins


MVP Milestones

Week 1 (2/17 - 2/24/2015)

Implement platformer physics
Collect source material
Create entities and objects
Add movement to all entities/objects	
Jumping
Sliding		
Control scheme for player
Week 2 (2/24 - 3/3/2015) - finishing a playable build

Implement keys and Doors
Coin counter
Restart implementation
Start implementing objects immune to rewind
Week 3 (3/3 - 3/10/2015)

Finish and polish rewind implementation
Level design
Save user data -- how many bacon collected in each level
Week 4 (3/10 - 3/17/2015) - finishing core gameplay

Refine levels -- playtest even more often!!
Refine control scheme
Week 5 (3/17 - 3/24/2015)

Level select scene
Determine what other polish is needed
Week 6 (3/24 - 4/1/2015) - finishing the polish

Work on rewinding particle effects
Integrate analytics
Screenshots
Write game description for App store
Play around with Apportable to see if Android release is feasible
