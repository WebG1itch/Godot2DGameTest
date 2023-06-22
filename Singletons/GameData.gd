extends Node

var tower_data = {
	"GunT1": {
		"damage" : 20,
		"rof" : 1,
		"range" : 350,
		"category" : "Hitscan",
		"cost" : 50
	},
	"MissileT1": {
		"damage" : 100,
		"rof" : 3,
		"range" : 550,
		"category" : "Projectile",
		"cost" : 150
		
	}
}

var wave_data = {
	1 : [["BlueTank", 3], ["BlueTank", 3], ["BlueTank", 3]],
	2 : [["BlueTank", 1], ["BlueTank", 1], ["BlueTank", 1], ["BlueTank", 1]],
	3 : [["BlueTank", 1], ["BlueTank", 1], ["BlueTank", 1], ["BlueTank", 3], ["BlueTank", 1], ["BlueTank", 1], ["BlueTank", 1], ["BlueTank", 1]],
	4 : [["BlueTank", .5], ["BlueTank", .5], ["BlueTank", .5], ["BlueTank", .5], ["BlueTank", .5], ["BlueTank", .5], ["BlueTank", .5], ["BlueTank", .5]],
	5 : [["BlueTank", .5], ["BlueTank", .5], ["BlueTank", .5], ["BlueTank", .5], ["BlueTank", .5], ["BlueTank", .5], ["BlueTank", .5], ["BlueTank", 3], ["BlueTank", .5], ["BlueTank", .5], ["BlueTank", .5], ["BlueTank", .5], ["BlueTank", .5], ["BlueTank", .5], ["BlueTank", .5], ["BlueTank", .5]]
}
