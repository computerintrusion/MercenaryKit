--[[ 

    @computerintrusion 03-27-2026 
    
    not gonna even try to troll,  this was vibecoded lmfao, thank israel. 
    the main reason i chose to  do it is because i really had no idea how 
    to implement it without  over engineering, or making it difficult to use. 
    also, ai is so normalized in programming now, so does anyone even care?... 
    
    i looked at other building methods, like using rokit + darklua, 
    and some other methods but this was the simplest method i could 
    think of, but i couldn't figure out how to remove all of the comments 
    safely, so yeaaah.. until i find a better way of writing our build 
    file or compilation process, this is how we do it generates a file named 
    'MercenaryKit.lua', which is one big line of our Foundation.lua file,
    without relying on sending requests to get the source. the speed of 
    which this is now is insane. glad i could at least implement it, 
    but sad i wasn't able to do it completely by myself. 
]]


local sourceDirectory = "MercenaryKit/";
local outputFileName = "MercenaryKit.lua";

local included = {};

local function log(msg)
    print("[BuildMercenaryKit]", msg);
end;

local function readfile(path)
    local file = assert(io.open(path, "r"), "File not found: " .. path);
    local content = file:read("*a");
    file:close();
    return content;
end;

local function writefile(path, content)
    local file = assert(io.open(path, "w"));
    file:write(content);
    file:close();
end;

local function removeComments(src)
    local out = {};
    local i = 1;
    local len = #src;

    while (i <= len) do
        local c = src:sub(i, i);

        -- line or block comment
        if (c == "-" and src:sub(i, i + 1) == "--") then
            local rest = src:sub(i);

            -- block comment
            local eqs = rest:match("^%-%-%[(=*)%[");

            if (eqs) then
                local closing = "]" .. eqs .. "]";
                local closePos = src:find(closing, i + 4 + #eqs, true);

                if (closePos) then
                    i = closePos + #closing;
                else
                    break;
                end;
            else
                -- single line comment
                local nl = src:find("\n", i + 2, true);
                if (nl) then
                    i = nl + 1;
                else
                    break;
                end;
            end;

        -- strings (preserve them fully)
        elseif (c == '"' or c == "'") then
            local quote = c;
            table.insert(out, c);
            i = i + 1;

            while (i <= len) do
                local ch = src:sub(i, i);
                table.insert(out, ch);
                i = i + 1;

                if (ch == "\\") then
                    if (i <= len) then
                        table.insert(out, src:sub(i, i));
                        i = i + 1;
                    end;
                elseif (ch == quote) then
                    break;
                end;
            end;

        else
            table.insert(out, c);
            i = i + 1;
        end;
    end;

    return table.concat(out);
end;

local function normalize(src)
    src = src:gsub("[\r\n]+", " ");
    src = src:gsub("%s+", " ");
    return src;
end;

local function resolve(filePath)
    if (included[filePath]) then
        log("skipping already included: " .. filePath);
        return "";
    end;

    included[filePath] = true;

    local fullPath = sourceDirectory .. filePath;
    log("processing: " .. fullPath);

    local source = readfile(fullPath);

    source = source:gsub("frameworkimport%s*%(%s*['\"](.-)['\"]%s*%)", function(importPath)
        local resolved = importPath:gsub("\\", "/");
        log("inlining: " .. resolved);
        return "(function() " .. resolve(resolved) .. " end)()";
    end);

    source = removeComments(source);

    return source;
end;

local function build()
    log("starting build...");

    local startTime = os.clock();

    local f = io.open(outputFileName, "r");
    if (f) then
        f:close();
        log("deleting existing output file");
        os.remove(outputFileName);
    else
        log("no existing output file");
    end;

    local mainFile = "Foundation/Foundation.lua";
    log("file to compile: " .. mainFile);

    local compiled = resolve(mainFile);
    compiled = normalize(compiled);

    local header = [[
-- This file was generated using the MercenaryKit compiler v1.0.0

]];

    writefile(outputFileName, header .. " " .. compiled);

    local elapsed = os.clock() - startTime;

    log("build complete.");
    log("output: " .. outputFileName);
    log(string.format("compile time: %.4f seconds", elapsed));
end;

build();
