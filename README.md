battery-alert
=============

Monitors both batteries on my thinkpad and starts blinking the power LED if the
battery is below 5%.

Usage: 

This is in nim, so you'll have to install that. Other than that, it needs root
acces to write the LED state.

Once you get nim installed, compilation is as easy as `nim c battery_alert.vim`.

If you want to change the percent of warning, you can change it with the
`warning_level` const at the top of the file. 
