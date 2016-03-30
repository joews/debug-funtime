# debug-funtime
An environment to test node.js debug tools for Linux

## Notes

[mdb](https://www.joyent.com/developers/node/debug/mdb) runs on SmartOS/Illumos. The easiest way to run it on Linux/OSX is [autopsy](https://github.com/nearform/autopsy).

    ❯ npm run autopsy -- start
    ❯ npm run mdb <core file>
