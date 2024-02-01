#!/usr/bin/env lua
-- mod.lua
-- Glenn G. Chappell
-- 2024-01-31
--
-- For CS 331 Spring 2024
-- Code from Jan 31 - Lua: Modules


-- Import ("require" in Lua-speak) a module.
mymodule = require "mymodule"

-- Use a function from the module.
arg = 5            -- To be passed to mymodule.square_plus_one
result = mymodule.square_plus_one(arg)
io.write("Here is mymodule.square_plus_one("..arg.."): "..result.."\n")
io.write("\n")

-- Use another function from the module.
msg = "Hi there"   -- To be printed in a fancy way
mymodule.print_with_stars(msg)
io.write("\n")

-- To avoid doing "mymodule." we can set a variable to a module member.
print_with_stars = mymodule.print_with_stars
print_with_stars("Hello")
io.write("\n")
pws = print_with_stars
pws("Yo!")

-- See file mymodule.lua for the module itself.


io.write("\n")
io.write("This file contains sample code from January 31, 2024,\n")
io.write("for the topic \"Lua: Modules\".\n")
io.write("It will execute, but it is not intended to do anything\n")
io.write("useful. See the source.\n")

io.write("\n")
-- Uncomment the following to wait for the user before quitting
--io.write("Press ENTER to quit ")
--io.read("*l")

