make stm32mp157_dk_defconfig

make 2>&1 | tee build.log



sudo dd if=output/images/sdcard.img of=/dev/sde bs=1M conv=fdatasync status=progress

sudo gdbterm -b 115k -s /dev/ttyACM0

Mass storage gadget example
---------------------------

dd if=/dev/zero of=/mass.img bs=4k count=2k
mkdosfs /mass.img

mount -t configfs none /sys/kernel/config
cd /sys/kernel/config/usb_gadget/

mkdir g1
cd g1

echo 0x0480 > idVendor
echo 0x1990 > idProduct


mkdir strings/0x409
echo "1234321" > strings/0x409/serialnumber
echo "Noser" > strings/0x409/manufacturer
echo "Noser Test" > strings/0x409/product

# Create configuration
mkdir configs/c.1

mkdir functions/mass_storage.1
echo /mass.img > functions/mass_storage.1/lun.0/file
echo 1 > functions/mass_storage.1/lun.0/removable
ln -s functions/mass_storage.1 configs/c.1

ls /sys/class/udc > UDC


