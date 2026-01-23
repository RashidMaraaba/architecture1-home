# 💻 Low-Level MIPS Data Processor & Sorter

An assembly language program optimizing data manipulation directly at the hardware register level.

## ⚡ Architectural Implementation
### 💾 Memory Alignment & Management
The program manually manages the `.data` segment, utilizing `.align 2` directives to ensure integer arrays (A, B, C) are stored at word-aligned memory addresses. This prevents bus errors and optimizes fetch cycles for the processor.

### 🔢 Algorithmic Logic (Selection Sort)
A hand-written **Descending Selection Sort** is implemented without high-level abstractions.
* **Pointer Arithmetic:** The algorithm traverses arrays by manipulating memory pointers (incrementing addresses by 4 bytes).
* **Branching:** Conditional jumps (`bgt`, `bltz`) replace high-level `if/else` logic to control flow efficiently.

### 🧮 Register Optimization
To minimize slow RAM access, the program aggressively utilizes MIPS temporary (`$t0-$t9`) and saved (`$s0-$s7`) registers for intermediate calculations (Average, Max/Min), demonstrating efficient pipeline usage.
