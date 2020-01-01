local S = chchar.S

function chchar.get_formspec_context(player)
        if player then
                local playername = player:get_player_name()
                chchar.ui_context[playername] = chchar.ui_context[playername] or {}
                return chchar.ui_context[playername]
        else
                return {}
        end
end

-- Show model info in a graphical window
function chchar.get_model_info_formspec(model)
        --local texture = model:get_texture()
        local icon = model:get_icon()
        local m_codename = model:get_meta_string("codename")
        local m_filename = model:get_meta_string("filename")
        local m_name = model:get_meta_string("name")
        local m_author = model:get_meta_string("author")
        local m_license = model:get_meta_string("license")
        local m_format = model:get_meta_string("format")
        -- overview page
        local formspec = "image[0,.75;2,2;"..model:get_icon().."]"
        --local formspec = "image[0,.75;1,2;"..model:get_preview().."]"
        --if texture then
        --	formspec = formspec.."label[6,.5;"..S("Raw texture")..":]"
        --	.."image[6,1;2,1;"..model:get_texture().."]"
        --end
        if m_name ~= "" then
                formspec = formspec.."label[2,.5;"..S("Name")..": "..minetest.formspec_escape(m_name).."]"
        end
        if m_codename ~= "" then
                formspec = formspec.."label[2,1;"..S("Technical Name")..": "..minetest.formspec_escape(m_codename).."]"
        end
        if m_filename ~= "" then
                formspec = formspec.."label[2,1.5;"..S("File Name")..": "..minetest.formspec_escape(m_filename).."]"
        end
        if m_author ~= "" then
                formspec = formspec.."label[2,2;"..S("Author")..": "..minetest.formspec_escape(m_author).."]"
        end
        if m_license ~= "" then
                formspec = formspec.."label[2,2.5;"..S("License")..": "..minetest.formspec_escape(m_license).."]"
        end
        if m_format ~= "" then
                formspec = formspec.."label[2,3;"..S("Format")..": "..minetest.formspec_escape(m_format:upper()).."]"
        end
        return formspec
end

function chchar.get_model_selection_formspec(player, context, y_delta)
        context.chchar_list = chchar.get_modellist_for_player(player:get_player_name())
        context.total_pages = 1
        for i, model in ipairs(context.chchar_list) do
                local page = math.floor((i-1) / 16)+1
                model:set_meta("inv_page", page)
                model:set_meta("inv_page_index", (i-1)%16+1)
                context.total_pages = page
        end
        context.chchar_page = context.chchar_page or chchar.get_player_model(player):get_meta("inv_page") or 1
        context.dropdown_values = nil

        local page = context.chchar_page
        local formspec = ""
        for i = (page-1)*16+1, page*16 do
                local model = context.chchar_list[i]
                if not model then
                        break
                end

                local index_p = model:get_meta("inv_page_index")
                local x = (index_p-1) % 8
                local y
                if index_p > 8 then
                        y = y_delta + 1.9
                else
                        y = y_delta
                end
                formspec = formspec.."image_button["..x..","..y..";1,1;"..
                        model:get_icon()..";chchar_set$"..i..";]"..
                        "tooltip[chchar_set$"..i..";"..minetest.formspec_escape(model:get_meta_string("name")).."]"
        end

        if context.total_pages > 1 then
                local page_prev = page - 1
                local page_next = page + 1
                if page_prev < 1 then
                        page_prev = context.total_pages
                end
                if page_next > context.total_pages then
                        page_next = 1
                end
                local page_list = ""
                context.dropdown_values = {}
                for pg=1, context.total_pages do
                        local pagename = S("Page").." "..pg.."/"..context.total_pages
                        context.dropdown_values[pagename] = pg
                        if pg > 1 then page_list = page_list.."," end
                        page_list = page_list..pagename
                end
                formspec = formspec
                        .."button[0,"..(y_delta+4.0)..";1,.5;chchar_page$"..page_prev..";<<]"
                        .."dropdown[0.9,"..(y_delta+3.88)..";6.5,.5;chchar_selpg;"..page_list..";"..page.."]"
                        .."button[7,"..(y_delta+4.0)..";1,.5;chchar_page$"..page_next..";>>]"
        end
        return formspec
end

function chchar.on_model_selection_receive_fields(player, context, fields)
        for field, _ in pairs(fields) do
                local current = string.split(field, "$", 2)
                if current[1] == "chchar_set" then
                        chchar.set_player_model(player, context.chchar_list[tonumber(current[2])])
                        return 'set'
                elseif current[1] == "chchar_page" then
                        context.chchar_page = tonumber(current[2])
                        return 'page'
                end
        end
        if fields.chchar_selpg then
                context.chchar_page = tonumber(context.dropdown_values[fields.chchar_selpg])
                return 'page'
        end
end
