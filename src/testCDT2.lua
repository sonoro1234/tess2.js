
---------------------------------------- test
local ok, lp_time = pcall(require,"luapower.time")
if not ok then print(lp_time) end
local tim = ok and lp_time.time or os.time
local clk = ok and lp_time.clock or os.clock

local contours = {{}}
--local f,err = io.open("../test/data/bird.dat")
--local f,err = io.open("../test/data/nazca_monkey.dat")
local f,err = io.open("../test/data/debug2.dat")
-- local f,err = io.open("../test/data/glu_example.dat")
--local f,err = io.open("../test/data/glu_winding.dat")
assert(f,err)
--local mat = require"anima.matrixffi"
require"anima"
while true do
  local nn = f:read"*l"
  if nn==nil then break end
  if nn=="" then 
	table.insert(contours,{})
  else
	-- table.insert(contours[#contours],tonumber(nn:match("([^,%s]+)[,%s]")))
	-- table.insert(contours[#contours],tonumber(nn:match("[,%s]([^,%s]+)")))
	table.insert(contours[#contours], mat.vec2(tonumber(nn:match("([^,%s]+)[,%s]")),tonumber(nn:match("[,%s]([^,%s]+)"))))
  end
  --print(nn)
end
f:close()
--prtable(contours)
--local glu_tess = require"anima.Fonter.glu_tesselator"
--local CG = require"anima.CG3"
-- collectgarbage()
-- collectgarbage()
-- collectgarbage("stop")

require("jit.p").start("3vfsi4m1",'profReportCDT.txt')

local t1 = tim()
local clk1 = clk()
local polisiz = 3
local CG = require"anima.CG3"
print(#contours ,"countours")

--CG.EarClipSimple2(contours[1],true)
local pts = contours[1]
local ptsOr = {}
for i=1,#pts do ptsOr[i]=pts[i] end
		
local inds = CG.lexicografic_sort(pts, true)
local CH,tr = CG.triang_sweept(pts)
local tr2 = {}
for i=1,#tr do tr2[i] = inds[tr[i]+1]-1 end
print("done sweep in", tim()-t1, clk()-clk1)		
local conts = {}
		local Polind = {}
		for i=1,#pts do Polind[i]=i end
		conts[1] = Polind
		local sum = #Polind

		local indexes2 = CG.CDTinsertion(ptsOr,tr2,conts,{}, false)
--for ii=1,10 do
-- print"going glu tessel"
--local Mesehs = glu_tess.tesselate_set(contours)

--end
print("done in", tim()-t1, clk()-clk1)

require("jit.p").stop()

if false then
for i = 0,tess.elements.length-1,polisiz do
	--ctx.beginPath();
	print" begin path"
	for j = 0, polisiz-1 do
		local idx = tess.elements[i+j];
		if (idx == -1) then goto continue end
		if (j == 0) then
			--ctx.moveTo(tess.vertices[idx*2+0], tess.vertices[idx*2+1]);
			print(tess.vertices[idx*2+0], tess.vertices[idx*2+1]);
		else
			--ctx.lineTo(tess.vertices[idx*2+0], tess.vertices[idx*2+1]);
			print(tess.vertices[idx*2+0], tess.vertices[idx*2+1]);
		end
		::continue::
	end
	print"end path"
	--ctx.closePath();
	--ctx.stroke();
	--ctx.fill();
end
end