
// Scratch file

let perms: FilePermissions = [.setUserID, .ownerReadWriteExecute, .groupExecute, .otherExecute]


print(perms.contains(.setUserID)) // true
print(perms.contains(.otherRead)) // false


import Darwin


