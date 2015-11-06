Implements some of the basic commands needed to run a simple server.

# Commands

### General
| Command | Permission | Description |
| ------- | ---------- | ----------- |
|/ban | core.ban | Bans a player.|
|/clear | core.clear | Clears the inventory of a player.|
|/difficulty | core.difficulty | Changes the difficulty level of the world you're located in.|
|/do | core.do | Runs a command as a player.|
|/enchant | core.enchant | Adds an enchantment to a specified player's held item.|
|/gamemode | core.changegm | Changes a player's gamemode.|
|/give | core.give | Gives an item to a player.|
|/help | core.help | Shows available commands.|
|/ienchant | core.enchant.self | Adds an enchantment to an item.|
|/item | core.item | Gives your player an item.|
|/kick | core.kick | Kicks a player.|
|/kill | core.kill | Kills a player.|
|/list | core.list | Shows a list of connected players.|
|/listranks | core.listranks | Shows a list of the available ranks.|
|/me | core.me | Broadcasts what you are doing.|
|/motd | core.motd | Shows the message of the day.|
|/plugins | core.plugins | Shows a list of the plugins.|
|/portal | core.portal | Moves your player to a different world.|
|/r | core.tell | Replies to the latest private message you recieved.|
|/rank | core.rank | Shows or sets a player's rank.|
|/regen | core.regen | Regenerates a chunk.|
|/reload | core.reload | Reloads all plugins.|
|/save-all | core.save-all | Saves all worlds.|
|/setspawn | core.setspawn | Changes the world's spawn point.|
|/spawn | core.spawn | Returns a player to the spawn point.|
|/stop | core.stop | Stops the server.|
|/sudo | core.sudo | Runs a command as a player, ignoring permissions.|
|/tell | core.tell | Sends a private message to a player.|
|/time |  | Sets or displays the time.|
|/time add | core.time.set | Adds a given value to the current time.|
|/time day | core.time.set | Sets the time to day.|
|/time night | core.time.set | Sets the time to night.|
|/time query daytime | core.time.query.daytime | Displays the current time.|
|/time query gametime | core.time.query.gametime | Displays the amount of time elapsed since start.|
|/time set | core.time.set | Sets the time to a given value.|
|/toggledownfall | core.toggledownfall | Toggles the weather between clear skies and rain.|
|/tp | core.teleport | Teleports your player to another player.|
|/unban | core.unban | Unbans a player.|
|/unsafegive | core.give.unsafe | Gives an item to a player, even if the item is blacklisted.|
|/unsafeitem | core.item.unsafe | Gives your player an item, even if the item is blacklisted.|
|/viewdistance | core.viewdistance | Changes your view distance.|
|/weather | core.weather | Changes the world's weather.|
|/whitelist |  | Manages the whitelist.|
|/whitelist add | core.whitelist | Adds a player to the whitelist.|
|/whitelist list | core.whitelist | Shows a list of all players on the whitelist.|
|/whitelist off | core.whitelist | Turns whitelist processing off.|
|/whitelist on | core.whitelist | Turns whitelist processing on.|
|/whitelist remove | core.whitelist | Removes a player from the whitelist.|
|/worlds | core.worlds | Shows a list of all the worlds.|



# Permissions
| Permissions | Description | Commands | Recommended groups |
| ----------- | ----------- | -------- | ------------------ |
| core.ban |  | `/ban` |  |
| core.changegm | Allows players to change gamemodes. | `/gamemode` | admins |
| core.clear |  | `/clear` |  |
| core.difficulty |  | `/difficulty` |  |
| core.do |  | `/do` |  |
| core.enchant | Allows players to add an enchantment to a player's held item. | `/enchant` | admins |
| core.enchant.self | Allows players to add an enchantment to their own held item. | `/ienchant` | admins |
| core.give | Allows players to give items to other players. | `/give` | admins |
| core.give.unsafe | Allows players to give items to other players, even if the item is blacklisted. | `/unsafegive` | none |
| core.help |  | `/help` |  |
| core.item | Allows players to give items to themselves. | `/item` | admins |
| core.item.unsafe | Allows players to give items to themselves, even if the item is blacklisted. | `/unsafeitem` | none |
| core.kick |  | `/kick` |  |
| core.kill |  | `/kill` |  |
| core.list |  | `/list` |  |
| core.listranks |  | `/listranks` |  |
| core.me |  | `/me` |  |
| core.motd |  | `/motd` |  |
| core.plugins |  | `/plugins` |  |
| core.portal |  | `/portal` |  |
| core.rank |  | `/rank` |  |
| core.regen |  | `/regen` |  |
| core.reload |  | `/reload` |  |
| core.save-all |  | `/save-all` |  |
| core.setspawn |  | `/setspawn` |  |
| core.spawn |  | `/spawn` |  |
| core.stop |  | `/stop` |  |
| core.sudo |  | `/sudo` |  |
| core.teleport |  | `/tp` |  |
| core.tell |  | `/r`, `/tell` |  |
| core.time.query.daytime | Allows players to display the time of day. | `/time query daytime` | everyone |
| core.time.query.gametime | Allows players to display how long the world has existed. | `/time query gametime` |  |
| core.time.set | Allows players to set the time of day. | `/time night`, `/time day`, `/time set`, `/time add` | admins |
| core.toggledownfall | Allows players to toggle the weather between clear skies and rain. | `/toggledownfall` | admins |
| core.unban |  | `/unban` |  |
| core.viewdistance |  | `/viewdistance` |  |
| core.weather | Allows players to change the weather. | `/weather` | admins |
| core.whitelist | Allows players to manage the whitelist. | `/whitelist off`, `/whitelist list`, `/whitelist remove`, `/whitelist on`, `/whitelist add` | admins |
| core.worlds |  | `/worlds` |  |
