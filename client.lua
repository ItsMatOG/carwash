local isWashing = false
local particleToggle = false
local startLocation = { x = 50.31, y = -1392.57, z = 29.42 }
local particles = {
    {pos = vector3(41.440, -1389.143, 29.500), particle = "ent_amb_car_wash_jet", xRot = 90.0, nextWait = 0},
    {pos = vector3(41.440, -1389.143, 30.500), particle = "ent_amb_car_wash_jet", xRot = 90.0, nextWait = 0},
    {pos = vector3(41.430, -1394.497, 29.500), particle = "ent_amb_car_wash_jet", xRot = -90.0, nextWait = 0},
    {pos = vector3(41.430, -1394.497, 30.500), particle = "ent_amb_car_wash_jet", xRot = -90.0, nextWait = 2000},
    {pos = vector3(29.440, -1389.143, 29.500), particle = "ent_amb_car_wash_jet_soap", xRot = 90.0, nextWait = 0},
    {pos = vector3(29.440, -1389.143, 30.500), particle = "ent_amb_car_wash_jet_soap", xRot = 90.0, nextWait = 0},
    {pos = vector3(29.430, -1394.497, 29.500), particle = "ent_amb_car_wash_jet_soap", xRot = -90.0, nextWait = 0},
    {pos = vector3(29.430, -1394.497, 30.500), particle = "ent_amb_car_wash_jet_soap", xRot = -90.0, nextWait = 2000},
    {pos = vector3(22.440, -1389.143, 29.500), particle = "ent_amb_car_wash", xRot = 90.0, nextWait = 0},
    {pos = vector3(22.440, -1389.143, 30.500), particle = "ent_amb_car_wash", xRot = 90.0, nextWait = 0},
    {pos = vector3(22.430, -1394.497, 29.500), particle = "ent_amb_car_wash", xRot = -90.0, nextWait = 0},
    {pos = vector3(22.430, -1394.497, 30.500), particle = "ent_amb_car_wash", xRot = -90.0, nextWait = 2000},
    {pos = vector3(16.305, -1389.107, 29.500), particle = "ent_amb_car_wash_jet", xRot = 90.0, nextWait = 0},
    {pos = vector3(16.305, -1389.107, 30.500), particle = "ent_amb_car_wash_jet", xRot = 90.0, nextWait = 0},
    {pos = vector3(16.213, -1394.546, 29.500), particle = "ent_amb_car_wash_jet", xRot = -90.0, nextWait = 0},
    {pos = vector3(16.213, -1394.546, 30.500), particle = "ent_amb_car_wash_jet", xRot = -90.0, nextWait = 2000},
    {pos = vector3(4.305, -1389.107, 29.500), particle = "ent_amb_car_wash_steam", xRot = 90.0, nextWait = 0},
    {pos = vector3(4.305, -1389.107, 30.500), particle = "ent_amb_car_wash_steam", xRot = 90.0, nextWait = 0},
    {pos = vector3(4.213, -1394.546, 29.500), particle = "ent_amb_car_wash_steam", xRot = -90.0, nextWait = 0},
    {pos = vector3(4.213, -1394.546, 30.500), particle = "ent_amb_car_wash_steam", xRot = -90.0, nextWait = 0}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
	local plyCoords = GetEntityCoords(PlayerPedId(), 0)
        local startLocationdistance = #(vector3(startLocation.x, startLocation.y, startLocation.z) - plyCoords)
        if startLocationdistance < 10 then
            DrawMarker(25, startLocation.x, startLocation.y, startLocation.z-0.97, 0, 0, 0, 0, 0, 0, 1.0,1.0,0.8, 55, 90, 169, 214, 0, 0, 2, 0, 0, 0, 0)
            if IsPedSittingInAnyVehicle(ped) then 
                local vehicle = GetVehiclePedIsIn(ped, false)
                local dirtLevel = GetVehicleDirtLevel(vehicle)
                if startLocationdistance < 5 and GetPedInVehicleSeat(vehicle, -1) == ped then
                    DisplayHelpText("~w~Press ~INPUT_CONTEXT~ ~w~to enter the ~b~car wash~w~.")
                    if IsControlJustPressed(1, 51) then
                        if dirtLevel > 0.0 then
                            for i = 0, GetVehicleMaxNumberOfPassengers(vehicle) + 1, 1 do
                                local target = GetPedInVehicleSeat(vehicle, i)
                                if DoesEntityExist(target) then
                                    if IsPedAPlayer(target) then
                                        TriggerServerEvent("carwash:serversync", GetPlayerServerId(NetworkGetPlayerIndexFromPed(target)))
                                    end
                                end
                            end
                            washCar(vehicle)
                        else
                            isClean = true
                            Notify("~b~Carwash: ~w~Your vehicle is already clean.")
                        end
                    end
                end
            end
        end
    end
end)

