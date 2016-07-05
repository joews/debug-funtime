# debug-funtime
An environment to learn Linux trace and debugging tools. I'm working on a Mac, so this repo includes a Dockerfile for a Linux image with debug tools installed.

## MDB

[mdb](https://www.joyent.com/developers/node/debug/mdb) runs on SmartOS/Illumos. The easiest way to run it on Linux/OSX is [autopsy](https://github.com/nearform/autopsy).

    ❯ npm run autopsy -- start
    ❯ npm run mdb <core file>

## strace

* I started with Julia Evans' [how to spy on your programs with strace](http://jvns.ca/strace-zine-unfolded.pdf) zine.
* The rest of Julia Evans' [blogs on strace](http://jvns.ca/blog/categories/strace/)
* [Strace - the Sysadmin's Microscope](https://blogs.oracle.com/ksplice/entry/strace_the_sysadmin_s_microscope)

I immediately hit https://github.com/docker/docker/issues/21051, where `strace` doesn't have permission to run. I fixed that by adding ` --cap-add=SYS_PTRACE --security-opt=apparmor:unconfined` to my `docker run` command.

`strace` writes traces to STDERR. To read everything together: `strace ls -la /etc 2>&1 | less`, or use `-o` to write to a file instead.

Syscalls have man pages (man section 2): `man 2 execve`.

Some useful options:

* `-o <filename>` - write to `filename` instead of `stderr`
* `-e trace=file` - show only syscalls that take a filename as an arg
* `-f` - trace child processes
* `-c` - get stats for time spend in each syscall instead of a trace. Works with `-e`, e.g. `strace -c -e open,write vi test.txt` for "how much time is spend in open and write syscalls"?
* `-y` - include filenames with file descriptors (`3<t.txt>` instead of just `3`)

* `-tt` - show time of day (with microseconds) for each syscall
* `-T` - show time spent in each system call (microsecs). 
* These are useful together, e.g. `strace -ttT vi test.txt`
* `-p <pid>` - strace a running process
* `-s <m>` display `n` bytes of content (default 32) for syscalls. E.g. to view full(er) HTTP traffic:

    ❯ strace -s 1024 -e sendto,recvfrom -o curl.strace curl http://google.com
    ❯ less curl.strace
    sendto(3, "GET / HTTP/1.1\r\nUser-Agent: curl/7.29.0\r\nHost: google.com\r\nAccept: */*\r\n\r\n", 74, MSG_NOSIGNAL, NULL, 0) = 74
    recvfrom(3, "HTTP/1.1 302 Found\r\nCache-Control: private\r\nContent-Type: text/html; charset=UTF-8\r\nLocation: http://www.google.co.uk/?gfe_rd=cr&ei=VJR7V_vdAefR8getx6-oDA\r\nContent-Length: 261\r\nDate: Tue, 05 Jul 2016 11:04:52 GMT\r\n\r\n<HTML><HEAD><meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\">\n<TITLE>302 Moved</TITLE></HEAD><BODY>\n<H1>302 Moved</H1>\nThe document has moved\n<A HREF=\"http://www.google.co.uk/?gfe_rd=cr&amp;ei=VJR7V_vdAefR8getx6-oDA\">here</A>.\r\n</BODY></HTML>\r\n", 16384, 0, NULL, NULL) = 477

### Examples

What order does bash read config files?

    ❯ strace -f -y -e trace=file -o bash.strace bash --login -c "echo hi"
    ❯ less bash.strace

    1037  open("/etc/profile", O_RDONLY)    = 3
    1037  open("/home/user/.bash_profile", O_RDONLY) = 3
    1037  open("/home/user/.bashrc", O_RDONLY) = 3

# TODO

* ltrace - [trace userland library calls](http://jvns.ca/blog/2016/06/15/using-ltrace-to-debug-a-memory-leak/)
* netstat
* dstat
* tcpdump
* iostat
* gdb
* lsof  
* dmesg
