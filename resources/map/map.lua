return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "1.1.3",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 100,
  height = 100,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 26,
  properties = {},
  tilesets = {
    {
      name = "Dungeon sample",
      firstgid = 1,
      filename = "dungeon.tsx",
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "../sprites/dungeon_tiles.png",
      imagewidth = 368,
      imageheight = 384,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 16,
        height = 16
      },
      properties = {},
      terrains = {},
      tilecount = 552,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Background",
      x = 0,
      y = 0,
      width = 100,
      height = 100,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      chunks = {
        {
          x = 0, y = -32, width = 16, height = 16,
          data = "eJxjYBgFo2AUDBegTiIGADOIAdU="
        },
        {
          x = 16, y = -32, width = 16, height = 16,
          data = "eJxjYBgFo2AUDFWgAcRaQCwJxFJALA3EMiToBwAseAC9"
        },
        {
          x = 0, y = -16, width = 16, height = 16,
          data = "eJxjYEAF6iRidDCqf2jrtyMRowMJINYiAWPTLwnEUkAsDWXD+J5Y5NCBPhAbALEhEBtB2eh8ZDY6cANidyD2gNrnjsSXxiKHDmKBOA6I44E4AcpG5yOz0cF8RtIwqfoXAPFCJDYAIgMtuw=="
        },
        {
          x = 16, y = -16, width = 16, height = 16,
          data = "eJzTYGBg0AJiaSA2BGIjIDZmIB5oQPW7A7EHEHsCsRcZ+iWBWArqDhky9BswDA73g/QPhPtB4UaO++0ptB+mF1k/KfbDwozc+IfZSa77YWFGbvzHA3ECEMchsRNJ0D+fERUvAOKFjMTrX8iIHRMLAHu4GOU="
        },
        {
          x = 0, y = 0, width = 16, height = 16,
          data = "eJxjYEAF2xgZGLYD8Q48GFnNKBgFo2DoAgBVLwin"
        },
        {
          x = 16, y = 0, width = 16, height = 16,
          data = "eJzbwcjAsAMLHgWjYBQMfwAAMZ0EVw=="
        }
      }
    },
    {
      type = "tilelayer",
      name = "Destructibles",
      x = 0,
      y = 0,
      width = 100,
      height = 100,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      chunks = {
        {
          x = 0, y = -16, width = 16, height = 16,
          data = "eJxjYBgFo2BwgcNQ+iCZ+m8BcSoQ38AiF4CEA0k0NxOI05FwBpnuG0wAAHsFBuM="
        }
      }
    },
    {
      type = "objectgroup",
      name = "Game objects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 4,
          name = "water",
          type = "Water",
          shape = "rectangle",
          x = 64,
          y = -272,
          width = 208,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "small_box",
          type = "Destructible",
          shape = "rectangle",
          x = 176,
          y = -64,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "box",
          type = "Destructible",
          shape = "rectangle",
          x = 192,
          y = -64,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "box",
          type = "Destructible",
          shape = "rectangle",
          x = 208,
          y = -64,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "box",
          type = "Destructible",
          shape = "rectangle",
          x = 224,
          y = -64,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 19,
          name = "chest",
          type = "Chest",
          shape = "rectangle",
          x = 96,
          y = -80,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 21,
          name = "wall",
          type = "Wall",
          shape = "rectangle",
          x = 64,
          y = -32,
          width = 288,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 23,
          name = "wall",
          type = "Wall",
          shape = "rectangle",
          x = 352,
          y = -272,
          width = 16,
          height = 272,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 24,
          name = "wall",
          type = "Wall",
          shape = "rectangle",
          x = 48,
          y = -272,
          width = 16,
          height = 272,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 25,
          name = "",
          type = "",
          shape = "rectangle",
          x = 416,
          y = -160,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
