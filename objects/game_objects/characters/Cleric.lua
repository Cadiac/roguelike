Cleric = Player:extend()

function Cleric:new(area, x, y, opts)
  Cleric.super.new(self, area, x, y, opts)

  self.v_max = 100

  self.mana = 150
  self.max_mana = 150
  self.mana_regen = 30

  self.hp = 125
  self.max_hp = 125

  self.equipped_skills = {
    ['skill_slot_1'] = Icewall(),
    ['skill_slot_2'] = Icewall(),
    ['skill_slot_3'] = Icewall(),
    ['skill_slot_4'] = Icewall()
  }
end

function Cleric:destroy()
  Cleric.super.destroy(self)
end

function Cleric:update(dt)
  Cleric.super.update(self, dt)
end
