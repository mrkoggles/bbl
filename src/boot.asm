[BITS 16] ;Set the code to be 16-bit mode
[ORG 0x7c00] ;Set the starting address to 0x7c00 (typical for boot loaders)

start:
  cli             ; Clear interrupts, disabling all maskable interrupts
  mov ax, 0x00    ; Load immediate value of 0x00 into the AX register
  mov ds, ax      ; Set data segment (DS) to 0x00
  mov es, ax      ; Set extra segment (ES) to 0x00
  mov ss, ax      ; Set stack segement (SS) to 0x00
  mov sp, 0x7c00  ; Set the stack pointer to starting address (top of boot loader segment)
  mov si, msg     ; Load the address of the message into the source index (SI) Register
  sti             ; Renable interupts

print:
  lodsb           ; Load byte at DS:SI into the AL register and increment SI
  cmp al, 0       ; Compare (cmp) value of the AL register with 0 (null terminator)
  je done         ; Jump to done: label IF cmp was true (AL==0)
  mov ah, 0x0E    ; Else: set AH to 0x0E (BIOS teletype output function)
  int 0x10        ; Call BIOS interrupt 0x10 for teletype output
  jmp print       ; recursively jump up to iterrate over 'Hello World' String

done:
  cli             ; Clear interrupts, disabling all maskable interrupts
  hlt             ; Halt the CPU

msg: db 'Hello World!', 0   ; define 'Hello World!' and finalize with the null terminator

times 510 - ($ - $$) db 0   ; Fill the remaining address space of the boot sector with zeros up to 510 bytes

dw 0xAA55                   ; Boot sector signature, required to make the disk bootable

