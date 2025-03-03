if Config.esx then
    ESX = exports["es_extended"]:getSharedObject()
else
    QBCore = exports['qb-core']:GetCoreObject()
end

commandCooldown = false
commandCooldownTime = Config.CommandCooldownTime * 1000
vehicle = nil
driver = nil
done = false
flag = false

function CallCar()
    if commandCooldown then
        if Config.esx then
            ESX.ShowNotification("No puedes utilizar este comando ahora. Espere por favor.")
        else
            QBCore.Functions.Notify("No puedes utilizar este comando ahora. Espere por favor.")
        end
        return
    end

    if Config.CanCallInsideVehicle == false then
        -- Verifica si el jugador ya está en un vehículo. Si el jugador está en un vehículo, notifique y cancele.
        if IsPedInAnyVehicle(PlayerPedId()) then
            if Config.esx then
                ESX.ShowNotification("Estás dentro de un vehículo, ¡bájate para llamar un carro!")
            else
                QBCore.Functions.Notify("Estás dentro de un vehículo, ¡bájate para llamar un carro!")
            end
            return
        end
    end

    if not DoesEntityExist(vehicle) then -- Si el jugador ya ha llamado un carro, notifíquele y cancele

        Wait(1000)
        if flag then
            return -- Detener la ejecución del código si la variable es "true"
        end

        commandCooldown = true
        SetTimeout(commandCooldownTime, function()
            commandCooldown = false
        end)

        RequestModel(Config.CarSpawnName)
        while not HasModelLoaded(Config.CarSpawnName) do
            Wait(0)
        end

        if Config.esx then
            ESX.ShowNotification("¡Has llamado con éxito un carro!")
        else
            QBCore.Functions.Notify("¡Has llamado con éxito un carro!")
        end

        -- Consigue las coordenadas del jugador y luego genera el taxi al lado de ellos.
        Wait(Config.WaitTime * 1000)
        local pCoords = GetEntityCoords(PlayerPedId())
        local f, rp, heading = GetClosestVehicleNodeWithHeading(pCoords.x - math.random(-1, Config.MaxDistance),
            pCoords.y - math.random(-1, Config.MaxDistance), pCoords.z, 12, 3.0, 0)
        vehicle = CreateVehicle(Config.CarSpawnName, rp, outHeading, true, false)

        -- Solicita el modelo Ped (conductor NPC) desde la configuración
        local Model = Config.NPCModel
        if DoesEntityExist(vehicle) then
            RequestModel(Model)
            while not HasModelLoaded(Model) do
                Wait(0)
            end

            -- Crea el ped dentro del auto.
            driver = CreatePedInsideVehicle(vehicle, 26, Model, -1, true, false)
            SetModelAsNoLongerNeeded(vehicle)

            SetBlockingOfNonTemporaryEvents(driver, true)
            SetEntityAsMissionEntity(driver, true, true)
            SetEntityInvincible(driver, true)
        end

        SetVehicleOnGroundProperly(vehicle)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleEngineOn(vehicle, true, true, false)

        SetDriveTaskDrivingStyle(driver, 1074528293)
        TaskVehicleDriveToCoord(driver, vehicle, pCoords.x, pCoords.y, pCoords.z, 26.0, 0, Config.CarSpawnName, 411,
            10.0)
        SetPedKeepTask(driver, true)

        if Config.esx then
            ESX.ShowNotification("Tu carro estará aquí en los próximos segundos.")
        else
            QBCore.Functions.Notify("Tu carro estará aquí en los próximos segundos.")
        end

        while #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) > 10.0 do
            Wait(500)
        end

        -- Borrar Carro

        TaskLeaveVehicle(driver, vehicle, 1)
        SetEntityAsMissionEntity(driver, false, false)
        SetEntityAsMissionEntity(vehicle, false, false)
        SetPedKeepTask(driver, false)
        TaskWanderStandard(driver, 10.0, 10)
        Wait(6000)
        DeletePed(driver)
        DeleteEntity(driver)
        driver = nil

        if Config.DeleteCar then
            while true do
                if GetVehiclePedIsIn(PlayerPedId(), false) == vehicle then
                    while GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() do
                        Wait(100)
                    end
                    Wait(Config.DeleteCarAfterTime * 1000)
                    DeleteEntity(vehicle)
                    break
                end
                Wait(100)
            end
        end
    else
        if Config.esx then
            ESX.ShowNotification("Tu carro ya está aquí/viene")
        else
            QBCore.Functions.Notify("Tu carro ya está aquí/viene")
        end
    end

end

RegisterCommand(Config.CommandName, function()
    local playerPed = PlayerPedId()

    -- Inicia el escenario de llamada telefónica
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_STAND_MOBILE_CLUBHOUSE", 0, true)

    -- Notifica al servidor para procesar el cobro
    TriggerServerEvent("rental:pay")

    -- Detiene la animación después de un tiempo
    SetTimeout(10000, function() -- Cambia el tiempo si quieres que dure más
        ClearPedTasks(playerPed)
    end)
    CallCar()
end)
