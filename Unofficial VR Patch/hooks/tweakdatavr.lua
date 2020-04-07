Hooks:PostHook(TweakDataVR, "init", "vrtweakfix_init", function(self, tweak_data)
--Tactical Flashlight
	self.melee_offsets.weapons.aziz = {
		rotation = Rotation(0, 90, 0)
	}
	
--Heavy Crossbow
	self.reload_timelines.arblast.custom_mag_unit = nil
	self.reload_timelines.arblast.reload_part_type = "ammo"
	self.reload_timelines.arblast.start = {
		{
			time = 0,
			anims = {
				{
					anim_group = "reload",
					part = "barrel",
					to = 0.5
				},
				{
					anim_group = "reload",
					part = "lower_reciever",
					from = 0.5,
					to = 0.5
				}
			}
		},
		{
			time = 0.5,
			anims = {
				{
					anim_group = "reload",
					part = "barrel",
					from = 0.5
				},
				{
					anim_group = "reload",
					part = "lower_reciever",
					from = 0.5
				}
			}
		},
		{
			time = 0.61,
			sound = "wp_arblast_wind_up_01"
		},
		{
			time = 0.99,
			sound = "wp_arblast_wind_up_02"
		}
	}

--Light Crossbow
	self.reload_timelines.frankish.custom_mag_unit = nil
	self.reload_timelines.frankish.reload_part_type = "ammo"
	self.reload_timelines.frankish.start = {
		{
			time = 0,
			anims = {
				{
					anim_group = "reload",
					part = "barrel"
				},
				{
					anim_group = "reload",
					part = "lower_reciever",
					from = 0.65
				}
			}
		},
		{
			time = 0.03,
			visible = false,
			pos = Vector3(0, 0, 0)
		},
		{
			time = 0.3,
			sound = "wp_frankish_grab_string"
		},
		{
			time = 0.5,
			sound = "wp_frankish_pull_string"
		}
	}
	
--Pistol Crossbow
	self.reload_timelines.hunter.custom_mag_unit = nil
	self.reload_timelines.hunter.reload_part_type = "ammo"
	
--Claire 12G
	self.reload_timelines.coach.base_reload_anim = true 
	self.reload_timelines.coach.start = {
		{
			time = 0,
			sound = "wp_coach_barrel_open",
			anims = {
				{
					anim_group = "reload",
					from = 0.1,
					to = 0.3
				}
			}
		},
		{
			time = 0.03,
			sound = "wp_coach_shells_in"
		},
		{
			time = 0.04,
			visible = {
				visible = false,
				parts = {
					right_slug = {
						"g_right_slug"
					},
					left_slug = {
						"g_left_slug"
					}
				}
			},
			effect = {
				part = "right_slug",
				name = "effects/payday2/particles/weapons/shells/shell_slug_vr",
				object = "g_right_slug"
			}
		},
		{
			time = 0.04,
			effect = {
				part = "left_slug",
				name = "effects/payday2/particles/weapons/shells/shell_slug_vr",
				object = "g_left_slug"
			}
		}
	}
	self.reload_timelines.coach.finish = {
		{
			time = 0,
			sound = "wp_coach_shells_in",
			visible = {
				visible = true,
				parts = {
					right_slug = {
						"g_right_slug"
					},
					left_slug = {
						"g_left_slug"
					}
				}
			}
		},
		{
			time = 0.4,
			anims = {
				{
					anim_group = "reload",
					from = 2
				}
			}
		},
			{
			time = 0.95,
			sound = "wp_coach_barrel_close"
		}
	}

--Airbow
	self.reload_timelines.ecp.secondary_reload_part_type = "ammo"
	self.reload_timelines.ecp.start = {
		{
			time = 0,
			sound = "wp_ecp_remove_clip",
			visible = {
				visible = false,
				parts = {
					ammo = {
						"g_bullet_1",
						"g_bullet_2",
						"g_bullet_3",
						"g_bullet_4",
						"g_bullet_5",
						"g_bullet_6"
					}
				}
			}
		},
		{
			time = 0.01,
			pos = Vector3(0, -1, 2),
			rot = Rotation(0, -5, 0)
		},
		{
			time = 0.03,
			pos = Vector3(0, -1.2, 2.2),
			rot = Rotation(0, -5, 0)
		},
		{
			time = 0.04,
			pos = Vector3(0, -15, 4),
			rot = Rotation(0, 0, 0)
		},
		{
			drop_mag = true,
			time = 0.05,
			visible = false,
			pos = Vector3(10, -15, 4),
			rot = Rotation(1, -4, -4)
		}
	}
	self.reload_timelines.ecp.finish = {
		{
			time = 0,
			sound = "wp_ecp_attach_clip",
			visible = true,
			pos = Vector3(0, -15, 4),
			rot = Rotation(0, 0, 0)
		},
		{
			time = 0.01,
			pos = Vector3(0, -1.2, 2.2),
			rot = Rotation(0, -5, 0)
		},
		{
			time = 0.45,
			pos = Vector3(0, -1, 2),
			rot = Rotation(0, -5, 0)
		},
		{
			time = 0.5,
			sound = "ecp_lever_release",
			pos = Vector3(),
			rot = Rotation()
		}
	}
	
--MA-17 Flamethrower
	self.reload_timelines.system = {
		base_reload_anim = true ,
		start = {
			{
				time = 0,
				sound = "wp_system_open_valve",
				anims = {
					{
						anim_group = "reload",
						from = 2,
						to = 3
					}
				}
			},
				{
				time = 0,
				sound = "wp_system_pull_tube",
			},
			{
				time = 0.04,
				sound = "wp_system_twist_tube",
			},
			{
				time = 0.1,
				pos = Vector3(0, 0, 0),
				rot = Rotation(0, 0, 180)
			},
			{
				drop_mag = true,
				visible = false,
				time = 0.13,
				pos = Vector3(0, 20, 0)
			}
		},
		finish = {
			{
				time = 0,
				sound = "wp_system_insert_tube",
				visible = true,
				pos = Vector3(0, 20, 0),
				rot = Rotation(0, 0, 180)
			},
			{
				time = 0.5,
				sound = "wp_system_lock_tube",
				pos = Vector3(),
				rot = Rotation(),
				anims = {
					{
						anim_group = "reload",
						from = 8
					}
				}
				}
		}
	}
	self.magazine_offsets.system = 
		{
			position = Vector3(2, 0, 10),
			rotation = Rotation(0, -90, 0)
		}
	self.weapon_assist.weapons.system = 
		{
			grip = "idle_wpn",
			position = Vector3(-2, 25, 0)
		}
	self.weapon_kick.exclude_list.system = true
	
--M13 9mm + Akimbo
	self.reload_timelines.legacy = {
		start = {
			{
				time = 0,
				sound = "wp_legacy_mag_throw"
			},
			{
				drop_mag = true,
				time = 0.05,
				visible = false,
				pos = Vector3(0, -6, -20)
			}
		},
		finish = {
			{
				time = 0,
				sound = "wp_legacy_mag_in",
				visible = true,
				pos = Vector3(0, -6, -20)
			},
			{
				time = 0.1,
				pos = Vector3(0, -2.5, -7)
			},
			{
				time = 0.56,
				pos = Vector3(0, -2.5, -7)
			},
			{
				time = 0.6,
				sound = "wp_legacy_slide_release",
				pos = Vector3()
			}
		}
	}
	self.reload_timelines.x_legacy = {
		start = {
			{
				time = 0,
				sound = "wp_legacy_mag_throw"
			},
			{
				drop_mag = true,
				time = 0.05,
				visible = false,
				pos = Vector3(0, -6, -20)
			}
		},
		finish = {
			{
				time = 0,
				sound = "wp_legacy_mag_in",
				visible = true,
				pos = Vector3(0, -6, -20)
			},
			{
				time = 0.1,
				pos = Vector3(0, -2.5, -7)
			},
			{
				time = 0.56,
				pos = Vector3(0, -2.5, -7)
			},
			{
				time = 0.6,
				sound = "wp_legacy_slide_release",
				pos = Vector3()
			}
		}
	}
	
--Sound override for the Akimbo Signature SMGs
	self.weapon_sound_overrides.x_shepheard = {
		sounds = {
			fire_single = "shepheard_fire_single",
			fire = "shepheard_fire_single",
			fire_auto = "shepheard_fire",
			stop_fire = "shepheard_stop"
		}
	}
	
--Unlocking weapons for VR usage
	self.locked.weapons.contraband = false	--Little Friend, GL not usable
	self.locked.weapons.frankish = false	--Light Crossbow
	self.locked.weapons.hunter = false		--Pistol Crossbow
	self.locked.weapons.arblast = false		--Heavy Crossbow
end)