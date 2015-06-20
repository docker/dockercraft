Implements some of the basic commands needed to run a simple server.

# Commands

### General
| Command | Permission | Description |
| ------- | ---------- | ----------- |
|/back | core.back | Return to your last position|
|/ban | core.ban | Ban a player|
|/clear | core.clear | Clear the inventory of a player|
|/difficulty | core.difficulty | Change world's difficulty.|
|/do | core.do | Runs a command as a player.|
|/enchant | core.enchant | Adds an enchantment to the specified player's held item|
|/fly | core.fly |  ~ Toggle fly|
|/gamemode | core.changegm | Change your gamemode|
|/give | core.give | Give someone an item|
|/help | core.help | Show available commands|
|/ienchant | core.enchant.self | Add an enchantment to an item|
|/item | core.item | Give yourself an item.|
|/kick | core.kick | Kick a player|
|/kill | core.kill | Kill a player|
|/list | core.list | Lists all connected players|
|/listranks | core.listranks | List all the available ranks|
|/locate | core.locate | Show your current server coordinates|
|/me | core.me | Broadcast what you are doing|
|/motd | core.motd | Show message of the day|
|/plugins | core.plugins | Show list of plugins|
|/portal | core.portal | Move to a different world|
|/rank | core.rank | View or set a player's rank|
|/regen | core.regen | Regenerates a chunk|
|/reload | core.reload | Reload all plugins|
|/save-all | core.save-all | Save all worlds|
|/setspawn | core.setspawn | Change world spawn|
|/spawn | core.spawn | Return to the spawn|
|/stop | core.stop | Stops the server|
|/sudo | core.sudo | Runs a command as a player|
|/tell | core.tell | Send a private message|
|/time |  | Set or display the time|
|/time add | core.time.set | Add the amount given to the current time|
|/time day | core.time.set | Set the time to day|
|/time night | core.time.set | Set the time to night|
|/time query daytime | core.time.query.daytime | Display the current time|
|/time query gametime | core.time.query.gametime | Display the amount of time elapsed since start|
|/time set | core.time.set | Set the time to the value given|
|/toggledownfall | core.toggledownfall | Toggles the weather between clear skies and rain|
|/top | core.top | Teleport yourself to the topmost block|
|/tp | core.teleport | Teleport yourself to a player|
|/tpa | core.tpa | Ask to teleport yourself to a player|
|/tpaccept | core.tpaccept | Accept a teleportation request|
|/tpahere | core.tpahere |  ~ Ask to teleport player to yourself|
|/tpdeny | core.tpdeny |  ~ Deny a teleportation request|
|/tphere | core.tphere |  ~ Teleport player to yourself|
|/tps | core.tps | Returns the tps (ticks per second) from the server.|
|/unban | core.unban | Unban a player|
|/unsafegive | core.give.unsafe | Give someone an item, even if it is blacklisted.|
|/unsafeitem | core.item.unsafe | Give yourself an item, even if it is blacklisted.|
|/vanish | core.vanish |  - Vanish|
|/viewdistance | core.viewdistance | Change your view distance|
|/weather | core.weather | Change world's weather|
|/whitelist |  | Manages the whitelist|
|/whitelist add | core.whitelist | Adds a player to the whitelist|
|/whitelist list | core.whitelist | Shows the players on the whitelist|
|/whitelist off | core.whitelist | Turns whitelist processing off|
|/whitelist on | core.whitelist | Turns whitelist processing on|
|/whitelist remove | core.whitelist | Removes a player from the whitelist|
|/worlds | core.worlds | Shows a list of all the worlds|



# Permissions
| Permissions | Description | Commands | Recommended groups |
| ----------- | ----------- | -------- | ------------------ |
| core.back |  | `/back` |  |
| core.ban |  | `/ban` |  |
| core.changegm | Allows players to change gamemodes | `/gamemode` | admins |
| core.clear |  | `/clear` |  |
| core.difficulty |  | `/difficulty` |  |
| core.do |  | `/do` |  |
| core.enchant | Allows players to add an enchantment to a player's held item | `/enchant` | admins |
| core.enchant.self | Allows players to add an enchantment to their own held item | `/ienchant` | admins |
| core.fly |  | `/fly` |  |
| core.give | Allows players to give items to other players | `/give` | admins |
| core.give.unsafe | Allows players to give items to other players, even if the item is blacklisted | `/unsafegive` | none |
| core.help |  | `/help` |  |
| core.item | Allows players to give items to themselves | `/item` | admins |
| core.item.unsafe | Allows players to give items to themselves, even if the item is blacklisted | `/unsafeitem` | none |
| core.kick |  | `/kick` |  |
| core.kill |  | `/kill` |  |
| core.list |  | `/list` |  |
| core.listranks |  | `/listranks` |  |
| core.locate |  | `/locate` |  |
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
| core.tell |  | `/tell` |  |
| core.time.query.daytime | Allows players to display the time of day | `/time query daytime` | everyone |
| core.time.query.gametime | Allows players to display how long the world has existed | `/time query gametime` |  |
| core.time.set | Allows players to set the time of day | `/time night`, `/time day`, `/time set`, `/time add` | admins |
| core.toggledownfall | Allows players to toggle the weather between clear skies and rain | `/toggledownfall` | admins |
| core.top |  | `/top` |  |
| core.tpa |  | `/tpa` |  |
| core.tpaccept |  | `/tpaccept` |  |
| core.tpahere |  | `/tpahere` |  |
| core.tpdeny |  | `/tpdeny` |  |
| core.tphere |  | `/tphere` |  |
| core.tps |  | `/tps` |  |
| core.unban |  | `/unban` |  |
| core.vanish |  | `/vanish` |  |
| core.viewdistance |  | `/viewdistance` |  |
| core.weather | Allows players to change the weather | `/weather` | admins |
| core.whitelist | Allows players to manage the whitelist | `/whitelist off`, `/whitelist list`, `/whitelist remove`, `/whitelist on`, `/whitelist add` | admins |
| core.worlds |  | `/worlds` |  |
