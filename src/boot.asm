[BITS 16] ;Set the code to be 16-bit mode
[ORG 0x7c00] ;Set the starting address to 0x7c00 (typical for boot loaders)

CODE_OFFSET equ 0x8
DATA_OFFSET equ 0x10

start:
  cli             ; Clear interrupts, disabling all maskable interrupts
  mov ax, 0x00    ; Load immediate value of 0x00 into the AX register
  mov ds, ax      ; Set data segment (DS) to 0x00
  mov es, ax      ; Set extra segment (ES) to 0x00
  mov ss, ax      ; Set stack segement (SS) to 0x00
  mov sp, 0x7c00  ; Set the stack pointer to starting address (top of boot loader segment)
  sti             ; Renable interupts


load_PM:
  cli
  lgdt [gdt_descriptor]     ; Load the Global Descriptor Table (GDT) using its descriptor
  mov eax, cr0              ; Move the contents of control register CR0 into EAX
  or al, 1                  ; Set the lowest bit of EAX to 1 to enable protected mode
  mov cr0, eax              ; Move the modified value back into CR0, enabling protected mode
  jmp CODE_OFFSET:PModeMain ; Far jump to switch to the new code segment defined in the GDT


gdt_start:
  ; define 8 null bytes (dd = define double: 4bytes)
  dd 0x00
  dd 0x00

; Code segment descriptor
  dw 0xFFFF ; Limit  DW = define word (2 bytes)
  dw 0x0000 ; Base
  db 0x00
  db 0b10011010 ; Access Byte
  db 0b11001111 ; Flags
  db 0x00       ; Base

; Data segment descriptor
  dw 0xFFFF ; Limit  DW = define word (2 bytes)
  dw 0x0000 ; Base
  db 0x00
  db 0b10010010 ; Access Byte
  db 0b11001111 ; Flags
  db 0x00       ; Base

gdt_end:

gdt_descriptor:
  dw gdt_end - gdt_start - 1  ; size of GDT - 1 (size field for LGDT)
  dd gdt_start                ; Address of the start of the GDT

[BITS 32]  ; Switch to 32-bit mode (protected mode)
PModeMain:
  mov ax, DATA_OFFSET ; Load the data segment offset (0x10) into AX
  mov ds, ax          ; Set DS (data segment) to the new data segment selector
  mov es, ax          ; Set ES (extra segment) to the new data segment selector
  mov fs, ax          ; Set FS (additional segment) to the new data segment selector
  mov ss, ax          ; Set SS (stack segment) to the new data segment selector
  mov gs, ax          ; Set GS (additional segment) to the new data segment selector
  mov ebp, 0x9C00     ; Set base pointer (EBP) to 0x9C00
  mov esp, ebp        ; Set stack pointer (ESP) to the same as EBP, initializing the stack

  in al, 0x92         ; Read the value from I/O port 0x92 (system control port)
  or al, 2            ; Set bit 1 of AL to enable A20 line (necessary for access to memory above 1 MB)
  out 0x92, al        ; Write the modified value back to I/O port 0x92

  jmp $               ; Infinite loop to halt execution (keeps the CPU in this state)



times 510 - ($ - $$) db 0   ; Fill the remaining address space of the boot sector with zeros up to 510 bytes

dw 0xAA55                   ; Boot sector signature, required to make the disk bootable

