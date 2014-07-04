classdef moab
   properties
       numberOfNodes = 1
       procsPerNode = 16
       WallTime = '00:20:00'
       % Please use metaq unless you require a specific node type
       queue = 'metaq'
       % All jobs should specify an account or RAPid
       account = 'wns-454-aa'
       % Specify the memory per process required
       pmem = '2700m'
       %You may use otherOptions to append a string to the qsub command
       % e.g.
       % otherOptions = '-M email@address.com -m bae'
       otherOptions = ''
   end
end





