# Baby's (first) Boot Loader

## Development

### Tools Used

- nasm
- qemu-system-x86
- make

### Compile and Run

```sh
make && qemu-system-x86_64 -hda ./bin/boot.bin
```

## Reference Material

The osdev.org wiki is a wonderful collection of documentation for
operating system hobby development.

- [BIOS](<https://wiki.osdev.org/BIOS>)
- [Boot Sequence](<https://wiki.osdev.org/Boot_Sequence>)
- [Real Mode](https://wiki.osdev.org/Real_Mode)

---

**Disclaimer:** This is an educational project and should absolutely NOT, under
any circumstances, be taken seriously.
