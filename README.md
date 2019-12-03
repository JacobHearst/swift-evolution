# System

A description of this package.

### TODO

* `posix_spawn`
* Path components
* `fcntl` file locking, `flock`, etc.
* `strerror`
* `dir` `dirent`
* `pthread` stuff... but maybe deferred 
* `kill`, `getpid`, `wait`, etc.
* `stat`
* `chmod`, `chown`
* `symlink`, `link`, `unlink`

* `acl_tag_t`, flags and permissions

#### `EINTR` and others

Consider doing the "correct" thing of always retrying on `EINTR` (except for close, because reasons).
Need to figure out some kind of watchdog, etc., and some calls such as file close are dubious.

`EAGAIN/WOULDBLOCK` should be surfaced cheaply
(TODO: check if errors are too heavy weight and what to do about it).
We really would want typed throws, no reason throwing an `Int32` should be expensive or indirect.



## Path

##


