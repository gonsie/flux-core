package.path = "liblua/?.lua;" .. package.path

local hostlist = require ("hostlist")
local tree = require ("tree")

if pepe.rank == 0 then
    local env = pepe:getenv()
    local v,err = pepe:getenv("ENV")
    if not v then
	print ("getenv(ENV): " .. err .. "\n")
    end
    pepe:unsetenv ("ENV")
    pepe:setenv ("HAVE_PEPE", 1)
    pepe:setenv ("PS1", "${SLURM_JOB_NODELIST} \\\u@\\\h \\\w$ ")

end

local h = hostlist.new (pepe.nodelist)
local mport = 5000 + tonumber (pepe:getenv ("SLURM_JOB_ID")) % 1024;
local eventuri = "epgm://eth0;239.192.1.1:" .. tostring (mport)
local dnreqouturi = "tcp://*:5557"

if pepe.rank == 0 then
    local topology = tree.k_ary_json (48, #h)
    pepe.run ("./cmbd --up-event-uri='" .. eventuri .. "'"
		.. " --dn-req-out-uri='" .. dnreqouturi .. "'"
		.. " --rank=" .. pepe.rank
		.. " --size=" .. #h
		.. " --hostlist=" .. pepe.nodelist
		.. " --logdest cmbd.log"
		.. " --plugins=api,barrier,live,log,kvs,sync,mecho"
		.. " kvs:conf.sync.period-sec=1.5"
		.. " kvs:conf.log.reduction-timeout-msec=100"
		.. " kvs:conf.log.circular-buffer-entries=100000"
		.. " kvs:conf.log.persist-level=debug"
		.. " kvs:conf.live.missed-trigger-allow=5"
		.. " kvs:conf.live.topology='" .. topology .. "'")
else
    local parent_rank = tree.k_ary_parent (pepe.rank, 48)
    local u1 = "tcp://" ..  h[parent_rank + 1] .. ":5556"
    local u2 = "tcp://" ..  h[parent_rank + 1] .. ":5557"
    pepe.run ("./cmbd --up-event-uri='" .. eventuri .. "'"
		.. " --dn-req-out-uri='" .. dnreqouturi .. "'"
		.. " --parent='" .. parent_rank .. "," .. u1 .. "," .. u2 .. "'"
		.. " --rank=" .. pepe.rank
		.. " --size=" .. #h
		.. " --plugins=api,barrier,live,log,kvs,mecho")
end
