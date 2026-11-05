"""HomeView helper code (Danish number formatting, weather icons, ...).

Shipped as an ESPHome external component so devices can use the HomeView
packages straight from GitHub: ``esphome: includes:`` paths are resolved
relative to the device YAML, which doesn't work for remote packages.
Every file in this folder is copied into the build; the header is added
to the generated main.cpp includes.
"""

import esphome.codegen as cg
import esphome.config_validation as cv

CODEOWNERS = ["@briis"]
DEPENDENCIES = ["lvgl"]

CONFIG_SCHEMA = cv.Schema({})


async def to_code(config):
    cg.add_global(cg.RawStatement('#include "esphome/components/homeview/homeview_helpers.h"'))
