# GRB128
GEOS 128 restart from REU image

By Bart van Leeuwen in 2021

This software is in the public domain.

Note, this does not try to load an REU image, it assumes the REU is preloaded, 
It will fail, and hopefully give some usefull message about that if there is no REU, the REU is
too small, or the GEOS rboot image is not found (REU not preloaded, or possibly wrong GEOS 
version)

This is an example program, it is based on the 128 rboot program included in GEOS 128.
It is intended to demonstrate how the GEOS ramboot feature can be used to 'resume' from a
preloaded REU.

How to 'build'

Make sure you have acme and GNU make installed, and type 'make'

How to use:

1. start GEOS as you normally would, make sure your REU is enabled
2. configure GEOS as desired, make sure 'ram boot' is enabled in the GEOS configuration
3. you probably also want to ensure you have a ramdisk enabled, and put some files in there
4. If you have a battery backed REU, you can now turn off your computer, and proceed to step 7
5. create a dump of REU memory (so... you need either an UII+ cartridge providing the REU,
   or run this on VICE or such)
6. turn off your computer
7. turn on computer, and if not using a battery backed REU, reload the REU dump you created in
   step 5.
8. ensure your desktop disk is in the proper drive
9. start the geosramboot program
