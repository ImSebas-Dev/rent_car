Config = {}

Config.esx = false -- Si es false, utilizará el framework qbcore en lugar del framework esx.

Config.CarSpawnName = 'dominator3' -- Selecciona el nombre del auto que aparece cuando lo llamas
Config.NPCModel = 'a_m_y_stlat_01' -- Seleccione el modelo del NPC desde aquí: https://docs.fivem.net/docs/game-references/ped-models/
Config.MaxDistance = 200 -- El carro se genera a una distancia aleatoria del usuario, aquí puedes establecer la distancia máxima desde el jugador a la que aparecerá el carro cuando se le llame. No escriba valores inferiores a 1 ni superiores a 200. Cuanto mayor sea el valor, más lejos aparecerá el carro.
Config.WaitTime = 2 -- La cantidad de tiempo en segundos que se debe esperar antes de que aparezca el carro y comience a conducir hacia la ubicación del usuario. También puedes establecer esto en 0 para que el carro aparezca inmediatamente.
Config.CanCallInsideVehicle = false -- Si es true, cualquier jugador puede pedir un carro dentro de cualquier vehículo. Recomendado: false.
Config.CommandName = "alquilar" -- El nombre del comando
Config.CommandCooldownTime = 5 -- La cantidad de tiempo cooldown entre el uso del comando en segundos, también puedes configurarlo en 0 para desactivar el cooldown.
Config.DeleteCar = true -- Si es true, el taxi se eliminará después de X segundos cuando el usuario salga del vehículo. (la hora se establece en Config.DeleteTaxiAfterTime) Recomendado: true.
Config.DeleteCarAfterTime = 10 -- El tiempo que se necesita para eliminar el carro después de que el usuario sale del vehículo, en segundos.
Config.Price = 125 -- El dinero que se necesita para llamar a un carro, establecido en 0 para ser gratis.

-- El script enviará registros a Discord cada vez que un usuario llame a un taxi en el WEBHOOK configurado en la parte superior de Server.lua (por razones de seguridad). 
Config.DiscordLogs = true
