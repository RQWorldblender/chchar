local S = chchar.S

-- generate the current formspec
local function get_formspec(player, context)
        local model = chchar.get_player_model(player)
        local formspec = chchar.get_model_info_formspec(model)
        formspec = formspec..chchar.get_model_selection_formspec(player, context, 4)
        return formspec
end

sfinv.register_page("chchar:overview", {
        title = "Models",
        get = function(self, player, context)
                -- collect models data
                return sfinv.make_formspec(player, context, get_formspec(player, context))
        end,
        on_player_receive_fields = function(self, player, context, fields)
                chchar.on_model_selection_receive_fields(player, context, fields)
                sfinv.set_player_inventory_formspec(player)
        end
})
