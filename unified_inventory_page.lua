local S = chchar.S

unified_inventory.register_page("chchar", {
        get_formspec = function(player)
                local model = chchar.get_player_model(player)
                local formspec = "background[0.06,0.99;7.92,7.52;ui_misc_form.png]"..chchar.get_model_info_formspec(model)..
                                "button[.75,3.7;6.5,.5;chchar_page;"..S("Change").."]"
                return {formspec=formspec}
        end,
})

unified_inventory.register_button("chchar", {
        type = "image",
        image = "chchar_button.png",
})

local function get_formspec(player)
        local context = chchar.get_formspec_context(player)
        local formspec = "background[0.06,0.99;7.92,7.52;ui_misc_form.png]"..
                        chchar.get_model_selection_formspec(player, context, -0.2)
        return formspec
end

unified_inventory.register_page("chchar_page", {
        get_formspec = function(player)
                return {formspec=get_formspec(player)}
        end
})

-- click button handlers
minetest.register_on_player_receive_fields(function(player, formname, fields)
        if fields.chchar then
                unified_inventory.set_inventory_formspec(player, "craft")
                return
        end

        if formname ~= "" then
                return
        end

        local context = chchar.get_formspec_context(player)
        local action = chchar.on_model_selection_receive_fields(player, context, fields)
        if action == 'set' then
                unified_inventory.set_inventory_formspec(player, "chchar")
        elseif action == 'page' then
                unified_inventory.set_inventory_formspec(player, "chchar_page")
        end
end)
