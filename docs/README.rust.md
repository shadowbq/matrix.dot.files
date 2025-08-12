# Rust-lang


A very simple extension for working with Rust.

## What does it do?

Adds Cargo to your `PATH` so Rust commands work globally:

`PATH="$HOME/.cargo/bin:$PATH"`

## Setup


1.  **Install Rust** (via rustup):

    `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`

2.  **Add Cargo to your `PATH`** (if not already done):

    `PATH="$HOME/.cargo/bin:$PATH"`

## Commonly Needed Tools

-   **Rustup** -- Toolchain installer & manager (includes Cargo)

-   **Cargo** -- Build system & package manager

-   **C compiler & linker** -- Needed for crates with native code

    -   Linux: `sudo apt install build-essential`

    -   macOS: `xcode-select --install`

    -   Windows: Install Visual Studio Build Tools (C++ workload)

-   **Git** -- For fetching dependencies from repositories

-   *(Optional)* **rust-analyzer** -- IDE integration for autocompletion, type hints, and docs

## Quick Test


Verify your Rust installation:

```
rustc --version
cargo --version
```

Create and run a sample project:


```
cargo new hello-rust
cd hello-rust
cargo run
```

You should see:

`Hello, world!`
