local mvec1 = Vector3()
local mvec2 = Vector3()
local mvec3 = Vector3()

local material_defaults = {
	diffuse_layer1_texture = Idstring("units/payday2_cash/safes/default/base_gradient/base_default_df"),
	diffuse_layer2_texture = Idstring("units/payday2_cash/safes/default/pattern_gradient/gradient_default_df"),
	diffuse_layer0_texture = Idstring("units/payday2_cash/safes/default/pattern/pattern_default_df"),
	diffuse_layer3_texture = Idstring("units/payday2_cash/safes/default/sticker/sticker_default_df")
}
local material_textures = {
	pattern = "diffuse_layer0_texture",
	sticker = "diffuse_layer3_texture",
	pattern_gradient = "diffuse_layer2_texture",
	base_gradient = "diffuse_layer1_texture"
}
local material_variables = {
	cubemap_pattern_control = "cubemap_pattern_control",
	pattern_pos = "pattern_pos",
	uv_scale = "uv_scale",
	uv_offset_rot = "uv_offset_rot",
	pattern_tweak = "pattern_tweak",
	wear_and_tear = (managers.blackmarket and managers.blackmarket:skin_editor() and managers.blackmarket:skin_editor():active() or Application:production_build()) and "wear_tear_value" or nil
}


function NewRaycastWeaponBaseVR:start_reload(total_time)
	NewRaycastWeaponBaseVR.super.start_reload(self)

	local belt_mag_unit = self:custom_magazine_name()

	if belt_mag_unit then
		local belt_mag_unit_id = Idstring(belt_mag_unit)

		if not managers.dyn_resource:is_resource_ready(Idstring("unit"), belt_mag_unit_id, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
			managers.dyn_resource:load(Idstring("unit"), belt_mag_unit_id, managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)
		end
	end

	local reload_type = "magazine"

	if tweak_data.vr.reload_timelines[self.name_id] and tweak_data.vr.reload_timelines[self.name_id].reload_part_type then
		reload_type = tweak_data.vr.reload_timelines[self.name_id].reload_part_type
	end
	
	local mag_list = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk(reload_type, self._factory_id, self._blueprint)
	local mag_id = mag_list and mag_list[1]

	if mag_id then
		local mag = self._parts[mag_id]

		if mag then
			self._reload_mag_id = mag_id
			self._reload_mag_unit = mag.unit
			self._timeline = tweak_data.vr.reload_timelines[self.name_id] and tweak_data.vr.reload_timelines[self.name_id].start and ReloadTimeline:new(tweak_data.vr.reload_timelines[self.name_id].start)
			self._total_reload_time = total_time
			self._current_reload_time = 0

			if mag.reload_objects then
				local reload_object_name = self:clip_empty() and mag.reload_objects.reload or mag.reload_objects.reload_not_empty
				self._reload_object = self._reload_mag_unit:get_object(Idstring(reload_object_name))
			end
		end
	end
	--Allow anims to play if they're built into the base unit itself
	if tweak_data.vr.reload_timelines[self.name_id] and tweak_data.vr.reload_timelines[self.name_id].base_reload_anim then
		self._timeline = tweak_data.vr.reload_timelines[self.name_id] and tweak_data.vr.reload_timelines[self.name_id].start and ReloadTimeline:new(tweak_data.vr.reload_timelines[self.name_id].start)
		self._total_reload_time = total_time
		self._current_reload_time = 0
		self._base_reload_anim = true
	end
end

local __update_reloading = NewRaycastWeaponBaseVR.update_reloading

function NewRaycastWeaponBaseVR:update_reloading(t, dt, time_left)
	if (self._reload_mag_unit or self._base_reload_anim) and self._current_reload_time and self._current_reload_time <= self._total_reload_time then
		self._current_reload_time = self._current_reload_time + dt

		self:update_reload_mag(self._current_reload_time / self._total_reload_time)
	end

	return __update_reloading(self, t, dt, time_left)
end

function NewRaycastWeaponBaseVR:update_reload_mag(time)
	if not self._timeline then
		return
	end

	local mag_data = self._timeline:get_data(time)
	
	if self._reload_mag_unit then
		self._reload_mag_unit:set_local_position(mag_data.pos)
		self._reload_mag_unit:set_local_rotation(mag_data.rot)
	end

	if mag_data.visible ~= nil then
		if type(mag_data.visible) == "boolean" then
			self._reload_mag_unit:set_visible(mag_data.visible)
			self:_set_part_temporary_visibility(self._reload_mag_id, mag_data.visible)
		else
			local visible = mag_data.visible.visible
			local parts = mag_data.visible.parts

			for part_type, part_data in pairs(parts) do
				local part_list = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk(part_type, self._factory_id, self._blueprint)

				for _, part_name in ipairs(part_list) do
					local part = self._parts[part_name]
					local objects = type(part_data) == "table" and (part_data[part_name] or part_data[1] and part_data) or true

					if objects then
						if type(objects) == "table" then
							for _, object_name in ipairs(objects) do
								local object = part.unit:get_object(Idstring(object_name))

								if alive(object) then
									object:set_visibility(visible)
								end
							end
						else
							part.unit:set_visible(visible)
							self:_set_part_temporary_visibility(part_name, visible)
						end
					end
				end
			end
		end
	end

	if mag_data.sound then
		self:play_sound(mag_data.sound)
	end

	if mag_data.anims then
		for _, anim_data in ipairs(mag_data.anims) do
			if anim_data.part then
				local part_list = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk(anim_data.part, self._factory_id, self._blueprint)

				for _, part_name in ipairs(part_list or {}) do
					local part_data = self._parts[part_name]

					if part_data.animations and part_data.animations[anim_data.anim_group] then
						local anim_group_id = Idstring(part_data.animations[anim_data.anim_group])

						self:_play_reload_anim(anim_group_id, anim_data.to, anim_data.from, part_data.unit)
					end
				end
			else
				local anim_group_id = Idstring(anim_data.anim_group)

				self:_play_reload_anim(anim_group_id, anim_data.to, anim_data.from)
			end
		end
	end

	if mag_data.drop_mag then
		self:drop_magazine_object_vr()	--new function
	end

	if mag_data.effect then
		local effect = {
			effect = Idstring(mag_data.effect.name)
		}
		local unit = nil

		if mag_data.effect.part then
			local part_list = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk(mag_data.effect.part, self._factory_id, self._blueprint)
			unit = self._parts[part_list[1]].unit
		else
			unit = self._unit
		end

		effect.parent = unit:get_object(Idstring(mag_data.effect.object))

		World:effect_manager():spawn(effect)
	end
end

function NewRaycastWeaponBaseVR:stop_reload()
	if alive(self._reload_mag_unit) or self._base_reload_anim then	--accounting for base reload anims
		self._reload_finish_total_time = tweak_data.vr.reload_buff
		self._reload_finish_current_time = 0
		self._total_reload_time = nil
		self._current_reload_time = nil
		self._timeline = tweak_data.vr.reload_timelines[self.name_id] and tweak_data.vr.reload_timelines[self.name_id].finish and ReloadTimeline:new(tweak_data.vr.reload_timelines[self.name_id].finish)

		if self._reload_object then
			self._reload_object:set_position(self._reload_mag_unit:position())
			self._reload_object:set_visibility(true)
		end
	end
end

function NewRaycastWeaponBaseVR:finish_reload()
	if alive(self._reload_mag_unit) or self._base_reload_anim then --accounting for base reload anims
		self._reload_finish_total_time = nil
		self._reload_finish_current_time = nil
		self._reload_mag_id = nil
		self._reload_mag_unit = nil
		self._timeline = nil
		self._base_reload_anim = nil

		if self._reload_object then
			self._reload_object:set_visibility(false)

			self._reload_object = nil
		end
	end

	self:tweak_data_anim_stop("magazine_empty")
end

--edited function
--second_unit: if true, checks for "secondary_reload_part_type" (basically just an ECP fix)
--from_belt: manual reload
function NewRaycastWeaponBase:spawn_magazine_unit_vr(pos, rot, hide_bullets, second_unit, from_belt)
	local mag_data = nil
	local mag_list = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("magazine", self._factory_id, self._blueprint)
	local mag_id = mag_list and mag_list[1]
	
	if tweak_data.vr.reload_timelines[self.name_id] and tweak_data.vr.reload_timelines[self.name_id].reload_part_type and not second_unit then
		mag_list = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk(tweak_data.vr.reload_timelines[self.name_id].reload_part_type, self._factory_id, self._blueprint)
		mag_id = mag_list and mag_list[1]
	end
	
	if tweak_data.vr.reload_timelines[self.name_id] and tweak_data.vr.reload_timelines[self.name_id].secondary_reload_part_type and second_unit then
		mag_list = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk(tweak_data.vr.reload_timelines[self.name_id].secondary_reload_part_type, self._factory_id, self._blueprint)
		mag_id = mag_list and mag_list[1]
	end

	if not mag_id then
		return
	end

	mag_data = managers.weapon_factory:get_part_data_by_part_id_from_weapon(mag_id, self._factory_id, self._blueprint)
	local part_data = self._parts[mag_id]

	if not mag_data or not part_data then
		return
	end

	pos = pos or Vector3()
	rot = rot or Rotation()
	local is_thq = managers.weapon_factory:use_thq_weapon_parts()
	local use_cc_material_config = is_thq and self:get_cosmetics_data() and true or false
	local material_config_ids = Idstring("material_config")
	local mag_unit = World:spawn_unit(part_data.name, pos, rot)
	local new_material_config_ids = self:_material_config_name(mag_id, mag_data.unit, use_cc_material_config, true)

	if mag_unit:material_config() ~= new_material_config_ids and DB:has(material_config_ids, new_material_config_ids) then
		mag_unit:set_material_config(new_material_config_ids, true)
	end

	if hide_bullets and part_data.bullet_objects then
		local prefix = part_data.bullet_objects.prefix

		for i = 1, part_data.bullet_objects.amount, 1 do
			local target_object = mag_unit:get_object(Idstring(prefix .. i))
			local ref_object = part_data.unit:get_object(Idstring(prefix .. i))

			if target_object then
				if ref_object then
					target_object:set_visibility(ref_object:visibility())
				else
					target_object:set_visibility(false)
				end
			end
		end
	end
	
	--Show proper amount of bullet objects on mags
	if mag_data.bullet_objects and (managers.player:player_unit():movement():current_state():_current_reload_amount() ~= nil or self:get_ammo_total() < self:get_ammo_max_per_clip()) then
		local prefix = mag_data.bullet_objects.prefix
		local amount = mag_data.bullet_objects.amount
		local current_count = managers.player:player_unit():movement():current_state():_current_reload_amount() or self:get_ammo_total()
		
		if current_count then
			for i = 1, amount, 1 do
				local target_object = mag_unit:get_object(Idstring(prefix .. i))
				if target_object then
					target_object:set_visibility(false)
				end
			end
			for i = 1, current_count, 1 do
				local target_object = mag_unit:get_object(Idstring(prefix .. i))
				if target_object then
					target_object:set_visibility(true)
				end
			end
		end
	end	

	local materials = {}
	local unit_materials = mag_unit:get_objects_by_type(Idstring("material")) or {}

	for _, m in ipairs(unit_materials) do
		if m:variable_exists(Idstring("wear_tear_value")) then
			table.insert(materials, m)
		end
	end

	local textures = {}
	local texture_key, p_type, value = nil
	local cosmetics_quality = self._cosmetics_quality
	local wear_tear_value = cosmetics_quality and tweak_data.economy.qualities[cosmetics_quality] and tweak_data.economy.qualities[cosmetics_quality].wear_tear_value or 1

	for _, material in pairs(materials) do
		material:set_variable(Idstring("wear_tear_value"), wear_tear_value)

		p_type = managers.weapon_factory:get_type_from_part_id(mag_id)

		for key, variable in pairs(material_variables) do
			value = self:get_cosmetic_value("weapons", self._name_id, "parts", mag_id, material:name():key(), key) or self:get_cosmetic_value("weapons", self._name_id, "types", p_type, key) or self:get_cosmetic_value("weapons", self._name_id, key) or self:get_cosmetic_value("parts", mag_id, material:name():key(), key) or self:get_cosmetic_value("types", p_type, key) or self:get_cosmetic_value(key)

			if value then
				material:set_variable(Idstring(variable), value)
			end
		end

		for key, material_texture in pairs(material_textures) do
			value = self:get_cosmetic_value("weapons", self._name_id, "parts", mag_id, material:name():key(), key) or self:get_cosmetic_value("weapons", self._name_id, "types", p_type, key) or self:get_cosmetic_value("weapons", self._name_id, key) or self:get_cosmetic_value("parts", mag_id, material:name():key(), key) or self:get_cosmetic_value("types", p_type, key) or self:get_cosmetic_value(key)

			if value then
				if type_name(value) ~= "Idstring" then
					value = Idstring(value)
				end

				Application:set_material_texture(material, Idstring(material_texture), value, Idstring("normal"))
			end
		end
	end

	return mag_unit
end

function NewRaycastWeaponBaseVR:spawn_belt_magazine_unit(pos, second_unit)
	if self:custom_magazine_name() then
		return World:spawn_unit(Idstring(self:custom_magazine_name()), pos or Vector3(), Rotation())
	end

	return self:spawn_magazine_unit_vr(pos, nil, nil, second_unit, true) --new function
end

local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local tmp_vec3 = Vector3()
local mvec3_set = mvector3.set
local mvec3_add = mvector3.add
local mvec3_sub = mvector3.subtract
local mvec3_mul = mvector3.multiply

function NewRaycastWeaponBase:drop_magazine_object_vr()
	if not self._name_id then
		return
	end

	local name_id = self._name_id

	for original_name, name in pairs(tweak_data.animation.animation_redirects) do
		if name == name_id then
			name_id = original_name

			break
		end
	end

	local w_td_crew = tweak_data.weapon[name_id .. "_crew"]

	for part_id, part_data in pairs(self._parts) do
		local part = tweak_data.weapon.factory.parts[part_id]

		if part and (part.type == tweak_data.vr.reload_timelines[self.name_id].reload_part_type or part.type == "magazine") then --can account for other reload objects other than "magazine"
			local pos = part_data.unit:position()
			local rot = part_data.unit:rotation()
			local dropped_mag = self:spawn_magazine_unit_vr(pos, rot, true, false)
			local mag_size = w_td_crew and w_td_crew.pull_magazine_during_reload or "medium"

			mvec3_set(tmp_vec1, dropped_mag:oobb():center())
			mvec3_sub(tmp_vec1, dropped_mag:position())
			mvec3_set(tmp_vec2, dropped_mag:position())
			mvec3_add(tmp_vec2, tmp_vec1)

			local dropped_col = World:spawn_unit(NewRaycastWeaponBase.magazine_collisions[mag_size][1], tmp_vec2, part_data.unit:rotation())

			dropped_col:link(NewRaycastWeaponBase.magazine_collisions[mag_size][2], dropped_mag)
			mvec3_set(tmp_vec3, -rot:z())
			mvec3_mul(tmp_vec3, 100)
			dropped_col:push(20, tmp_vec3)
			managers.enemy:add_magazine(dropped_mag, dropped_col)
		end
	end
end
