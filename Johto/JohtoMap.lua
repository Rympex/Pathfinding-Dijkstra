
johto = {}

johto["New Bark Town"] =  {"Route 29=1"}
johto["Route 29"] = {"Cherrygrove City=1", "Route 29 Stop House=1", "New Bark Town=1"}
johto["Route 29 Stop House"] = {"Route 29=1", "Route 46=1"}
johto["Route 46"] = {"Route 29 Stop House=1"}--cannot move upper
johto["Cherrygrove City"] = {"Route 29=1", "Pokecenter Cherrygrove City=1", "Mart Cherrygrove City=1", "Route 30=1"}
johto["Pokecenter Cherrygrove City"] = {"Cherrygrove City=1"}
johto["Mart Cherrygrove City"] = {"Cherrygrove City=1"}
johto["Route 30"] = {"Cherrygrove City=1", "Route 31=1"}
johto["Route 31"] = {"Route 30=1", "Dark Cave South=1", "Violet City Stop House=1"} --digway
johto["Dark Cave South"] = {"Route 31=1"}
johto["Violet City Stop House"] = {"Route 31=1", "Violet City=1"}
johto["Violet City Gym Entrance"] = {"Violet City","Violet City Gym=1"}
johto["Violet City Gym"] = {"Violet City Gym Entrance=1"}
johto["Violet City Pokemart"] = {"Violet City=1"}
johto["Violet City School"] = {"Violet City=1"}
johto["Violet City Stop House"] = {"Violet City","Route 31=1"}
johto["Violet City"] = {"Route 32","Violet City Stop House","Route 36 Stop=1", "Violet City School","Violet City Pokemart","Sprout Tower F1","Violet City Gym Entrance","Pokecenter Violet City=1"}
--Route 36StopHouse
johto["Route 36 Stop House"] = {"Violet City=1"}
johto["Sprout Tower F1"] = {"Sprout Tower F2=1", "Violet City=1"}
johto["Sprout Tower F2"] = {"Sprout Tower F1=1"} --rework for f3
-- break
johto["Route 32"] = {--[["Ruins Of Alph Stop House", ]]"Route 33=1", "Pokecenter Route 32=1", "Union Cave 1F=1", "Violet City=1"}--not working usePokecenter
johto["Pokecenter Route 32"] = {"Route 32=1"}
johto["Union Cave 1F"] = {"Route 33=1", "Route 32=1"} --much much more (many exceptions)
johto["Route 33"] = {"Union Cave 1F=1", "Azalea Town=1"}
johto["Azalea Town"] = {"Route 33=1"}

return johto