<div align="center">

# ⚡ Matrix-RISCV

### A Custom MAC Instruction for Memory-Efficient Machine Learning

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Language: Verilog](https://img.shields.io/badge/Language-Verilog-blue.svg)](https://github.com/celpha2svx/matrix-riscv)
[![Architecture: RV32I](https://img.shields.io/badge/Architecture-RV32I-green.svg)](https://riscv.org/)
[![Simulation: Icarus Verilog](https://img.shields.io/badge/Sim-Icarus%20Verilog-orange.svg)](http://iverilog.icarus.com/)

*A single-cycle RV32I RISC-V processor extended with a custom Multiply-Accumulate instruction — built for ML workloads on memory-constrained hardware.*

</div>

---

## 🧠 The Problem

Training ML models requires **millions of matrix multiply-accumulate operations**. On a standard RISC-V core, every single MAC costs two instructions:

```asm
mul  t0, a0, a1    # Multiply   → 1 instruction, 1 cycle, 1 register write
add  a2, a2, t0    # Accumulate → 1 instruction, 1 cycle, 1 register write
```

That's **2 cycles, 2 register writes, 8 bytes of instruction memory** per MAC. On a 4GB RAM machine, your instruction stream competes directly with your training data for memory bandwidth. At 1 million MACs, you're burning **8MB just on instruction fetches** — before a single weight is touched.

---

## ✅ The Solution

```asm
mac  a2, a0, a1    # a2 = a2 + (a0 * a1) — ONE instruction, ONE cycle
```

A single custom instruction that does the full multiply-accumulate in **one cycle**. Half the instructions. Half the memory traffic. Same result.

---

## 📐 Instruction Encoding

```
 31      25  24   20  19  15  14  12  11   7  6      0
┌──────────┬───────┬───────┬───────┬───────┬─────────┐
│  funct7  │  rs2  │  rs1  │funct3 │  rd   │ opcode  │
│ 0000001  │  rs2  │  rs1  │  000  │  rd   │ 0001011 │
└──────────┴───────┴───────┴───────┴───────┴─────────┘
                                          custom-0
```

`mac rd, rs1, rs2` → R-type, opcode `0001011` (RISC-V custom-0 space)

---

## ⚙️ Hardware Changes

| Module | Modification |
|---|---|
| `MatrixALU.v` | New 32-bit signed Multiply-Accumulate unit |
| `Register_File.v` | Third read port (A4/RD4) to read `rd` for accumulation |
| `Mux.v` | Extended 2→3 input (ALU / Memory / MAC) with 2-bit select |
| `Main_Decoder.v` | Detects custom-0 opcode and asserts `MAC_Enable` |
| `Control_Unit_Top.v` | Routes `MAC_Enable` through the control path |
| `Single_Cycle_Top.v` | Integrates `MatrixALU` into the writeback stage |

---

## 📊 Results

### Simulation Output — 4 Consecutive MACs

```
Cycle 1: MAC_Enable=1, ResultSrc=10, MACResult=000002d6  →  726
Cycle 2: MAC_Enable=1, ResultSrc=10, MACResult=00001f32  →  7,986
Cycle 3: MAC_Enable=1, ResultSrc=10, MACResult=00015726  →  87,846
Cycle 4: MAC_Enable=1, ResultSrc=10, MACResult=000ebea2  →  966,306
```

4 MACs. 4 instructions. 4 cycles. Verified.

### Performance vs Standard RV32I

| Metric | Standard (`mul` + `add`) | Matrix-RISCV (`mac`) | Reduction |
|---|---|---|---|
| Instructions per MAC | 2 | 1 | **50%** |
| Cycles per MAC | 2 | 1 | **50%** |
| Register writes per MAC | 2 | 1 | **50%** |
| Code size per MAC | 8 bytes | 4 bytes | **50%** |
| Instruction memory traffic / 1M MACs | 8 MB | 4 MB | **50%** |

> At 1 million MACs — a modest ML kernel — Matrix-RISCV frees **4MB of memory bandwidth** back to your training data. Every instruction not fetched is bandwidth returned to your model.

---

## 🚀 Quick Start

**Prerequisites**
- [Icarus Verilog](http://iverilog.icarus.com/) (`iverilog`)

**Clone & Simulate**

```bash
git clone https://github.com/celpha2svx/matrix-riscv.git
cd matrix-riscv
iverilog -o simv Single_Cycle_Top.v Single_Cycle_Top_Tb.v
./simv
```

**Expected Output**

```
Cycle 1: MAC_Enable=1, ResultSrc=10, MACResult=000002d6
Cycle 2: MAC_Enable=1, ResultSrc=10, MACResult=00001f32
Cycle 3: MAC_Enable=1, ResultSrc=10, MACResult=00015726
Cycle 4: MAC_Enable=1, ResultSrc=10, MACResult=000ebea2
```

---

## 📁 File Reference

| File | Description |
|---|---|
| `MatrixALU.v` | Custom 32-bit signed MAC hardware unit |
| `Register_File.v` | Extended register file with third read port |
| `Mux.v` | 3-input multiplexer for writeback `ResultSrc` |
| `Main_Decoder.v` | Control decoder with custom-0 opcode support |
| `Control_Unit_Top.v` | Top-level control unit routing `MAC_Enable` |
| `Single_Cycle_Top.v` | Full processor with MAC datapath integrated |
| `Single_Cycle_Top_Tb.v` | Testbench with benchmark counters |
| `mac_bench.hex` | Test program: 4 MACs + store |

---

## 🗺️ Roadmap

- [ ] FPGA synthesis (Tang Nano / ICE40 target)
- [ ] Vector MAC for SIMD-style parallelism
- [ ] Integration with TinyML inference
- [ ] Memory bandwidth measurement on physical hardware
- [ ] Paper submission — RISC-V Summit / CARRV workshop

---

## 👤 Author

**Ademuyiwa Afeez** — Building efficient hardware for resource-constrained machine learning.

> *"We don't need bigger machines. We need smarter architectures."*

---

## 📄 License

[MIT](LICENSE) — Build on it. Improve it. Share it.
