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

output/build/linux-custom/arch/arm/boot/dts/stm32mp157c.dtsi


		cryp1: cryp@54001000 {
			compatible = "st,stm32mp1-cryp";
			reg = <0x54001000 0x400>;
			interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
			clocks = <&rcc CRYP1>;
			resets = <&rcc CRYP1_R>;
			status = "disabled";
		};

		hash1: hash@54002000 {
			compatible = "st,stm32f756-hash";
			reg = <0x54002000 0x400>;
			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
			clocks = <&rcc HASH1>;
			resets = <&rcc HASH1_R>;
			dmas = <&mdma1 31 0x10 0x1000A02 0x0 0x0 0x0 0x0>;
			dma-names = "in";
			dma-maxburst = <2>;
			status = "disabled";
		};

		rng1: rng@54003000 {
			compatible = "st,stm32-rng";
			reg = <0x54003000 0x400>;
			clocks = <&rcc RNG1_K>;
			resets = <&rcc RNG1_R>;
			status = "disabled";
		};



output/build/linux-custom/arch/arm/boot/dts/stm32mp157c-dk2.dts


/* M.Schenk enable CRYPT subsystems */
&cryp1 {
	status = "okay";
};

&hash1 {
	status = "okay";
};

&rng1 {
	status = "okay";
};

&crc1 {
	status = "okay";
};


static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
			      const void *address, unsigned int length)
{
	struct {
		struct shash_desc shash;
		char ctx[4];
	} desc;

	BUG_ON(crypto_shash_descsize(sbi->s_chksum_driver)!=sizeof(desc.ctx));

	desc.shash.tfm = sbi->s_chksum_driver;
	desc.shash.flags = 0;
	*(u32 *)desc.ctx = crc;

	BUG_ON(crypto_shash_update(&desc.shash, address, length));

	return *(u32 *)desc.ctx;
}


