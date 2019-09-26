#!/bin/bash

app=""
isKill=0
isShow=0

show() {
    arg=$1
    ps aux | grep -i "$arg" | grep -v grep | grep -v cleanmac
}

killapp() {
    arg=$1
    show $arg | awk '{print $2}' | while read pid; do echo "$pid"; sudo kill -9 $pid; done
}

check() {
    arg=$1
    echo "check /Library/LaunchAgents ..."
    ls -l /Library/LaunchAgents/ | grep -i "$arg"
    echo
    echo "check /Library/LaunchDaemons ..."
    ls -l /Library/LaunchDaemons/ | grep -i "$arg"
    echo
    echo "check /Library/StartupItems ..."
    ls -l /Library/StartupItems/ | grep -i "$arg"
    echo
}

gettestopt() {
    getflag=0
    while getopts ":hksa:" opt; do #不打印错误信息, -a -c需要参数 -b 不需要传参  
        case $opt in
        k)
            isKill=1
            getflag=$((getflag+1))
            ;;
        s) 
            isShow=1
            getflag=$((getflag+1))
            ;;
        a)
            app=$OPTARG
            echo "process app $app"
            getflag=$((getflag+1))
            ;;
        h)
            echo "usage: -k kill app; -s show app; -a <appname>; -h help"
            exit 0
            ;;
        :)
            echo "Option -$OPTARG requires an argument." 
            exit 1
            ;;
        ?) #当有不认识的选项的时候arg为?
            echo "Invalid option: -$OPTARG index:$OPTIND"
            exit 2
            ;;
        esac
    done

    if (( "$getflag" < 2 )) || [[ "$app" == "" ]]
    then
        echo "use -h for help, get opts $getflag"
        exit 3
    fi
}

gettestopt $@

if (( $isShow > 0 ))
then
    echo "show app $app ..."
    show $app
    echo
    echo "check app $app ..."
    check $app
    echo
fi

if (( $isKill > 0 ))
then
    echo "kill app $app ..."
    killapp $app
    echo
fi

