-- Script Created by Giant Cheese Wedge (AKA Blü)
-- Script Modified and fixed by Hoopsure

local crouched = false
local proned = false
-- https://docs.fivem.net/docs/game-references/controls/#controls

-- INPUT_MULTIPLAYER_INFO Z 엎드리기
local proneKey = 20
-- INPUT_DUCK LCTRL 웅크리기(앉기기)
local crouchKey = 36

-- INPUT_SPRINT	Left Shift
local sprintKey = 21
-- INPUT_ENTER F
local enterKey = 23
-- INPUT_MOVE_UP_ONLY W
local wkey = 32
-- INPUT_MOVE_DOWN_ONLY S
local sKey = 33
-- INPUT_MOVE_LEFT_ONLY A
local aKey = 34
-- INPUT_MOVE_RIGHT_ONLY D
local dKey = 35




Citizen.CreateThread( function()
	while true do
		Citizen.Wait( 1 )
		local ped = GetPlayerPed( -1 )
		if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
			ProneMovement()
			DisableControlAction( 0, proneKey, true )
			DisableControlAction( 0, crouchKey, true )
			if ( not IsPauseMenuActive() ) then
				if ( IsDisabledControlJustPressed( 0, crouchKey ) and not proned ) then
					RequestAnimSet( "move_ped_crouched" )
					RequestAnimSet("MOVE_M@TOUGH_GUY@")

					while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do
						Citizen.Wait( 100 )
					end
					while ( not HasAnimSetLoaded( "MOVE_M@TOUGH_GUY@" ) ) do
						Citizen.Wait( 100 )
					end
					if ( crouched and not proned ) then
						ResetPedMovementClipset( ped )
						ResetPedStrafeClipset(ped)
						SetPedMovementClipset( ped,"MOVE_M@TOUGH_GUY@", 0.5)
						crouched = false
					elseif ( not crouched and not proned ) then
						SetPedMovementClipset( ped, "move_ped_crouched", 0.55 )
						SetPedStrafeClipset(ped, "move_ped_crouched_strafing")
						crouched = true
					end
				elseif ( IsDisabledControlJustPressed(0, proneKey) and not crouched and not IsPedInAnyVehicle(ped, true) and not IsPedFalling(ped) and not IsPedDiving(ped) and not IsPedInCover(ped, false) and not IsPedInParachuteFreeFall(ped) and (GetPedParachuteState(ped) == 0 or GetPedParachuteState(ped) == -1) ) then
					if proned then
						ClearPedTasks(ped)
						local me = GetEntityCoords(ped)
						SetEntityCoords(ped, me.x, me.y, me.z-0.5)
						proned = false
					elseif not proned then
						RequestAnimSet( "move_crawl" )
						while ( not HasAnimSetLoaded( "move_crawl" ) ) do
							Citizen.Wait( 100 )
						end
						ClearPedTasksImmediately(ped)
						proned = true
						if IsPedSprinting(ped) or IsPedRunning(ped) or GetEntitySpeed(ped) > 5 then
							TaskPlayAnim(ped, "move_jump", "dive_start_run", 8.0, 1.0, -1, 0, 0.0, 0, 0, 0)
							Citizen.Wait(1000)
						end
						SetProned()
					end
				end
			end
		else
			proned = false
			crouched = false
		end
	end
end)

function SetProned()
	ped = PlayerPedId()
	ClearPedTasksImmediately(ped)
	TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_fwd", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
end


function ProneMovement()
	if proned then
		ped = PlayerPedId()
		DisableControlAction(0, enterKey)
		DisableControlAction(0, sprintKey)
		if IsControlPressed(0, wkey) or IsControlPressed(0, sKey) then
			DisablePlayerFiring(ped, true)
		 elseif IsControlJustReleased(0, wkey) or IsControlJustReleased(0, sKey) then
		 	DisablePlayerFiring(ped, false)
		 end
		if IsControlJustPressed(0, wkey) and not movefwd then
			movefwd = true
		    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_fwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 47, 1.0, 0, 0)
		elseif IsControlJustReleased(0, wkey) and movefwd then
		    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_fwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
			movefwd = false
		end
		if IsControlJustPressed(0, sKey) and not movebwd then
			movebwd = true
		    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_bwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 47, 1.0, 0, 0)
		elseif IsControlJustReleased(0, sKey) and movebwd then
		    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_bwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
		    movebwd = false
		end
		if IsControlPressed(0, aKey) then
			SetEntityHeading(ped, GetEntityHeading(ped)+2.0 )
		elseif IsControlPressed(0, dKey) then
			SetEntityHeading(ped, GetEntityHeading(ped)-2.0 )
		end
	end
end
