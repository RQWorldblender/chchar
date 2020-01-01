-- get current model
local storage = minetest.get_mod_storage()

function chchar.get_player_model(player)
        if player:get_attribute("chchar:model_key") then
                storage:set_string(player:get_player_name(), player:get_attribute("chchar:model_key"))
                player:set_attribute("chchar:model_key", nil)
        end
        local model = storage:get_string(player:get_player_name())
        return chchar.get(model) or chchar.get(chchar.default)
end

-- Assign model to player
function chchar.assign_player_model(player, model)
        local model_obj
        if type(model) == "string" then
                model_obj = chchar.get(model)
        else
                model_obj = model
        end

        if not model_obj then
                return false
        end

        if model_obj:is_applicable_for_player(player:get_player_name()) then
                local model_key = model_obj:get_key()
                if model_key == chchar.default then
                        model_key = ""
                end
                storage:set_string(player:get_player_name(), model_key)
        else
                return false
        end
        return true
end

-- update visuals
function chchar.update_player_model(player)
    chchar.get_player_model(player):apply_model_to_player(player)
--[[
        if skins.armor_loaded then
                -- all needed is wrapped and implemented in 3d_armor mod
                armor:set_player_armor(player)
        else
                -- do updates manually without 3d_armor
                chchar.get_player_model(player):apply_model_to_player(player)
                if minetest.global_exists("sfinv") and sfinv.enabled then
                	sfinv.set_player_inventory_formspec(player)
                end
        end--]]
end

-- Assign and update - should be used on selection externally
function chchar.set_player_model(player, model)
        local success = chchar.assign_player_model(player, model)
        if success then
                chchar.get_player_model(player):set_model(player)
                chchar.update_player_model(player)
        end
        return success
end
