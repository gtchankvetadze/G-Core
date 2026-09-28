;pseudo instruction, forces NASM to translate the code into 16 bit machine code.
bits 16

;another pseudo. Assume the first byte of this program will live at address 0x7C00. why 7c00? its a standard. This if the first byte of our 512b sector.
org 0x7c00

start:
    ;we cannot directly move the desired value inside es, so we use ax as
    ;a middleman.

    mov ax, 0xb800
    mov es, ax

    mov word [es:0],  0x0f62    ; b
    mov word [es:2],  0x0f6f    ; o, writes at B8002
    mov word [es:4],  0x0f6f    ; o, writes at B8004
    mov word [es:6],  0x0f74    ; t

    ;our program itself lives at 7c00. huge gap.
    ;<low addresses>...<0x00007C00>....<huge gap>...<0x000B8000>....<gap>


hang:
    cli
    hlt
    jmp hang

;find the remaining space length and fill it with zeroes until the byte 510.
;512b is the standard(since 1981) sector size for legacy devices.
times 510-($-$$) db 0
dw 0xaa55


;BIOS has loaded only one 512-byte sector for us.
;But we own the entire machine. We're the only software running, apart from ;firmware services we may still call and which we can overwrite anytime.
;control is global; initial storage is tiny
;but since we are in real mode, physically we cannot address beyond 1MB space.
;we can only access and modify area from 0x00000 to 0xFFFFF.

;real mode - the first 1MB.
;32bit protected mode - first 4GB.
;64bit long mode -the first 16 Exabytes.

;at this point, there is only us, BIOS data structures and interrupt vector
;tables in this universe. But we have no software lvl supervisor. We can ;absolutely overwrite any data structure, including ours.
;So there are no software boundaries, but there ARE hardware ones.
