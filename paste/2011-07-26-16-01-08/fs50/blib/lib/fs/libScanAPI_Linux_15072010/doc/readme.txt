Introduction:

ftrScanAPI is the API library for application to work with Futronic's FS80 USB fingerprint Scanner.
libScanAPI.so is the Linux version library.
We don't have a kernel mode driver for FS80 scanner, libScanAPI.so works with a well-known multiplatform library libusb, libusb is a library which allows userspace application access to USB devices. Last version of libusb is 0.1.12. This last version is recommended to install and work together with libftrScanAPI.so. The official site of this library - http://libusb.sourceforge.net.


Files:

1. libScanAPI.so	- The Linux version library, it must be copied to the working directory.
2. libusb-0.1.so.4	- The libusb library, it is built from libusb-0.1.12, it must be copied to the directory of /usr/local/lib.
3. libusb.so		- The libusb library, it must be copied to the working directory /usr/local/lib.
	for 2 and 3, you should download the libusb-0.1.12 and then build to your OS. If you do so or the OS has installed it, these 2 files need NOT to copy.

4. ftrScanAPI.h		- header file for libftrScanAPI.so, it must be copied to working directory.
5. ftrScanAPI_Ex.c	- Example source code, it must be copied to working directory.
6. ftrScanAPI_Ex.mak	- make file for the example, it must be copied to working directory. To build it, #make -f ftrScanAPI_Ex.mak
7. ftrScanAPI_Ex	- The executable example. To run it, #./ftrScanAPI_Ex
8. gtk_ex.c		- Graphics interface for GNOME/GTK2+ example source cdoe, it must be copied to working directory.
9. gtk_ex.mak		- make file for this example, it must be copied to working directory. To build it, #make -f gtk_ex.mak
10.gtk_ex		- The executable example. To run it, #./gtk_ex
