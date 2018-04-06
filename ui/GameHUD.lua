function GameHUD(player, opts)
  ResourceBar(50, gh - 35, {
    resource = player.mana,
    resource_max = player.max_mana,
    color = mana_color,
    width = 100
  })
  ResourceBar(gw - 150, gh - 35, {
    resource = player.hp,
    resource_max = player.max_hp,
    color = hp_color,
    width = 100
  })
  ActionBarIcon(gw/2 - 67, gh - 35, player.equipped_skills.skill_slot_1, {
    current_mana = player.mana,
    hotkey = '1'
  })
  ActionBarIcon(gw/2 - 32, gh - 35, player.equipped_skills.skill_slot_2, {
    current_mana = player.mana,
    hotkey = '1'
  })
  ActionBarIcon(gw/2 + 3, gh - 35, player.equipped_skills.skill_slot_3, {
    current_mana = player.mana,
    hotkey = '3'
  })
  ActionBarIcon(gw/2 + 38, gh - 35, player.equipped_skills.skill_slot_4, {
    current_mana = player.mana,
    hotkey = '4'
  })
end
