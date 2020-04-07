function PlayerStandardVR:can_grab_mag()
	local amount = self:_current_reload_amount()

	return not managers.vr:get_setting("auto_reload") and (not self._state_data.needs_full_reload or self:can_trigger_reload()) and (not amount or amount > self._equipped_unit:base():get_ammo_remaining_in_clip())
end