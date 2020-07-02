Hooks:PostHook(TweakDataVR, "init", "vrtweakfix_init", function(self, tweak_data)
--Tactical Flashlight
	self.melee_offsets.weapons.aziz.hit_point = nil
	
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
	
--M60 Light Machine Gun
	self.reload_timelines.m60 = {
		start = {
			{
				time = 0,
				sound = "wp_m60_reload_mag_box_out"
			},
			{
				time = 0.01,
				pos = Vector3(-3, 0, 0)
			},
			{
				time = 0.03,
				pos = Vector3(-3, 0, 0)
			},
			{
				drop_mag = true,
				time = 0.05,
				visible = false,
				pos = Vector3(0, 0, -20)
			}
		},
		finish = {
			{
				time = 0,
				sound = "wp_m60_reload_mag_box_in",
				visible = true,
				pos = Vector3(0, 0, -20)
			},
			{
				time = 0.1,
				pos = Vector3(-3, 0, 0)
			},
			{
				time = 0.56,
				pos = Vector3(-3, 0, 0)
			},
			{
				time = 0.6,
				sound = "wp_m60_reload_belt_in_feeder",
				pos = Vector3()
			}
		}
	}
	
	self.weapon_assist.weapons.m60 = 
	{
		points = {
			{
				position = Vector3(0, 30, 2)
			},
			{
				position = Vector3(-14, 5, 0)
			}
		}
	}
	self.magazine_offsets.m60 = 
	{
		position = Vector3(14, 0, 0)
	}
	
--R700 Sniper Rifle
	self.reload_timelines.r700 = {
		start = {
			{
				time = 0,
				sound = "wp_r700_reload_empty_mag_out"
			},
			{
				drop_mag = true,
				time = 0.05,
				visible = false,
				pos = Vector3(0, 5, -20),
				rot = Rotation(0, 30, 0)
			}
		},
		finish = {
			{
				time = 0,
				sound = "wp_r700_reload_empty_mag_in",
				visible = true,
				pos = Vector3(0, 0, -20)
			},
			{
				time = 0.1,
				pos = Vector3(0, 0, -4.5)
			},
			{
				time = 0.56,
				pos = Vector3(0, 0, -4)
			},
			{
				time = 0.6,
				sound = "wp_r700_reload_empty_lever_forward",
				pos = Vector3()
			}
		}
	}
	self.weapon_assist.weapons.r700 = 
	{
		grip = "idle_wpn",
		position = Vector3(-1, 35, 0)
	}
	self.magazine_offsets.r700 = 
	{
		position = Vector3(0, 3, 5),
		rotation = Rotation(88, 100, 28)
	}

	
--Akimbo Signature SMG
	self.reload_timelines.x_shepheard.start[1].sound = "wp_shepheard_clip_grab_throw"
	self.reload_timelines.x_shepheard.finish[1].sound = "wp_shepheard_clip_slide_in"
	self.reload_timelines.x_shepheard.finish[4].sound = "wp_shepheard_lever_release"
	
--M13 9mm + Akimbo
	self.reload_timelines.legacy.start[1].sound = "wp_legacy_mag_throw"
	self.reload_timelines.legacy.finish[1].sound = "wp_legacy_mag_in"
	self.reload_timelines.legacy.finish[4].sound = "wp_legacy_slide_release"
	
	self.reload_timelines.x_legacy.start[1].sound = "wp_legacy_mag_throw"
	self.reload_timelines.x_legacy.finish[1].sound = "wp_legacy_mag_in"
	self.reload_timelines.x_legacy.finish[4].sound = "wp_legacy_slide_release"
	
--Bernetti Auto + Akimbo
	self.reload_timelines.beer.start[1].sound = "wp_beer_mag_out"
	self.reload_timelines.beer.finish[1].sound = "wp_beer_mag_in"
	self.reload_timelines.beer.finish[4].sound = "wp_beer_slide_forward"
	
	self.reload_timelines.x_beer.start[1].sound = "wp_beer_mag_out"
	self.reload_timelines.x_beer.finish[1].sound = "wp_beer_mag_in"
	self.reload_timelines.x_beer.finish[4].sound = "wp_beer_slide_forward"
	
--Czech 92 + Akimbo
	self.reload_timelines.czech.start[1].sound = "wp_czech_mag_out"
	self.reload_timelines.czech.finish[1].sound = "wp_czech_mag_in"
	self.reload_timelines.czech.finish[4].sound = "wp_czech_slide_forward"
	
	self.reload_timelines.x_czech.start[1].sound = "wp_czech_mag_out"
	self.reload_timelines.x_czech.finish[1].sound = "wp_czech_mag_in"
	self.reload_timelines.x_czech.finish[4].sound = "wp_czech_slide_forward"
	
--Igor Automatik + Akimbo
	self.reload_timelines.stech.start[1].sound = "wp_stetch_mag_release_button"
	self.reload_timelines.stech.start[2].sound = "wp_stetch_mag_slide_out"
	self.reload_timelines.stech.finish[1].sound = "wp_stetch_mag_slide_in"
	self.reload_timelines.stech.finish[4].sound = "wp_stetch_slide_release"
	
	self.reload_timelines.x_stech.start[1].sound = "wp_stetch_mag_release_button"
	self.reload_timelines.x_stech.start[2].sound = "wp_stetch_mag_slide_out"
	self.reload_timelines.x_stech.finish[1].sound = "wp_stetch_mag_slide_in"
	self.reload_timelines.x_stech.finish[4].sound = "wp_stetch_slide_release"
	
--HOLT 9mm + Akimbo
	self.reload_timelines.holt.start[1].sound = "wp_holt_mag_throw"
	self.reload_timelines.holt.finish[1].sound = "wp_holt_mag_in"
	self.reload_timelines.holt.finish[4].sound = "wp_holt_slide_release"
	
	self.reload_timelines.x_holt.start[1].sound = "wp_holt_mag_throw"
	self.reload_timelines.x_holt.finish[1].sound = "wp_holt_mag_in"
	self.reload_timelines.x_holt.finish[4].sound = "wp_holt_slide_release"

	
--Unlocking weapons for VR usage
	self.locked.weapons = nil
	
end)