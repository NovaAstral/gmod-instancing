DefaultInstance = "main"

function RecursiveSetPreventTransmit(ent,ply,stopTransmitting)
    if ent ~= ply and IsValid(ent) and IsValid(ply) then
        ent:SetPreventTransmit(ply, stopTransmitting)
        local tab = ent:GetChildren()
        for i = 1, #tab do
            RecursiveSetPreventTransmit(tab[i],ply,stopTransmitting)
        end
    end
end

--recursive set instance

function ent:GetInstance()
    if(ent.Instance != nil) then
        return ent.Instance
    else --if instance is nil, something is wrong
        ErrorNoHalt("[Nova Instancing] ",ent," Something went wrong, Entity instance is nil!")
    end
end

hook.Add("OnEntityCreated","InstaceCollisionRules",function(ent)
    ent:SetCustomCollisionCheck(true)
	ent:CollisionRulesChanged()
end)

hook.Add("ShouldCollide","InstanceCollisionCheck",function(ent1,ent2)
    if(ent1:GetInstance() == ent2:GetInstance() or ent1:GetInstance() == "global" or ent2:GetInstance() == "global") then
        return true
    else
        return false
    end
end)

hook.Add("InitPostEntity","InstanceInit",function()
    timer.Simple(0.1,function()
        for k,v in ipairs(ents.GetAll()) do
            v:SetCustomCollisionCheck(true)
	        v:CollisionRulesChanged()
            v:SetInstance("global") --Set all map props to global
        end
    end)
end)

local plySpawnedHookMDL = {"PlayerSpawnedEffect","PlayerSpawnedRagdoll","PlayerSpawnedProp"}
local plySpawnedHook = {"PlayerSpawnedNPC","PlayerSpawnedSENT","PlayerSpawnedSWEP","PlayerSpawnedVehicle"}

for k,hook in ipairs(plySpawnedHookMDL) do
    hook.Add(hook,"InstanceSpawnedHookMDL",function(ply,mdl,ent)
        if(IsValid(ent)) then
            ent:SetInstance(ply:GetInstance())
        end
    end)
end
-- there's probably a better way to do this
for k,hook in ipairs(plySpawnedHook) do
    hook.Add(hook,"InstanceSpawnedHook",function(ply,ent)
        if(IsValid(ent)) then
            ent:SetInstance(ply:GetInstance())
        end
    end)
end

local interactionHook = {"PhysgunPickup","AllowPlayerPickup","GravGunPickupAllowed","PlayerCanPickupWeapon","PlayerCanPickupItem","PlayerCanHearPlayersVoice","CanPlayerUnfreeze"}
for k,hook in ipairs(interactionHook) do
    hook.Add(hook,"InstancePlyInteractionHook",function(ply,ent)
        if(ply:GetInstance() != ent:GetInstance()) then
            return false
        end
    end)
end