local S = chchar.S

local function show_selection_formspec(player)
        local context = chchar.get_formspec_context(player)
        local name = player:get_player_name()
        local model = chchar.get_player_model(player)
        local formspec = "size[8,8]"..chchar.get_model_info_formspec(model)
        formspec = formspec..chchar.get_model_selection_formspec(player, context, 3.5)
        minetest.show_formspec(name, 'chchar_show_ui', formspec)
end


minetest.register_chatcommand("chchar", {
        params = "[set] <model key> | show [<model key>] | list | list private | list public | reset | [ui]",
        description = S("Show, list or set player's model"),
        func = function(name, param)
                local player = minetest.get_player_by_name(name)
                if not player then
                        return false, S("The player").." "..name.." "..S("was not found.")
                end

                -- parse command line
                local command, parameter
                local words = param:split(" ")
                local word = words[1]
                if word == 'set' or word == 'list' or word == 'reset' or word == 'show' or word == 'ui' then
                        command = word
                        parameter = words[2]
                elseif chchar.get(word) then
                        command = 'set'
                        parameter = word
                elseif not word then
                        command = 'ui'
                else
                        return false, S("Unknown command").." "..word..", "..S("see /help chchar for supported parameters.")
                end

                if command == "set" then
                        local success = chchar.set_player_model(player, parameter)
                        if success then
                                return true, S("Player model for").." "..name.." "..S("set to").." "..parameter
                        else
                                return false, S("Invalid model").." "..parameter
                        end
                elseif command == "reset" then
                        chchar.set_player_model(player, "character")
                        return true, S("Player model reset to the default.")
                elseif command == "list" then
                        local list
                        if parameter == "private" then
                                list = chchar.get_modellist_with_meta("playername", name)
                        elseif parameter == "public" then
                                list = chchar.get_modellist_for_player()
                        elseif not parameter then
                                list = chchar.get_modellist_for_player(name)
                        else
                                return false, S("Unknown parameter"), parameter
                        end

                        local current_model_key = chchar.get_player_model(player):get_key()
                        for _, model in ipairs(list) do
                                local info = model:get_key().." - "
                                                ..S("Name").."="..model:get_meta_string("name").." "
                                                ..S("Author").."="..model:get_meta_string("author").." "
                                                ..S("License").."="..model:get_meta_string("license")
                                if model:get_key() == current_model_key then
                                        info = minetest.colorize("#00FFFF", info)
                                end
                                minetest.chat_send_player(name, info)
                        end
                elseif command == "show" then
                        local model
                        if parameter then
                                model = models.get(parameter)
                        else
                                model = chchar.get_player_model(player)
                        end
                        if not model then
                                return false, S("Invalid model")
                        end
                        local formspec = "size[8,3]"..chchar.get_model_info_formspec(model)
                        minetest.show_formspec(name, 'chchar_show_model', formspec)
                elseif command == "ui" then
                        show_selection_formspec(player)
                end
        end,
})


minetest.register_on_player_receive_fields(function(player, formname, fields)
        if formname ~= "chchar_show_ui" then
                return
        end

        local context = chchar.get_formspec_context(player)

        local action = chchar.on_model_selection_receive_fields(player, context, fields)
        if action == 'set' then
                minetest.close_formspec(player:get_player_name(), formname)
        elseif action == 'page' then
                show_selection_formspec(player)
        end
end)