[    3.199089] stm32_rtc 5c004000.rtc: setting system clock to 2000-01-01 00:00:08 UTC (946684808)
[    3.208128] ALSA device list:
[    3.210140]   No soundcards f[    3.217651] ------------[ cut here ]------------
[    3.220925] kernel BUG at fs/ext4/ext4.h:2030!
[    3.225349] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
[    3.231214] Modules linked in:
[    3.234223] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.19.49 #8
[    3.240285] Hardware name: STM32 (Device Tree Support)
[    3.245428] PC is at ext4_superblock_csum+0x78/0x84
[    3.253651] LR is at ext4_fill_super+0x3d8/0x35a0
[    3.260285] pc : [<c02a0abc>]    lr : [<c02a4e80>]    psr: 20000113
[    3.260443] hub 1-1:1.0: USB hub found
[    3.271784] sp : d3051b90  ip : d36a16c0  fp : c0a04d50
[    3.271790] r10: c0a04c08  r9 : c0837260  r8 : c0a04cfc
[    3.271796] r7 : d36ba400  r6 : d36ba400  r5 : c0a04c08  r4 : 1163916b
[    3.271802] r3 : d36a1600  r2 : 00000008  r1 : d2120400  r0 : 1cb3fb4a
[    3.271811] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[    3.271817] Control: 10c5387d  Table: c000406a  DAC: 00000051
[    3.271829] Process swapper/0 (pid: 1, stack limit = 0x05936324)
[    3.271837] Stack: (0xd3051b90 to 0xd3052000)
[    3.271848] 1b80:                                     00000000 1cb3fb4a 00000000 ffffe000
[    3.271861] 1ba0: 00000002 d3051c18 c0a0352c c06d1c6c c0837260 c0a04c08 d3051bcc c06d12a8
[    3.271883] 1bc0: 00000000 00000002 c0a23b00 c032c5f0 c0a23b00 c02db2d4 c0a23b00 c02db560
[    3.277765] hub 1-1:1.0: 4 ports detected
[    3.284620] 1be0: 00000001 0000000e 0000200f 0000000e c07e6dd8 0000200f c0837260 c0a04c08
[    3.284634] 1c00: 00000089 c01df87c 00000040 c0711430 00000000 c0a23b00 c07e6dd8 c0837260
[    3.284648] 1c20: c0a23b00 c02db400 c0711430 d3050000 00000000 00000000 c07e6dd8 c02dbc10
[    3.284661] 1c40: 00000000 d36ba000 d36ba400 1cb3fb4a c0a04cfc 1163916b d36ba000 c02a4e80
[    3.456569] 1c60: 00000400 00000000 d2834440 d3051cc4 00000001 c0a04c08 00000001 1cb3fb4a
[    3.470334] 1c80: 00000000 1cb3fb4a 00000000 d28350c0 00000001 d3051d40 00000001 00000000
[    3.484094] 1ca0: 00000000 d3397e00 d3397d80 c01f5038 d3051d28 00000002 d2120400 d3051dec
[    3.497840] 1cc0: 00000041 c01f4360 00000000 00000000 d3051d28 d3051dec 00000004 00000000
[    3.511677] 1ce0: 00000004 00000000 ffffffff 00000000 00000000 ffffffff 00000000 00000000
[    3.525608] 1d00: 00000005 00000064 00000000 00004003 00001532 00000034 00001533 00000008
[    3.539561] 1d20: 00000040 00000003 d36ba278 1cb3fb4a d284fc00 d36ba260 d36b8400 d284fc00
[    3.553585] 1d40: 00000004 d36b840c d36ba278 d3051dcc c07670f0 c06cf594 ffffff05 ffff0a00
[    3.567619] 1d60: 006000c0 c0a04c08 d36ba258 d36ba278 c07df44a 00000002 d36ba278 c06cf7e4
[    3.581724] 1d80: 00000006 ffffff05 ffff0a00 d36ba210 00004a61 00000004 00000000 1cb3fb4a
[    3.595898] 1da0: d36ba258 c07df448 d3051e18 c06cfc74 ffffff05 ffff0a00 00000000 d36ba258
[    3.610143] 1dc0: 00000020 c0a04c08 3b9aca00 ffffff05 ffff0a00 1cb3fb4a c0a0fd54 c0a04c08
[    3.624510] 1de0: 00000081 00008001 d36ba000 1cb3fb4a 00000000 d284fc00 00000081 00008001
[    3.638931] 1e00: d36ba000 d284fc70 00000000 d3397e00 d3397d80 c01ed02c d284fc00 006000c0
[    3.653364] 1e20: 00000001 c02a05b4 d3397e00 c0a0fd54 c0a0fd54 00000000 00008001 c02a05cc
[    3.667805] 1e40: c02a4aa8 00000000 00008001 c01ed8bc d3397d80 c0209698 d344c400 d3397e00
[    3.682252] 1e60: 00008001 c020a444 c0a0fd54 c0a04c08 00000060 00000000 00000000 c020c9a8
[    3.696710] 1e80: 00000000 ffffff00 00000001 c07d0a68 d3397e00 d3006110 d281a7f8 d3397e00
[    3.711262] 1ea0: 0000000a 00000000 0000000a 1cb3fb4a 0000000a d3397d80 d3397e00 c07d0a6c
[    3.725841] 1ec0: 00008001 00000000 00008001 c07d0a6c c07d0a68 c020d854 00000000 d3e7b2e0
[    3.740417] 1ee0: d2117000 d3e7b2e0 d2117000 c092c85c c0a04c08 c0901168 00000000 00006000
[    3.755046] 1f00: 00006180 d21170b7 d2834440 c01fa514 601f8510 0b300004 d3660015 d3006110
[    3.769680] 1f20: d281a5d8 1cb3fb4a 00000008 1cb3fb4a c0a35730 c092c85c c0a35730 c09004a8
[    3.784313] 1f40: c092c858 c092c838 c0a35700 000000b7 00000008 c0901694 c092c858 c092c838
[    3.798947] 1f60: 00000008 c0a35700 c09004a8 c0900eb0 00000007 00000007 00000000 c09004a8
[    3.813580] 1f80: 00000000 00000000 c06d0570 00000000 00000000 00000000 00000000 00000000
[    3.828200] 1fa0: 00000000 c06d0578 00000000 c01010e8 00000000 00000000 00000000 00000000
[    3.842803] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    3.857387] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[    3.871973] [<c02a0abc>] (ext4_superblock_csum) from [<c02a4e80>] (ext4_fill_super+0x3d8/0x35a0)
[    3.887191] [<c02a4e80>] (ext4_fill_super) from [<c01ed02c>] (mount_bdev+0x15c/0x188)
[    3.901446] [<c01ed02c>] (mount_bdev) from [<c02a05cc>] (ext4_mount+0x18/0x20)
[    3.915087] [<c02a05cc>] (ext4_mount) from [<c01ed8bc>] (mount_fs+0x14/0xa8)
[    3.928556] [<c01ed8bc>] (mount_fs) from [<c020a444>] (vfs_kern_mount.part.4+0x48/0xec)
[    3.943000] [<c020a444>] (vfs_kern_mount.part.4) from [<c020c9a8>] (do_mount+0x188/0xc80)
[    3.957620] [<c020c9a8>] (do_mount) from [<c020d854>] (ksys_mount+0xac/0xc4)
[    3.971092] [<c020d854>] (ksys_mount) from [<c0901168>] (mount_block_root+0x118/0x2fc)
[    3.985454] [<c0901168>] (mount_block_root) from [<c0901694>] (prepare_namespace+0x17c/0x1c4)
[    4.000442] [<c0901694>] (prepare_namespace) from [<c0900eb0>] (kernel_init_freeable+0x1c4/0x1d4)
[    4.015795] [<c0900eb0>] (kernel_init_freeable) from [<c06d0578>] (kernel_init+0x8/0x110)
[    4.030443] [<c06d0578>] (kernel_init) from [<c01010e8>] (ret_from_fork+0x14/0x2c)
[    4.044458] Exception stack(0xd3051fb0 to 0xd3051ff8)
[    4.052020] 1fa0:                                     00000000 00000000 00000000 00000000
[    4.066603] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    4.081133] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    4.094053] Code: e1520003 1a000003 e28dd0c4 e8bd8030 (e7f001f2) 
[    4.106439] ---[ end trace 8affb6f119c27276 ]---
[    4.113915] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    4.113915] 
[    4.133161] CPU0: stopping
[    4.138175] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D           4.19.49 #8
[    4.151601] Hardware name: STM32 (Device Tree Support)
[    4.159059] [<c010edf4>] (unwind_backtrace) from [<c010b454>] (show_stack+0x10/0x14)
[    4.172819] [<c010b454>] (show_stack) from [<c06bcf28>] (dump_stack+0xb4/0xc8)
[    4.186072] [<c06bcf28>] (dump_stack) from [<c010dd60>] (handle_IPI+0x1d8/0x200)
[    4.199533] [<c010dd60>] (handle_IPI) from [<c033ec34>] (gic_handle_irq+0x8c/0x90)
[    4.213202] [<c033ec34>] (gic_handle_irq) from [<c0101a0c>] (__irq_svc+0x6c/0xa8)
[    4.226781] Exception stack(0xc0a01f28 to 0xc0a01f70)
[    4.234170] 1f20:                   00000000 00002a40 d3be740c c0114cc0 ffffe000 c0a04c28
[    4.248422] 1f40: c0a04c64 00000001 c0a2fa1f c07d6630 c092ca38 c0a04c08 c0a04c34 c0a01f78
[    4.262662] 1f60: c0108a94 c0108a98 60000013 ffffffff
[    4.270032] [<c0101a0c>] (__irq_svc) from [<c0108a98>] (arch_cpu_idle+0x38/0x3c)
[    4.283452] [<c0108a98>] (arch_cpu_idle) from [<c0140e28>] (do_idle+0x118/0x158)
[    4.296871] [<c0140e28>] (do_idle) from [<c0141128>] (cpu_startup_entry+0x18/0x20)
[    4.310466] [<c0141128>] (cpu_startup_entry) from [<c0900cc4>] (start_kernel+0x3ec/0x414)
[    4.324678] [<c0900cc4>] (start_kernel) from [<00000000>] (  (null))
[    4.337031] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    4.337031]  ]---
[   14.628856] ------------[ cut here ]------------
[   14.635750] WARNING: CPU: 1 PID: 10 at kernel/irq_work.c:102 irq_work_queue_on+0x158/0x15c
[   14.649916] Modules linked in:
[   14.655142] CPU: 1 PID: 10 Comm: rcu_preempt Tainted: G      D           4.19.49 #8
[   14.668647] Hardware name: STM32 (Device Tree Support)
[   14.676027] [<c010edf4>] (unwind_backtrace) from [<c010b454>] (show_stack+0x10/0x14)
[   14.689660] [<c010b454>] (show_stack) from [<c06bcf28>] (dump_stack+0xb4/0xc8)
[   14.702768] [<c06bcf28>] (dump_stack) from [<c0119364>] (__warn+0xd4/0xf0)
[   14.715530] [<c0119364>] (__warn) from [<c01193c0>] (warn_slowpath_null+0x40/0x48)
[   14.729036] [<c01193c0>] (warn_slowpath_null) from [<c01933f8>] (irq_work_queue_on+0x158/0x15c)
[   14.743836] [<c01933f8>] (irq_work_queue_on) from [<c0169274>] (rcu_implicit_dynticks_qs+0x288/0x378)
[   14.759270] [<c0169274>] (rcu_implicit_dynticks_qs) from [<c0168614>] (force_qs_rnp+0x118/0x188)
[   14.774290] [<c0168614>] (force_qs_rnp) from [<c016bb9c>] (rcu_gp_kthread+0x828/0xa2c)
[   14.788437] [<c016bb9c>] (rcu_gp_kthread) from [<c0135aa8>] (kthread+0x12c/0x134)
[   14.802138] [<c0135aa8>] (kthread) from [<c01010e8>] (ret_from_fork+0x14/0x2c)
[   14.815565] Exception stack(0xd306dfb0 to 0xd306dff8)
[   14.823010] dfa0:                                     00000000 00000000 00000000 00000000
[   14.837354] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   14.851663] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[   14.864374] ---[ end trace 8affb6f119c27277 ]---
Lost contact with target

See https://lore.kernel.org/patchwork/patch/1056966/


diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 8386038..4a00d7c 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2181,6 +2181,13 @@  static int alg_test_crc32c(const struct alg_test_desc *desc,
 		shash->tfm = tfm;
 		shash->flags = 0;
 
+		err = crypto_shash_init(shash);
+		if (err) {
+			printk(KERN_ERR "alg: crc32c: init failed for "
+			       "%s: %d\n", driver, err);
+			break;
+		}
+
 		*ctx = 420553207;
 		err = crypto_shash_final(shash, (u8 *)&val);
 		if (err) {



U-BOOT
https://github.com/STMicroelectronics/u-boot

https://github.com/STMicroelectronics/u-boot.git


Linux
https://github.com/STMicroelectronics/linux

https://github.com/STMicroelectronics/linux.git


./linux/fs/ext4/super.c

	/* Load the checksum driver */
	sbi->s_chksum_driver = crypto_alloc_shash("crc32c", 0, 0);
	if (IS_ERR(sbi->s_chksum_driver)) {
		ext4_msg(sb, KERN_ERR, "Cannot load crc32c driver.");
		ret = PTR_ERR(sbi->s_chksum_driver);
		sbi->s_chksum_driver = NULL;
		goto failed_mount;
	}







