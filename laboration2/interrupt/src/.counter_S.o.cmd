cmd_/home/pi/interrupt/src/counter_S.o := gcc -Wp,-MD,/home/pi/interrupt/src/.counter_S.o.d  -nostdinc -isystem /usr/lib/gcc/arm-linux-gnueabihf/4.9/include -I./arch/arm/include -Iarch/arm/include/generated/uapi -Iarch/arm/include/generated  -Iinclude -I./arch/arm/include/uapi -Iarch/arm/include/generated/uapi -I./include/uapi -Iinclude/generated/uapi -include ./include/linux/kconfig.h -D__KERNEL__ -mlittle-endian -Iarch/arm/mach-bcm2709/include   -D__ASSEMBLY__ -mabi=aapcs-linux -mno-thumb-interwork -mfpu=vfp -funwind-tables -marm -D__LINUX_ARM_ARCH__=7 -march=armv7-a  -include asm/unified.h -msoft-float  -DCC_HAVE_ASM_GOTO          -DMODULE  -c -o /home/pi/interrupt/src/counter_S.o /home/pi/interrupt/src/counter_S.S

source_/home/pi/interrupt/src/counter_S.o := /home/pi/interrupt/src/counter_S.S

deps_/home/pi/interrupt/src/counter_S.o := \
  arch/arm/include/asm/unified.h \
    $(wildcard include/config/arm/asm/unified.h) \
    $(wildcard include/config/cpu/v7m.h) \
    $(wildcard include/config/thumb2/kernel.h) \

/home/pi/interrupt/src/counter_S.o: $(deps_/home/pi/interrupt/src/counter_S.o)

$(deps_/home/pi/interrupt/src/counter_S.o):
