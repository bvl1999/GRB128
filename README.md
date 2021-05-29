# GRB128
GEOS 128 restart from REU image

Note, this does not try to load an REU image, it assumes the REU is preloaded, 
and does not check in any way if this is actually the case (or if an REU is pressent at all)

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
