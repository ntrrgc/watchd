# watchd
Restart programs after saving... event based

This is a simple daemon to run things after saving files. Instead of relying on inotify to do the hard work, which is prone to errors due to the way editors actually modify files and often requires sleeping the thread fixed amounts of time, this solution uses a simple local PubSub server which is spawned automatically when needed.

You tell your editor (provided you use a configurable enough one) to run a command after saving a file, and that's it.

watchd is faster and more reliable than file system watchers like inotify.

![Screenshot of a terminal using watchd-monitor](https://i.imgur.com/gNYHtdQ.png)

##Installation

The server needs Python 2 and twisted.

    sudo apt-get install python-twisted

There are three programs in `bin/`: `watchd`, `watchd-monitor` and `watchd-notify`. Add the `bin/` directory to your `PATH` environment or link them to a directory you already have for that purpose.

##The editor

Tell your editor to run `watchd-notify` on save. For example, you can do this in Vim adding this to your `.vimrc`:

    autocmd BufWritePost * silent !watchd-notify

If you prefer, you can add instead `watchd.vim` to your `.vim/plugin` directory or install this repository with [Vundle](https://github.com/gmarik/Vundle.vim). `watchd.vim` uses Vim Python integration to do the same work without even spawning a process.

##The monitor

In your console, run `watchd-monitor` followed by what you want to run, e.g:

    watchd-monitor python myscript.py

`myscript.py` will be executed. Every time `watchd-notify` is run, `watchd-monitor` will stop the program with `SIGTERM` (if still running), wait for it to terminate and relaunch it.

You can have several monitors at the same time.

##The server

The server is spawned automatically when you run `watchd-monitor` if it is not running. You don't need to do anything else.

All the communication is done over a UNIX domain socket at `/tmp/watchd.sock`.
