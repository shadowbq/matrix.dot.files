# Sandbox

These are application constraining sandboxes that work at kernel namespace levels. These are not malware analysis sandboxes.

## Linux

* Firejail - Kernel level supported simple sandbox. Works extremely well.

Reference: https://github.com/netblue30/firejail

## BSD

The Super Capsicumizer 9000 - https://github.com/unrelentingtech/capsicumizer

* Capsicum - https://wiki.freebsd.org/Capsicum 

## MacOS

* sandbox-exec - MacOS supported kernel sandbox. Works but support is dwendling. 

Ref: https://www.karltarvas.com/2020/10/25/macos-app-sandboxing-via-sandbox-exec.html

## Windows

* sandboxie-plus - Reboot of the Sandboxie project. 

Ref: https://github.com/sandboxie-plus/Sandboxie


## eBPF

eBPF - eBPF is a revolutionary technology with origins in the Linux kernel that can run sandboxed programs in an operating system kernel. It is used to safely and efficiently extend the capabilities of the kernel without requiring to change kernel source code or load kernel modules.

Ref: https://ebpf.io/  
Ref: https://docs.cilium.io/en/v1.10/intro/  
