
// Scratch file

let perms: FilePermissions = [.setUserID, .ownerReadWriteExecute, .groupExecute, .otherExecute]


print(perms.contains(.setUserID)) // true
print(perms.contains(.otherRead)) // false


import Darwin

// TODO: Convert docs to tests
//
// FilePath docs
let message: String = String(mach_absolute_time()) + "\n"
let path: FilePath = "/tmp/log"
let fd = try FileDescriptor.open(path, .writeOnly, options: .append)
try fd.closeAfter { _ = try fd.write(message.utf8) }

