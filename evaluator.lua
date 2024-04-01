-- evaluator.lua  UNFINISHED
-- Glenn G. Chappell
-- 2024-03-31
--
-- For CS 331 Spring 2024
-- Evaluator for Arithmetic Expression AST (rdparser3.lua format)
-- See evalmain.lua for a sample main program.


local evaluator = {}  -- Our module


-- Symbolic Constants for AST

local BIN_OP     = 1
local NUMLIT_VAL = 2
local SIMPLE_VAR = 3


-- Primary Function

-- evaluator.eval
-- Takes AST in form specified in rdparser3.lua and values of variables.
-- Returns numeric value. No error checking is done.
--
-- Example of a simple tree-walk interpreter.
function evaluator.eval(ast, vars)
    -- TODO: WRITE THIS!!!
    return 42  -- DUMMY
end


-- Module Export

return evaluator

