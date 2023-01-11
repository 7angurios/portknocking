#!/bin/bash
if dpkg -s "knockd" &> /dev/null; then
    echo "knockd installed"
else
    echo "Installing knockd"
    apt-get install -y knockd
fi

if dpkg -s "sshpass" &> /dev/null; then
    echo "sshpass installed"
else
    echo "Installing sshpass"
    apt-get install -y knockd
fi

while ["$1" != ""]; do
    case $1 in
        -k | --knock )    shift
                          seq=$1
                          ;;
        -t | --target )   shift
                          tar=$1
                          ;;
        -u | --username)  shift
                          user=$1
                           ;;
        -p | --password   shift
                          pass=$1
                            ;;
        *)                usage
                          exit 1
    esac
    shift
done
knock -v $tar $seq
if ssh -q -o BatchMode=yes -o ConnectTimeout=5 $tar exit; then
    echo "successfull connection"
    sshpass -p $pass ssh $user@$tar
else
    echo "connection refused"
fi

function usage{
    echo "Usage: $0 -k PORT_SEQUENCE -t TARGET_IP -u USERNAME -p PASSWORD"
}