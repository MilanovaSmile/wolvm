# wolvm
Wake-on-Lan for virtual machines. The application listens to network interfaces waiting for a "magic packet". When a packet is received, a search is performed for a virtual machine whose MAC address of the network interface matches the received MAC address. The search for a virtual machine is performed via virsh.

# Install

1. Copy wolvm.sh to /usr/local/bin
```shell
sudo cp ./wolvm.sh /usr/local/bin/
```
2. Set permissions
```shell
sudo chmod 755 /usr/local/bin/wolvm.sh
sudo chmod +x /usr/local/bin/wolvm.sh
sudo chown $USER:$USER /usr/local/bin/wolvm.sh
```
3. Add to startup, create new startup file
```shell
sudo systemctl edit --force --full wolvm.service
```
4. Add to startup, copy the contents to a new startup file
```
[Unit]
Description=Wake-on-Lan for virtual machines.
After=multi-user.target

[Service]
Type=idle
ExecStart=/usr/local/bin/wolvm.sh

[Install]
WantedBy=multi-user.target
```
5. Add to startup, activate the service
```shell
sudo systemctl daemon-reload
sudo systemctl enable wolvm.service
```

# Tested
|         OS         | Status |
|--------------------|:------:|
| Linux Ubuntu 24.10 |    ✅   |
