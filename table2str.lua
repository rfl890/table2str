local function TableToString(Table)
    local function tlen(t)
        local c = 0
        for i, v in pairs(t) do
            c = c + 1
        end
        return c
    end
    local function split(inputstr, sep)
        sep = sep or '%s'
        local t = {}
        for field, s in string.gmatch(inputstr, "([^" .. sep .. "]*)(" .. sep .. "?)") do
            table.insert(t,field)
            if s == "" then
                return t
            end
        end
    end
    local function colorize(text, color)
        local cols = {
            ["reset"] = "[0m";
            ["yellow"] = "[33;1m";
            ["green"] = "[32;1m";
            ["blue"] = "[34;1m";
            ["red"] = "[31;1m";
            ["magenta"] = "[35;1m";
            ["cyan"] = "[36;1m";
            ["white"] = "[37;1m";
            ["black"] = "[30;1m";
        }
        return "" .. cols[color] .. text .. "" .. cols.reset;
    end
    local TabRef = tostring(Table);
    local Table1 = {"{"}
    local Tabs = 4
    for k, v in pairs(Table) do
        local str = "    "
        if type(k) == "number" then
            str = str .. "[" .. colorize(k, "green") .. "]"
        elseif type(k) == "string" then
            str = str .. "[" .. colorize([["]] .. k .. [["]], "yellow") .. "]"
        end
        if type(v) == "number" then
            str = str .. " = " .. colorize(v, "green")
        elseif type(v) == "string" then
            str = str .. " = ".. colorize([["]] .. v .. [["]], "yellow")
        elseif type(v) == "boolean" then
            str = str .. " = ".. colorize(tostring(v), "blue")
        elseif type(v) == "table" then
            if not (tostring(v) == TabRef) then
                local tmpStr = TableToString(v)
                local tmpTable = split(tmpStr, "\n")
                local newStr = "";
                for i, v in pairs(tmpTable) do
                    if i == tlen(tmpTable) then
                        newStr = newStr .. string.rep(" ", Tabs) .. v
                    elseif i == 1 then
                        newStr = newStr .. v .. "\n"
                    else
                        newStr = newStr .. string.rep(" ", Tabs) .. v .. "\n"
                    end
                end
                str = str .. " = " .. newStr
            else
                str = str .. " = " .. "self"
            end
        elseif type(v) == "function" then
			local funstr = colorize("[Function: " .. string.sub(tostring(v), 11) .. "]", "blue")
            str = str .. " = " .. funstr;
		else
            str = str .. " = " .. tostring(v);
		end
        str = str .. ";"
        table.insert(Table1, str)
    end
    if (tlen(Table) < 1) then
        table.insert(Table1, string.rep("", 4))
    end
    table.insert(Table1, "}")
    return table.concat(Table1, "\n", 1,  #Table1)
end
return TableToString
