chchar.meta = {}

local model_class = {}
model_class.__index = model_class
chchar.model_class = model_class
-----------------------
-- Class methods
-----------------------
-- constructor
function chchar.new(key, object)
        assert(key, 'Unique models key required, like "character_1"')
        local self = object or {}
        setmetatable(self, model_class)
        self.__index = model_class

        self._key = key
        self._sort_id = 0
        chchar.meta[key] = self
        return self
end

-- getter
function chchar.get(key)
        return chchar.meta[key]
end

-- Model methods
-- In this implementation it is just access to attrubutes wrapped
-- but this way allow to redefine the functionality for more complex models provider
function model_class:get_key()
        return self._key
end

function model_class:set_meta(key, value)
        self[key] = value
end

function model_class:get_meta(key)
        return self[key]
end

function model_class:get_meta_string(key)
        return tostring(self:get_meta(key) or "")
end

function model_class:set_texture(value)
        self._texture = value
end

function model_class:get_texture()
        return self._texture
end

function model_class:set_icon(value)
        self._icon = value
end

function model_class:get_icon()
        return self._icon or "image-missing.png"
end

function model_class:apply_model_to_player(player)
--[[
        local function concat_texture(base, ext)
                if base == "blank.png" then
                        return ext
                elseif ext == "blank.png" then
                        return base
                else
                        return	base .. "^" .. ext
                end
        end
--]]
        local playername = player:get_player_name()
        player_api.set_model(player, self:get_meta("filename"))
--[[
        local ver = self:get_meta("format") or "1.0"
        if minetest.global_exists("player_api") then
                -- Minetest-5 compatible
                player_api.set_model(player, "skinsdb_3d_armor_character_5.b3d")
        else
                -- Minetest-0.4 compatible
                default.player_set_model(player, "skinsdb_3d_armor_character.b3d")
        end
        local v10_texture = "blank.png"
        local v18_texture = "blank.png"
        local armor_texture = "blank.png"
        local wielditem_texture = "blank.png"

        if ver == "1.8" then
                v18_texture = self:get_texture()
        else
                v10_texture = self:get_texture()
        end
--[[
        -- Support for clothing
        if skins.clothing_loaded and clothing.player_textures[playername] then
                local cape = clothing.player_textures[playername].cape
                local layers = {}
                for k, v in pairs(clothing.player_textures[playername]) do
                        if k ~= "skin" and k ~= "cape" then
                                table.insert(layers, v)
                        end
                end
                local overlay = table.concat(layers, "^")
                v10_texture = concat_texture(v10_texture, cape)
                v18_texture = concat_texture(v18_texture, overlay)
        end

        -- Support for armor
        if skins.armor_loaded then
                local armor_textures = armor.textures[playername]
                if armor_textures then
                        armor_texture = concat_texture(armor_texture, armor_textures.armor)
                        wielditem_texture = concat_texture(wielditem_texture, armor_textures.wielditem)
                end
        end

        if minetest.global_exists("player_api") then
                -- Minetest-5 compatible
                player_api.set_textures(player, {
                                v10_texture,
                                v18_texture,
                                armor_texture,
                                wielditem_texture,
                        })
        else
                -- Minetest-0.4 compatible
                default.player_set_textures(player, {
                                v10_texture,
                                v18_texture,
                                armor_texture,
                                wielditem_texture,
                        })
        end
--]]
        player:set_properties({
                visual_size = {
                        x = self:get_meta("visual_size_x") or 1,
                        y = self:get_meta("visual_size_y") or 1
                }
        })
end

function model_class:set_model(player)
        -- The set_skin is used on skins selection
        -- This means the method could be redefined to start an furmslec
        -- See character_creator for example
end

function model_class:is_applicable_for_player(playername)
        local assigned_player = self:get_meta("playername")
        return assigned_player == nil or assigned_player == true or
                        (assigned_player:lower() == playername:lower())
end
