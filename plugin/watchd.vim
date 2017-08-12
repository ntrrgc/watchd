pythonx << EOF
import socket

def watchd_pub():
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    try:
        sock.connect('/tmp/watchd.sock')
        sock.send(b'CHANGE\n')
    except socket.error:
        # Silently ignore (the server is off, so there are no subscribers)
        return
    finally:
        sock.close()

EOF

function! WatchdNotify()
  pythonx << EOF
watchd_pub()
EOF
endfunction

autocmd BufWritePost * call WatchdNotify()
