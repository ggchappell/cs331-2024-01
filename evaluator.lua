-- evaluator.lua
-- Glenn G. Chappell
-- Started: 2024-03-31
-- Updated: 2024-04-01
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
    local result, varname, op, arg1, arg2

    assert(type(ast) == "table")
    assert(type(vars) == "table")
    assert(#ast >= 1)
    if ast[1] == NUMLIT_VAL then         -- Numeric literal
        assert(#ast == 2)
        assert(type(ast[2]) == "string")
        result = tonumber(ast[2])
    elseif ast[1] == SIMPLE_VAR then     -- Named variable
        assert(#ast == 2)
        varname = ast[2]
        assert(type(varname) == "string")
        result = vars[varname]
        if result == nil then      -- Undefined variable
            result = 0
        end
    elseif type(ast[1] == "table") then  -- Operator
        assert(#ast == 3)
        assert(#ast[1] == 2)
        assert(ast[1][1] == BIN_OP)
        op = ast[1][2]
        assert(type(op) == "string")
        arg1 = evaluator.eval(ast[2], vars)
        arg2 = evaluator.eval(ast[3], vars)
        if op == "+" then
            result = arg1 + arg2
        elseif op == "-" then
            result = arg1 - arg2
        elseif op == "*" then
            result = arg1 * arg2
        else
            assert(op == "/")
            result = arg1 / arg2   -- Let IEEE floating-point handle
                                   --  things like div by zero
        end
    else
        assert(false)                    -- BAD AST
    end

    return result
end


-- Module Export

return evaluator

