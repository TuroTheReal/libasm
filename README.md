# LIBASM

## Table of Contents

- [About](#about)
- [Installation](#installation)
- [Usage](#usage)
- [Key Concepts Learned](#key-concepts-learned)
- [Skills Developed](#skills-developed)
- [Project Overview](#project-overview)
- [Architecture & Stack](#architecture--stack)
- [42 School Standards](#42-school-standards)
- [Contact](#contact)


## About

This repository contains my implementation of the **libasm** project at 42 School.
Libasm is a foundational project in the 42 curriculum designed to introduce students to the beautiful and powerful world of assembly language programming.
The project involves recreating essential C library functions in **x86-64 Intel Assembly**, providing deep insights into how high-level programming concepts translate to machine-level operations.
Through this hands-on approach, students gain fundamental understanding of computer architecture, system calls, memory management, and low-level programming paradigms.
This implementation demonstrates mastery of assembly language syntax, register manipulation, stack operations, system call interfaces, and error handling at the lowest level of software abstraction.
The project serves as a crucial stepping stone toward understanding how computers actually execute our code.

## Installation

### Prerequisites

- **NASM** (Netwide Assembler) 2.15+ for x86-64 assembly compilation
- **GCC** (GNU Compiler Collection) for linking and testing
- **Make** for build automation
- **Linux x86-64** environment (Ubuntu 20.04+ recommended)
- **libc6-dev** for standard C library headers

### Quick Setup

```bash
# Clone the repository
git clone https://github.com/TuroTheReal/libasm.git
cd libasm

# Build && compile the library
make

# Build && compile the library with bonus
make bonus

# Run comprehensive tests
make test

# Clean build artifacts
make clean

# Full cleanup including library
make fclean

# Rebuild everything
make re
```


## Usage

### Quick Start Guide

```bash
# 1. Build the static library
make

# 2. Test individual functions
./test_program
```


## Key Concepts Learned

### Low-Level Programming Fundamentals

**Register Management**: Mastered the art of efficiently utilizing x86-64 registers (RAX, RBX, RCX, RDX, RSI, RDI, RSP, RBP) for data manipulation, parameter passing, and return value handling.
Understanding register conventions is crucial for writing performant assembly code that integrates seamlessly with C calling conventions.

**Memory Addressing**: Developed deep understanding of different addressing modes including immediate, register, memory, and indexed addressing.
This knowledge enables precise control over how data flows between CPU registers and system memory, forming the foundation of efficient low-level programming.

**Stack Operations**: Gained comprehensive knowledge of stack frame management, including proper setup and teardown of function call frames, parameter passing mechanisms, and local variable allocation.
Understanding the stack is essential for debugging, optimization, and system-level programming.

### System Programming

**System Call Interface**: Learned direct interaction with the Linux kernel through system calls, bypassing the C library layer to understand how fundamental operations like read and write actually communicate with the operating system.
This knowledge is invaluable for system programming and understanding performance characteristics.

**Error Handling**: Implemented proper errno handling for system calls, understanding how error conditions propagate from kernel space to user space and how to maintain consistency with standard library behavior.
This ensures robust, production-ready code.

**ABI Compliance**: Mastered the System V AMD64 ABI (Application Binary Interface), ensuring that assembly functions can seamlessly interoperate with C code through proper calling conventions, register usage, and stack alignment requirements.

### Assembly Language Mastery

**Intel Syntax**: Became proficient in Intel assembly syntax, including instruction formatting, operand ordering, and mnemonic usage.
Intel syntax is widely used in industry and provides clear, readable assembly code that scales well to complex programs.

**Instruction Set Understanding**: Developed expertise with x86-64 instruction sets including data movement (MOV, PUSH, POP), arithmetic operations (ADD, SUB, MUL, DIV),
logical operations (AND, OR, XOR), and control flow instructions (JMP, JE, JNE, CALL, RET).

**Optimization Techniques**: Learned assembly-level optimization strategies including efficient loop structures, conditional jumps,
and register allocation patterns that minimize instruction count and maximize CPU pipeline efficiency.


## Skills Developed

**Computer Architecture Understanding**: Gained profound insight into how modern CPUs execute instructions, manage memory hierarchies, and handle concurrent operations.
This knowledge forms the foundation for writing efficient code in any programming language and understanding performance bottlenecks in complex systems.

**Debugging and Analysis Skills**: Developed expertise in using low-level debugging tools including GDB for assembly debugging, objdump for disassembly analysis, and strace for system call tracing.
These skills are invaluable for diagnosing complex software issues and understanding program behavior at the deepest level.

**Performance Optimization**: Learned to write highly efficient code by understanding CPU instruction costs, memory access patterns, and branch prediction mechanisms.
This knowledge enables writing performance-critical code and optimizing existing applications for maximum throughput.

**Systems Programming Foundation**: Built a solid foundation for systems programming, embedded development, and kernel programming by understanding how software interfaces with hardware.
This knowledge is essential for careers in systems programming, cybersecurity, and high-performance computing.

**Attention to Detail**: Developed meticulous attention to detail required for assembly programming, where single instruction mistakes can cause subtle bugs or system crashes.
This precision translates to higher code quality in all programming endeavors.

**Problem-Solving Methodology**: Enhanced analytical thinking skills by learning to break down complex problems into fundamental operations that can be expressed in assembly instructions.
This systematic approach improves programming ability across all languages and domains.

## Project Overview

The libasm project represents a deep dive into the fundamental layer of computer programming, where high-level abstractions give way to direct hardware manipulation.
By implementing core C library functions in assembly language, this project bridges the gap between theoretical computer science concepts and practical low-level programming skills.

### Vision and Goals

Create a fully compatible assembly implementation of essential C library functions while gaining deep understanding of computer architecture, system programming, and low-level optimization techniques.
The project aims to demonstrate that complex functionality can be built from fundamental building blocks when armed with solid understanding of underlying systems.

### Core Implementation Philosophy

**Efficiency First**: Every instruction is chosen deliberately to minimize CPU cycles and memory accesses while maintaining readability and maintainability.
The assembly implementations often outperform their C counterparts due to precise register usage and optimized instruction sequences.

**Standards Compliance**: All functions maintain perfect compatibility with their libc counterparts, including edge case handling, error conditions, and return value semantics.
This ensures seamless integration with existing C codebases.

**Educational Value**: The code serves as a learning resource, demonstrating best practices in assembly programming, system call usage,
and low-level debugging techniques that are applicable across many domains of software development.


## Architecture & Stack

### Development Environment

**Assembly Language**: x86-64 Intel syntax for maximum readability and industry compatibility
**Assembler**: NASM (Netwide Assembler) for reliable cross-platform assembly compilation
**Toolchain**: GNU toolchain (GCC, LD, objdump) for comprehensive development workflow
**Testing Framework**: Custom C-based testing harness with comprehensive edge case coverage

### Target Architecture

**CPU Architecture**: x86-64 (AMD64) with full 64-bit register set utilization
**Operating System**: Linux with System V AMD64 ABI compliance
**Calling Convention**: System V AMD64 for seamless C interoperability
**Memory Model**: 64-bit flat memory model with proper alignment handling

### Function Categories

**String Functions**: Length calculation, copying, and comparison with optimized loop structures
**I/O Functions**: Direct system call wrappers with proper error handling and errno management
**Memory Functions**: Dynamic allocation with proper heap management and error checking

### Quality Assurance

**Testing Strategy**: Comprehensive test suite covering normal operation, edge cases, and error conditions
**Compatibility Verification**: Side-by-side comparison with standard library implementations
**Performance Benchmarking**: Instruction count analysis and execution time measurements
**Memory Safety**: Careful bounds checking and proper memory access patterns


## 42 School Standards

### Project Standards

- ✅ **Assembly Implementation**: All functions written in x86-64 Intel syntax assembly
- ✅ **C Library Compatibility**: Perfect behavioral compatibility with standard libc functions
- ✅ **Error Handling**: Proper errno setting and error condition management
- ✅ **System Calls**: Direct kernel interface usage without libc dependencies
- ✅ **Build System**: Comprehensive Makefile with standard targets
- ✅ **Documentation**: Clear code comments and comprehensive testing

### Code Quality Standards

- ✅ **Norm Compliance**: Adherence to 42 School coding standards and best practices
- ✅ **Memory Safety**: No buffer overflows, memory leaks, or undefined behavior
- ✅ **Edge Case Handling**: Robust handling of null pointers, empty strings, and error conditions
- ✅ **Performance**: Optimized assembly code with efficient register usage and instruction selection
- ✅ **Maintainability**: Clean, well-commented assembly code with logical structure
- ✅ **Testing**: Comprehensive test coverage with automated verification

### Learning Objectives Met

- ✅ **Low-Level Understanding**: Deep comprehension of computer architecture and instruction execution
- ✅ **System Programming**: Direct system call usage and kernel interface understanding
- ✅ **Assembly Mastery**: Proficiency in x86-64 assembly language and Intel syntax
- ✅ **Debugging Skills**: Ability to debug assembly code and analyze program behavior
- ✅ **Performance Optimization**: Skills in writing efficient, optimized low-level code


## Contact

- **GitHub**: [@TuroTheReal](https://github.com/TuroTheReal)
- **Email**: arthurbernard.dev@gmail.com
- **LinkedIn**: [Arthur Bernard](https://www.linkedin.com/in/arthurbernard92/)
- **Portfolio**: https://arthur-portfolio.com

---

![Assembly Badge](https://img.shields.io/badge/Assembly-x86--64-blue)
![NASM Badge](https://img.shields.io/badge/NASM-2.15+-green)
![Linux Badge](https://img.shields.io/badge/Linux-x86--64-yellow)
![42 School Badge](https://img.shields.io/badge/42-School-black)
