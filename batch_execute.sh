#!/bin/bash
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ $# -lt 1 ]; then
    echo -e "Usage: bash $0 <CMD>"
    exit 1
fi

cmd=''
while (( "$#" )); do 
    cmd="$cmd $1"
    shift 
done

python_cmd="import os
with open('$BASEDIR' + os.sep + 'server_list.list') as f:
    print('\n'.join([i for i in f.read().split('\n') if i and not i.startswith('#')]))
"

server_list=`python -c "${python_cmd}"`

echo "Command: ${cmd}"
echo "will be execute in below servers: "
for i in ${server_list}
do
    echo $i
done

read -r -p "Are you sure? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])

        for i in ${server_list}
            do
                echo "---------- $i ----------"
                ssh $i "${cmd}"
                echo "========================"
            done
        ;;
    *)
            echo "Your mind changed, Quitting..."
    exit 1
    ;;
esac