print "Starting nuke Script"

nuke.startPerformanceTimers()

count =0
for n in nuke.allNodes(recurseGroups = True):
    nuke.toNode(n.fullName())
    
    if "Read" in n.fullName():
        count += 1

        print "Fullname: " + n.fullName() + " | NodeClass: " + n.Class()
        print n.performanceInfo()

print count
print "End of nuke script"
