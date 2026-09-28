void kernel_main(void) {
  volatile unsigned short *vga = (volatile unsigned short *)0xB8000;

  vga[0] = 0x0F43; /* C */
  vga[1] = 0x0F21; /* ! */

  for (;;)
    ;
}
