local models_dir_list = minetest.get_dir_list(chchar.modpath.."/models")
local icons_dir_list = minetest.get_dir_list(chchar.modpath.."/textures")
table.insert(models_dir_list, 1, "character.b3d") -- Add the default model from player_api as the first model in this list

-- Load only the formats that are allowed to be loaded
local file_ext_2d = {"png", "jpg", "bmp", "tga", "pcx", "ppm", "psd", "wal", "rgb"}
local file_ext_3d = {"x", "b3d", "md2", "obj"}

for _, fn in pairs(models_dir_list) do
        local name, sort_id, assignment, is_preview, playername
        local nameparts = string.gsub(fn, "[.]", "_"):split("_")
        local filetype = nameparts[#nameparts]:lower()

        -- check allowed file extension (3D model)
        if table.indexof(file_ext_3d, filetype) > 0 then
                print("Found model file "..fn)
                -- cut filename extension
                table.remove(nameparts, #nameparts)

                -- check if optional icon exists
                has_icon = false
                iconname = ""
                for iconfile = 1, #icons_dir_list, 1 do
                    runname = icons_dir_list[iconfile]
                    iconparts = string.gsub(runname, "[.]", "_"):split("_")
                    if iconparts[1] == nameparts[1] and iconparts[2] == 'icon' and table.indexof(file_ext_2d, iconparts[3]) > 0 then
                        print("Found icon file "..runname)
                        has_icon = true
                        iconname = runname
                    end
                end

                -- Build technical model name
                name = table.concat(nameparts, '_')

                -- Get player name
                if nameparts[1] == "player" then
                    playername = nameparts[2]
                    table.remove(nameparts, 1)
                    sort_id = 0
                else
                    sort_id = 5000
                end
                
                -- Get sort index
                if tonumber(nameparts[#nameparts]) then
                    sort_id = sort_id + nameparts[#nameparts]
                end

                local model_obj = chchar.get(name) or chchar.new(name)

                model_obj:set_meta("codename", name)
                model_obj:set_meta("filename", fn)
                model_obj:set_meta("format", filetype)
                model_obj:set_icon(iconname)
                model_obj:set_meta("_sort_id", sort_id)
                if playername then
                    model_obj:set_meta("assignment", "player:"..playername)
                    model_obj:set_meta("playername", playername)
                end

                -- How to parse config files from https://stackoverflow.com/q/55523750
                local file = io.open(chchar.modpath.."/meta/"..name..".txt", "r")
                if file then
                    print("Found meta file for "..fn)
                    for line in file:lines() do
                        if line:find("name = ") ~= nil then
                            local data = line:split(" = ")
                            model_obj:set_meta("name", data[2])
                        elseif line:find("author = ") ~= nil then
                            local data = line:split(" = ")
                            model_obj:set_meta("author", data[2])
                        elseif line:find("license = ") ~= nil then
                            local data = line:split(" = ")
                            model_obj:set_meta("license", data[2])
                        elseif line:find("animation_speed = ") ~= nil then
                            local data = line:split(" = ")
                            model_obj:set_meta("animation_speed", data[2])
                        elseif line:find("stepheight = ") ~= nil then
                            local data = line:split(" = ")
                            model_obj:set_meta("stepheight", data[2])
                        elseif line:find("eye_height = ") ~= nil then
                            local data = line:split(" = ")
                            model_obj:set_meta("eye_height", data[2])
                        elseif line:find("collisionbox = ") ~= nil then
                            local data = line:split(" = ")
                            model_obj:set_meta("collisionbox", data[2]:split())
                        elseif line:find("textures = ") ~= nil then
                            local data = line:split(" = ")[2]:split()
                            if #data < 2 then
                                model_obj:set_meta("textures", {data})
                            else
                                model_obj:set_meta("textures", data)
                            end
                        elseif line:find("animations => ") ~= nil then
                            local data = line:split(" => ")[2]:split(";")
                            -- Inserting nested tables from https://stackoverflow.com/a/22598242
                            local animtable = {}
                            for item = 1, #data, 1 do
                                local subdata = data[item]:split(":")
                                local subnum = subdata[2]:split()
                                animname = subdata[1]
                                animtable[animname] = subnum
                            end
                            model_obj:set_meta("animations", animtable)
                        end
                    end
                    file:close()
                else
                    -- remove player / character prefix if further naming given
                    if nameparts[2] and not tonumber(nameparts[2]) then
                        table.remove(nameparts, 1)
                    end
                    model_obj:set_meta("name", table.concat(nameparts, ' '))
                end

                -- Register model with player_api, excluding the default model
                if fn ~= "character.b3d" then
                    player_api.register_model(fn, {
                        animation_speed = model_obj:get_meta("animation_speed") or 30,
                        textures = model_obj:get_meta("textures") or {"blank.png"},
                        animations = model_obj:get_meta("animations") or {},
                        collisionbox = model_obj:get_meta("collisionbox") or {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
                        stepheight = model_obj:get_meta("stepheight") or 0.6,
                        eye_height = model_obj:get_meta("eye_height") or 1.47,
                    })
                    print("registered model "..fn)
                end
        end
end

local function models_sort(modelslist)
        table.sort(modelslist, function(a,b)
                local a_id = a:get_meta("_sort_id") or 10000
                local b_id = b:get_meta("_sort_id") or 10000
                if a_id ~= b_id then
                        return a:get_meta("_sort_id") < b:get_meta("_sort_id")
                else
                        return a:get_meta("name") < b:get_meta("name")
                end
        end)
end
--[[
-- (obsolete) get skinlist. If assignment given ("mod:wardrobe" or "player:bell07") select skins matches the assignment. select_unassigned selects the skins without any assignment too
function skins.get_skinlist(assignment, select_unassigned)
        minetest.log("deprecated", "skins.get_skinlist() is deprecated. Use skins.get_skinlist_for_player() instead")
        local skinslist = {}
        for _, skin in pairs(skins.meta) do
                if not assignment or
                                assignment == skin:get_meta("assignment") or
                                (select_unassigned and skin:get_meta("assignment") == nil) then
                        table.insert(skinslist, skin)
                end
        end
        skins_sort(skinslist)
        return skinslist
end
--]]
-- Get modellist for player. If no player given, public models only selected
function chchar.get_modellist_for_player(playername)
        local modelslist = {}
        for _, model in pairs(chchar.meta) do
                if model:is_applicable_for_player(playername) and model:get_meta("in_inventory_list") ~= false then
                        table.insert(modelslist, model)
                end
        end
        models_sort(modelslist)
        return modelslist
end

-- Get modellist selected by metadata
function chchar.get_modellist_with_meta(key, value)
        assert(key, "key parameter for chchar.get_modellist_with_meta() missed")
        local modelslist = {}
        for _, model in pairs(chchar.meta) do
                if model:get_meta(key) == value then
                        table.insert(modelslist, model)
                end
        end
        models_sort(modelslist)
        return modelslist
end
