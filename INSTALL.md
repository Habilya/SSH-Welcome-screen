# Custom SSH welcome screen
This screen is what the server administrator ever needs on one page.
A custom ASCII art of Montreal, a city where I live. 
CPU temperature, Load Average, Memory and Disk usage, Available system updates, that is to name a few...

Before you start, this script requires **bc** to perform some calculations, if you don't already have it, install it:

`sudo apt-get install bc`



Let's start with the number of available system updates, you need to write a simple script to be executed as root. 
If you don't have the scripts directory created, create it and a root directory, for all the scripts to be executed by root user.

`sudo mkdir -p /var/zzscriptzz/root/`

Create update_checker.sh bash script.

`sudo nano /var/zzscriptzz/root/update_checker.sh`

Paste this inside the file, save and exit (CTRL+X, Y).

```
#!/bin/bash

apt-get update
apt-get upgrade -d -y | grep 'upgraded,' | awk {'print $1'} > /var/zzscriptzz/MOTD/updates-available.dat
echo "Update Check Complete"
```

This is a script that you are going to automate with cron, it writes the number of new updates available for your operating system in this file:

```
/var/zzscriptzz/MOTD/updates-available.dat
```

Now, make this script executable.

`sudo chmod +x /var/zzscriptzz/root/update_checker.sh`


Then, configure this script to be executed by cron every 3 hours.

`sudo crontab -e`

add this line at the bottom, save and exit.
```
0 */3 * * * /var/zzscriptzz/root/update_checker.sh > /dev/null 2>&1
```

This will run the script automatically every 3 hours, so the available system updates will be checked and logged to be displayed on your welcome screen.

## The Message of the day itself
Create a directory to store the MOTD / Welcome Screen script itself. This script will be executed as a normal user, your user.

`sudo mkdir /var/zzscriptzz/MOTD`

Change the owner of the directory to your user, you are using to SSH into your machine.

`sudo chown -R [YOUR_USER]:[YOUR_USER] /var/zzscriptzz/MOTD`

Create the script

`nano /var/zzscriptzz/MOTD/MOTD.sh`

paste the contents of SCRRIPT/MOTD.sh of this repository.

Now, save, exit and make this script executable.

`chmod +x /var/zzscriptzz/MOTD/MOTD.sh`


## Applying the custom welcome message
Those commands easier to be executed as root user, so:
```
su

echo '' > /etc/motd

nano /etc/ssh/sshd_config
```

Change values of following the values displayed below.
```
PrintLastLog no
PrintMotd no
```
Now, let's restart SSH service: `/etc/init.d/ssh restart`

Now, edit this file: `nano /etc/pam.d/login`

And comment this line

```
#session optional pam_motd.so
```

Edit this file as well: `nano /etc/profile`

Add this at the end of the file: `/var/zzscriptzz/MOTD/MOTD.sh`

save CTRL+X Y.

Exit from root.

`exit`


Run the update checker for the first time

```
sudo /var/zzscriptzz/root/update_checker.sh
```

If you've done everything correctly, on every login via SSH, you should enjoy your custom, informative welcome screen.
