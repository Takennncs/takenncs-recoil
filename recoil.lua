local recoilStep = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if not IsPedArmed(cache.ped, 6) then
            Citizen.Wait(1500)
        end

        if IsPedShooting(cache.ped) then
            local GamePlayCam = GetFollowPedCamViewMode()
            local Vehicled = IsPedInAnyVehicle(cache.ped, false)
            local MovementSpeed = math.ceil(GetEntitySpeed(cache.ped))

            if MovementSpeed > 69 then
                MovementSpeed = 69
            end

            local _, wep = GetCurrentPedWeapon(cache.ped)
            local group = GetWeapontypeGroup(wep)
            local p = GetGameplayCamRelativePitch()
            local h = GetGameplayCamRelativeHeading()
            local cameraDistance = #(GetGameplayCamCoord() - GetEntityCoords(cache.ped))

            local baseRecoil = math.random(130, 140 + (math.ceil(MovementSpeed * 1.5))) / 100
            local rifle = false

            if group == 970310034 or group == 1159398588 then
                rifle = true
            end

            if cameraDistance < 5.3 then
                cameraDistance = 1.5
            elseif cameraDistance < 8.0 then
                cameraDistance = 4.0
            else
                cameraDistance = 7.0
            end

            if Vehicled then
                baseRecoil = baseRecoil + (baseRecoil * cameraDistance)
            else
                baseRecoil = baseRecoil * 1.2
            end

            if GamePlayCam == 4 then
                baseRecoil = baseRecoil * 0.7
                if rifle then
                    baseRecoil = baseRecoil * 1.2
                end
            end

            if rifle then
                baseRecoil = baseRecoil * 1.2
            end

            local horizontalOffset = 0
            local verticalOffset = 0

            local horDir = (recoilStep % 2 == 0) and -1 or 1

            local horStrength = baseRecoil * (0.3 + math.random() * 0.3)

            local vertStrength = baseRecoil * (-0.4 + math.random() * 0.8)

            horizontalOffset = horDir * horStrength
            verticalOffset = vertStrength

            if Vehicled then
                horizontalOffset = horizontalOffset * 2.0
            end

            SetGameplayCamRelativeHeading(h + horizontalOffset)
            SetGameplayCamRelativePitch(p + verticalOffset, 0.8)

            recoilStep = recoilStep + 1
        end
    end
end)
