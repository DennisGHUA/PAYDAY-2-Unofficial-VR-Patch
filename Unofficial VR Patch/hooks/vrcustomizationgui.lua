--lib/managers/menu/vrcustomizationgui
--Unfinished belt sizing fix
function VRBeltCustomization:__update_grid(t, dt)
	local player = managers.menu:player()
	local hands = {
		player:hand(1),
		player:hand(2)
	}

	for i, hand in ipairs(hands) do
		if not self._active_hand_id or i == self._active_hand_id and not self._sizing_hand_id then
			local interact_btn = "interact_" .. ((i == 1 and "right") or (i == 2 and "left"))
			local held = managers.menu:get_controller():get_input_bool(interact_btn)
			local interaction = self._belt:get_closest_interaction(hand:position(), 200, true)
			
			if not self._current_interaction and interaction ~= self._selected_interaction then
				if self._selected_interaction then
					self._belt:remove_help_text(self._selected_interaction, "layout_help")
					self._belt:remove_help_text(self._selected_interaction, "size_help")
					self._belt:set_alpha(self._belt_alpha, self._selected_interaction)
					self:set_back_button_enabled(i, true)
				end

				if interaction then
					log("Hand ID " .. i .. " touched the belt")
					self._active_hand_id = i
					log("Set active hand ID to " .. self._active_hand_id)

					self._belt:add_help_text(interaction, "layout_help", "menu_vr_belt_grip_grid", "above")
					self._belt:add_help_text(interaction, "size_help", "menu_vr_belt_grip_grid_size", "below")
					self._belt:set_alpha(self._belt_alpha + 0.2, interaction)
					self:set_back_button_enabled(i, false)
				else
					log("Active hand ID Nil!!!")
					self._active_hand_id = nil
				end

				self._selected_interaction = interaction
			end

			if managers.menu:get_controller():get_input_pressed(interact_btn) and interaction then
				self._current_interaction = interaction
				self._prev_grid_pos = {
					self._belt:pos_on_grid(self._current_interaction)
				}
				self._grip_offset = self._belt:world_pos(self._current_interaction) - hand:position()

				self._belt:set_alpha(self._belt_alpha + 0.4, self._current_interaction)
			end

			if self._current_interaction then
				if held then
					self._belt:move_interaction(self._current_interaction, self._ws:world_to_local(hand:position() + self._grip_offset), true)
				else
					if not self._belt:valid_grid_location(self._current_interaction) and self._prev_grid_pos then
						self._belt:set_grid_position(self._current_interaction, unpack(self._prev_grid_pos))

						if not self._belt:valid_grid_location(self._current_interaction) and self._prev_grid_size then
							self._belt:set_grid_size(self._current_interaction, unpack(self._prev_grid_size))
						end
					end

					self._belt:set_alpha(self._belt_alpha, self._current_interaction)

					self._current_interaction = nil
					self._prev_grid_pos = nil
				end
			end
		elseif self._active_hand_id and i ~= self._active_hand_id and self._current_interaction then
			local interact_btn = "interact_" .. ((i == 1 and "right") or (i == 2 and "left"))

			log("get controller input pressed for " .. interact_btn .. " " .. tostring(managers.menu:get_controller():get_input_pressed(interact_btn)))
			if managers.menu:get_controller():get_input_pressed(interact_btn) then
				self._sizing_hand_id = i
				log("Sizing hand ID set to " .. self._sizing_hand_id)
				local size = self._belt:world_size(self._current_interaction)
				self._sizing_grip_offset = self._belt:world_pos(self._current_interaction) + size - self._grip_offset - hand:position()
				self._prev_grid_size = {
					self._belt:grid_size(self._current_interaction)
				}
			end

			local held = managers.menu:get_controller():get_input_bool(interact_btn)

			if self._sizing_hand_id == i then
				if held then
					log("Controller " .. i .. " is held")
					self._belt:resize_interaction(self._current_interaction, self._ws:world_to_local(hand:position() + self._sizing_grip_offset), true)
				else
					if not self._belt:valid_grid_location(self._current_interaction) and self._prev_grid_size then
						self._belt:set_grid_size(self._current_interaction, unpack(self._prev_grid_size))
					end

					if self._grip_offset then
						self._grip_offset = self._belt:world_pos(self._current_interaction) - hands[3 - i]:position()
					end
					
					self._sizing_hand_id = nil
					self._sizing_grip_offset = nil
				end
			else
				log("Sizing hand: nil!")
				self._sizing_hand_id = nil
				self._sizing_grip_offset = nil
			end
		end
	end
end