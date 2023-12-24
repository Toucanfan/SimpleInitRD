log() {
    echo InitRD: $1 > /dev/kmsg
}

get_cmdline_opt() {
    opt="$1"
    for s in $(cat /proc/cmdline); do
        if [ "${s%%=*}" = $opt ]; then
            echo "${s#*=}"
        fi
    done
}
