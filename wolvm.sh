#!/bin/bash

sudo nc -dknl -p 9 -u | sudo stdbuf -o0 xxd -c 6 -p | sudo stdbuf -o0 uniq | sudo stdbuf -o0 grep -v 'ffffffffffff' | while read -r message ; do
    MAC=$(echo "$message" | cut -c1-2):$(echo "$message" | cut -c3-4):$(echo "$message" | cut -c5-6):$(echo "$message" | cut -c7-8):$(echo "$message" | cut -c9-10):$(echo "$message" | cut -c11-12)

	echo "Received a magic packet with MAC: ${MAC}"

    for VM in $(virsh list --all --name); do
        echo "Checking \"${VM}\""

        VM_MAC=$(virsh dumpxml $VM | grep "mac address" | awk -F\' '{ print $2}')

        if [ $VM_MAC = $MAC ]; then
            STATUS=$(virsh domstate $VM)

            case "$STATUS" in
                running)
                    echo "Virtual machine \"${VM}\" is already running"
                    ;;

                shut\ off)
                    echo "Start \"${VM}\""
                    virsh start $VM
                    ;;

                *)
                    echo "Unknown state: $STATUS"
                    ;;
            esac
        fi
    done
done