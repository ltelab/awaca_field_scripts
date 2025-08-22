This is a non-comprehensive collection of useful things related to the metek software on the mira pc.

Heather Corden August 2025

# Starting the radar

If you change the radar box or the pc, you need to run `start_dsp` in a terminal so that the radar is detected by the pc. This is also useful for troubleshooting if you can't connect to the radar.

# lincc

The radar control graphical software is opened by running `lincc` in a terminal. If the alias `linnc` does not work, you can run `wine /home/data/metek/m36s/WindowsClients/CAQ4_CC.exe`.

Connect to the radar by clicking on 'CONN' and adding the following settings. The password is the same as for the data user of the mira pc.

![lincc login page](/mira/doc_images/lincc_login.png)

Turn the radar on by successively pressing the 'on' buttons next to Receiver, Transmittor, Radiation. You can ignore the warning about pressure in the waveguides. All the small 'lights' should be green. If the radar is radiating, the red light on the radar box turns on.

The settings used in the awaca campaign are as below. Note that in lincc, 'Update' means retrieve the current setting from the radar pc, whereas 'Apply' means save and apply the new settings inputted into the boxes.

![lincc settings](/mira/doc_images/lincc_settings.png)

You should make sure that Autorestart is turned on. This is found under 'HEALTH' -> 'SUB-SYSTEM'

![lincc autorestart](/mira/doc_images/lincc_autorestart.png)

Under 'HEALTH' -> 'ERRORS' you can see current errors.

Once you have started the radar and inputted the correct settings, click 'CONN' to close the connection with the radar, and close lincc.

Then, in the terminal, run `get_processing`. This applies all the settings from lincc and starts saving the radar data in .znc files in the directory /mom/. get_processing is run automatically every hour but should be run manually after settings are changed.

However, some of the settings set in lincc might be overwritten by running `get_processing`. If settings are hard-written in the get_processing script they override settings from lincc. Therefore it is good to check by reopening lincc and checking the settings are the same as desired.

If you need to change a hard-written setting, you can edit the get_processing script which is stored at `/home/data/metek/m36s/bin/get_processing`. The setting most-likely to be hard-written is the averaging time. Check the line
```
set navexcrl = 73
```

# Files

The incoming radar data is first saved to a .pds file. These are continually converted to .znc files by the metek processing software. For the awaca mira radars, the .pds files are deleted after they have been converted to .znc files. They are therefore stored on a ram drive. The size of the ram drive has to be changed according to the settings chosen. If you make any modifications that increase the pds file size the size of the ram disk has to be adapted in `/etc/init.d/start.local`. The size of the ram disk should 3.2 * size of the hourly pds files. The current size of 9400m seems to work well for the settings above. The line in start.local is `mount -t tmpfs none /ramdisk -o size=9400m`.

The processed netcdf .znc files are saved at /mom/

You can check a netcdf file is growing by running `ncdump -v time filename`.

# Log emails

The mira sends log emails automatically when an error is detected. You can add an email address in 'data/metek/m36s/local/emails'.

# Automatic restart

For awaca, the mira pc is set up to automatically restart after a power cut, including restarting the transmission with the current settings. This starts as soon as `get_processing` has been run. The automatic restart behaviour is controlled by a script `/home/data/metek/m36s/bin/RestartRadarAfterPowerfailure` (shouldn't need to change anything in this script). 

The automatic restart should be tested whilst on-site!

Before removing the waveguides, you should run `kill_processing` to stop the automatic restart behaviour, to avoid transmitting without the waveguides.








