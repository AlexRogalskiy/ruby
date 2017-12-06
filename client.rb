require 'drb/drb'

DRb.start_service
robj = DRbObject.new_with_uri("druby://localhost:8787")
robj.push "test", "network", "connection"
p robj.last