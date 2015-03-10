--Binary Heap Priority Queue (min first - max last)
--Cannot handle duplicated keys
--Tyler Richard Hoyer
--11/18/2014

local floor = math.floor
local Queue = {}

--The constructor for the queue, adds methods to an empty table
local function new()
	return setmetatable({values = {}}, Queue)
end

--Adds a pair to the queue
local function push(queue, key, value)
	--Start at the end of the queue
	local current = #queue + 1
	
	--And find the parent node
	local parent = floor(current / 2)
	
	--While not at the top of the queue and less than the parent node
	while parent > 0 and queue[parent] > key do
		--Move the parent node down
		queue[current] = queue[parent]
		
		--Move the current node up
		current = parent
		
		--and update the parent
		parent = floor(current / 2)
	end
	
	--Finally, insert the value at the desired position
	queue[current] = key
	queue.values[key] = value
end

--Updates the position of a pair. The updated
--key must be smaller. Can use a hash table to
--increase speed.
local function update(queue, oldKey, key, value)
	--Search for the old listing
	local current
	for i = 1, #queue do
		if queue[i] == oldKey then
			current = i
			break
		end
	end
	
	--Set the parent and perform a heap up like in the push method
	local parent = floor(current / 2)
	while parent > 0 and queue[parent] > key do
		queue[current] = queue[parent]
		current = parent
		parent = floor(current / 2)
	end
	
	--Finally, insert the value at the desired position
	queue[current] = key
	queue.values[key] = value
end

--returns the value with the lowest key and removes it from the queue.
local function pop(queue)
	local size = #queue
	
	--Store the lowest value for later
	local retVal = queue.values[queue[1]]
	
	--Start with the first child
	local child = 2
	
	--Go until the fourth or third to last child
	while child < size - 1 do
		--Find the lesser of the two children and
		--move that child up and move onto its children.
		if queue[child + 1] < queue[child] then
			queue[child/2] = queue[child + 1]
			child = child * 2 + 2
		else
			queue[child/2] = queue[child]
			child = child * 2
		end
	end
	
	--If we ended with the last child
	if child == size then
		--Move it up
		queue[child/2] = queue[child]
	--If we ended with the second to last child
	elseif child == size - 1 then
		--Check which is smaller, the last or second the last
		--and move it up. If it is the second the last child,
		--move the last child into the second to last child's
		--position to avoid making a hole in the data.
		if queue[child] < queue[size] then
			queue[child/2] = queue[child]
			queue[child] = queue[size]
		else
			queue[child/2] = queue[size]
		end
	end
	
	--Remove the last value 
	--(it was copied somewhere else)
	queue[size] = nil
	
	--Return the value with the smallest key stored from the start
	return retVal
end

--Set the properties of the Queue
Queue.__index = Queue
Queue.new = new
Queue.push = push
Queue.update = update
Queue.pop = pop

--Return the Queue class
return Queue
