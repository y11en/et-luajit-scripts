--[[
#*************************************************************
#  Copyright (c) 2003-2013, Emerging Threats
#  All rights reserved.
#  
#  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the 
#  following conditions are met:
#  
#  * Redistributions of source code must retain the above copyright notice, this list of conditions and the following 
#    disclaimer.
#  * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the 
#    following disclaimer in the documentation and/or other materials provided with the distribution.
#  * Neither the name of the nor the names of its contributors may be used to endorse or promote products derived 
#    from this software without specific prior written permission.
#  
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS AS IS AND ANY EXPRESS OR IMPLIED WARRANTIES, 
#  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
#  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
#  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
#  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
#
#*************************************************************

This lua script can be run standalone and verbosely on a URI
echo "run()" | lua -i <script name> <URI>

It's based on research at http://malwarebiopsy.blogspot.co.uk/2013/06/styx-exploit-kit-pattern-emerges.html

Chris Wakelin
--]]

function init (args)
    local needs = {}
    needs["http.uri"] = tostring(true)
    return needs
end

-- return match via table
function common(a,verbose)
    if verbose == 1 then print("Checking URI " .. a) end

    a = a:gsub("/%w+%.%w+$","")
    a = a:gsub("[/_%-]","")
    if verbose == 1 then print("URI after stripping is " .. a) end

    if #a < 200 or (#a % 5) ~= 1 then return 0 end
    if verbose == 1 then print("URI is right length " .. #a) end

    if a:find("^%w%w%w%w%w%w",1,false) and string.gsub(a:sub(7),"[01]%w%w%w%w","") == "" then
        if verbose == 1 then print("URI matches Styx pattern") end
        return 1
    end

    return 0
end

-- return match via table
function match(args)
    local t = tostring(args["http.uri"])
    return common(t,0)
end

function run()
  local t = arg[1]
  common(t,1)
end
