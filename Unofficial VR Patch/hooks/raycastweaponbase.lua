--lib/units/weapons/raycastweaponbase
function RaycastWeaponBase:_check_magazine_empty()
	local mag = self:ammo_base():get_ammo_remaining_in_clip()

	if mag <= ((self.AKIMBO and not _G.IS_VR) and 1 or 0) then
		local w_td = self:weapon_tweak_data()

		if w_td.animations and w_td.animations.magazine_empty then
			self:tweak_data_anim_play_at_end("magazine_empty")
		end

		self:set_magazine_empty(true)
	end
end

function RaycastWeaponBase:fire(from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit)
	if managers.player:has_activate_temporary_upgrade("temporary", "no_ammo_cost_buff") then
		managers.player:deactivate_temporary_upgrade("temporary", "no_ammo_cost_buff")

		if managers.player:has_category_upgrade("temporary", "no_ammo_cost") then
			managers.player:activate_temporary_upgrade("temporary", "no_ammo_cost")
		end
	end

	local is_player = self._setup.user_unit == managers.player:player_unit()
	local consume_ammo = not managers.player:has_active_temporary_property("bullet_storm") and (not managers.player:has_activate_temporary_upgrade("temporary", "berserker_damage_multiplier") or not managers.player:has_category_upgrade("player", "berserker_no_ammo_cost")) or not is_player

	if consume_ammo and (is_player or Network:is_server()) then
		local base = self:ammo_base()

		if base:get_ammo_remaining_in_clip() == 0 then
			return
		end

		local ammo_usage = 1

		if is_player then
			for _, category in ipairs(self:weapon_tweak_data().categories) do
				if managers.player:has_category_upgrade(category, "consume_no_ammo_chance") then
					local roll = math.rand(1)
					local chance = managers.player:upgrade_value(category, "consume_no_ammo_chance", 0)

					if roll < chance then
						ammo_usage = 0

						print("NO AMMO COST")
					end
				end
			end
		end

		local mag = base:get_ammo_remaining_in_clip()
		local remaining_ammo = mag - ammo_usage

		if mag > 0 and remaining_ammo <= ((self.AKIMBO and not _G.IS_VR) and 1 or 0) then
			local w_td = self:weapon_tweak_data()

			if w_td.animations and w_td.animations.magazine_empty then
				self:tweak_data_anim_play("magazine_empty")
			end

			if w_td.sounds and w_td.sounds.magazine_empty then
				self:play_tweak_data_sound("magazine_empty")
			end

			if w_td.effects and w_td.effects.magazine_empty then
				self:_spawn_tweak_data_effect("magazine_empty")
			end

			self:set_magazine_empty(true)
		end

		base:set_ammo_remaining_in_clip(base:get_ammo_remaining_in_clip() - ammo_usage)
		self:use_ammo(base, ammo_usage)
	end

	local user_unit = self._setup.user_unit

	self:_check_ammo_total(user_unit)

	if alive(self._obj_fire) then
		self:_spawn_muzzle_effect(from_pos, direction)
	end

	self:_spawn_shell_eject_effect()

	local ray_res = self:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit)

	if self._alert_events and ray_res.rays then
		self:_check_alert(ray_res.rays, from_pos, direction, user_unit)
	end

	if ray_res.enemies_in_cone then
		for enemy_data, dis_error in pairs(ray_res.enemies_in_cone) do
			if not enemy_data.unit:movement():cool() then
				enemy_data.unit:character_damage():build_suppression(suppr_mul * dis_error * self._suppression, self._panic_suppression_chance)
			end
		end
	end

	managers.player:send_message(Message.OnWeaponFired, nil, self._unit, ray_res)

	return ray_res
end