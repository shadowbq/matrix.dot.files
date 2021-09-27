# Sandbox

These are application constraining sandboxes that work at kernel namespace levels. These are not malware analysis sandboxes.

Included in `matrix.dot.files` is a Sandbox extension with example configuration files.

## Linux

* Firejail - Kernel level supported simple sandbox. Works extremely well.

Reference: https://github.com/netblue30/firejail

## BSD

The Super Capsicumizer 9000 - https://github.com/unrelentingtech/capsicumizer

* Capsicum - https://wiki.freebsd.org/Capsicum 

## MacOS

* sandbox-exec - MacOS supported kernel sandbox. Works but support is dwendling.  

Ref: https://www.karltarvas.com/2020/10/25/macos-app-sandboxing-via-sandbox-exec.html  
Ref: https://reverse.put.as/wp-content/uploads/2011/09/Apple-Sandbox-Guide-v1.0.pdf  

## Windows

* sandboxie-plus - Reboot of the Sandboxie project.  

Ref: https://github.com/sandboxie-plus/Sandboxie

## eBPF | Containers

eBPF - eBPF is a revolutionary technology with origins in the Linux kernel that can run sandboxed programs in an operating system kernel. It is used to safely and efficiently extend the capabilities of the kernel without requiring to change kernel source code or load kernel modules.

Ref: https://ebpf.io/  
Ref: https://docs.cilium.io/en/v1.10/intro/  
