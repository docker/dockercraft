This plugin lets VIP users define areas of the world where only specified users are allowed to build and dig.

An area is defined by the VIP by using a Wand item (by default, a stick with a meta 1) by left-clicking and right-clicking in two opposite corners of the area, then issuing a /protection add command. Multiple users can be allowed in a single area. There is no hardcoded limit on the number of areas or the number of players allowed in a single area. Areas can overlap; in such a case, if a user is allowed in any one of the overlapping areas, they are allowed to build / dig.

The protected areas are stored in an SQLite database in a file "ProtectionAreas.sqlite" that is created next to the MCServer executable. The plugin has its configuration options stored in a "ProtectionAreas.ini" file. 	

# Configuration
The configuration is stored in the ProtectionAreas.ini file next to the MCServer executable in a regular manner.

The wand item can be specified in the configuration. By default, a stick with meta 1 is used, but any valid item can be used. Stored in the [ProtectionAreas].WandItem value.

If there is no area, players can be either allowed to interact freely or not at all, based on the setting in the [ProtectionAreas].AllowInteractNoArea value. Accepted values are 0 and 1. 			

# Commands

### General
| Command | Permission | Description |
| ------- | ---------- | ----------- |
|/protection add | protection.add | adds a new protected area using wand|
|/protection addc | protection.add | adds a new protected area with explicitly specified coordinates|
|/protection del | protection.del | deletes the specified area.|
|/protection list | protection.list | lists all areas in the specified place|
|/protection user add | protection.user.add | adds the specified users to the allowed users in the specified area|
|/protection user list | protection.user.list | lists all the allowed users for the specified area|
|/protection user remove | protection.user.remove | removes the specified users from the allowed users in the specified area|
|/protection user strip | protection.user.strip | removes the user from all areas in this world|
|/protection wand | protection.wand | gives the Wand item|



# Permissions
| Permissions | Description | Commands | Recommended groups |
| ----------- | ----------- | -------- | ------------------ |
| protection.add |  | `/protection addc`, `/protection add` |  |
| protection.del |  | `/protection del` |  |
| protection.list |  | `/protection list` |  |
| protection.user.add |  | `/protection user add` |  |
| protection.user.list |  | `/protection user list` |  |
| protection.user.remove |  | `/protection user remove` |  |
| protection.user.strip |  | `/protection user strip` |  |
| protection.wand |  | `/protection wand` |  |