function washCar(vehicle)
    isWashing = true
    local ped = PlayerPedId()
    local player = PlayerPedId(PlayerId())
    local netID = NetworkGetNetworkIdFromEntity(player)
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
    local boneIndex = GetEntityBoneIndexByName(vehicle, "chassis")
    
    SetEntityCoordsNoOffset(vehicle, vector3(49.190, -1392.024, 28.420), false, false, false)
    SetEntityHeading(vehicle, 92.158)

    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
    SetEveryoneIgnorePlayer(ped, true)
    SetPlayerControl(ped, false)

    DisplayHud(false)
    DisplayRadar(false)

    Wait(250)

    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, 1, 0)
    SetCamFov(cam, 40.0)
    ShakeCam(cam, "HAND_SHAKE", 3.0)
    AttachCamToVehicleBone(cam, vehicle, boneIndex, true, 0.0, 0.0, 0.0, 0.0, -8.0, 1.0, true)
    TaskVehicleDriveToCoord(ped, vehicle, vector3(-3.804, -1391.698, 28.302), 5.0, 0.0, GetEntityModel(vehicle), 262144, 1.0, 1000.0)
    TriggerServerEvent("Server:SoundToRadius", netID, 4, "carwash", 0.5)

    startParticles()

    DisplayHud(true)
    DisplayRadar(true)
    SetEveryoneIgnorePlayer(ped, false)
    SetPlayerControl(ped, true)
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 2000, 0, 0)
    SetVehicleDirtLevel(vehicle, 0.0)
    
    Wait(5000)
    endParticles()
    isWashing = false
    Notify("~b~Carwash ~w~Your vehicle is now ~g~clean~w~.")
end

RegisterNetEvent("carwash:startcarwash")
AddEventHandler("carwash:startcarwash", function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
    local boneIndex = GetEntityBoneIndexByName(vehicle, "chassis")

    SetPlayerControl(ped, false)
    DisplayHud(false)
    DisplayRadar(false)
    Wait(250)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, 1, 0)
    SetCamFov(cam, 40.0)
    ShakeCam(cam, "HAND_SHAKE", 3.0)
    AttachCamToVehicleBone(cam, vehicle, boneIndex, true, 0.0, 0.0, 0.0, 0.0, -8.0, 1.0, true)

    startParticles()

    DisplayHud(true)
    DisplayRadar(true)
    SetPlayerControl(ped, true)
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 2000, 0, 0)

    Wait(5000)
    endParticles()
end)

function startParticles()
    for i = 1, #particles do
        local currentParticle = particles[i]
        RequestNamedPtfxAsset("scr_carwash")
        UseParticleFxAssetNextCall("scr_carwash")
        while not HasNamedPtfxAssetLoaded("scr_carwash") do
            Wait(100)
        end

        particles[i].createdParticle = StartParticleFxLoopedAtCoord(currentParticle.particle, currentParticle.pos, currentParticle.xRot, 0.0, 0.0, 1.0, 0, 0, 0)
        if (currentParticle.nextWait > 0) then 
            Wait(currentParticle.nextWait)
        end
    end
end

function endParticles()
    for i = 1, #particles do
        local particle = particles[i].createdParticle
        StopParticleFxLooped(particle, 0)
        RemoveParticleFx(particle, 0)
        particles[i].createdParticle = nil
    end
end

function Notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 0, -1)
end
