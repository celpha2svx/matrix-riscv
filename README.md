# Matrix-RISCV: A RISC-V Core with Custom Matrix MAC Instruction

A single-cycle RV32I processor extended with a custom Multiply-Accumulate (MAC) instruction for efficient matrix operations under memory constraints.

## Motivation
Training ML models on 4GB RAM laptops causes excessive memory pressure. Standard RISC-V cores require multiple instructions (mul, add) for matrix multiply-accumulate, increasing memory traffic. This project adds a single-cycle MAC instruction to reduce instruction count and data movement.

## Custom Instruction
- **Instruction:** `mac rd, rs1, rs2`
- **Semantics:** `rd = rd + (rs1 * rs2)`
- **Opcode:** `0001011` (custom-0)
- **Format:** R-type

## Results
| Metric | Standard Core | This Core |
|--------|---------------|-----------|
| Instructions per MAC | 2 (mul + add) | 1 (mac) |
| Register writes per MAC | 2 | 1 |
| Cycle count per MAC | 2 | 1 |

## Files
- `MatrixALU.v` — Custom MAC hardware module
- `Mux.v` — Modified 3-input multiplexer
- `Main_Decoder.v` — Decoder extended for MAC opcode
- `Single_Cycle_Top.v` — Top-level processor with MAC datapath
- `Register_File.v` — Fixed initialization and timing

## Simulation
```bash
iverilog -o simv Single_Cycle_Top.v Single_Cycle_Top_Tb.v
./simv

---
Author

Ademuyiwa Afeez — Building efficient hardware for constrained ML training.

