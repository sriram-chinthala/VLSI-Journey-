# PARAMETERIZED ALU — SPECIFICATION DOCUMENT

## 1. Overview

This document describes the architecture, operation, and implementation details of a parameterized Arithmetic Logic Unit (ALU) designed in synthesizable Verilog. The ALU supports arithmetic, logical, and shift operations and allows the data width to be configured using a parameter (DATA_WIDTH). The design is modular, easily extensible, and verification-friendly.

The ALU integrates three independent sub-modules:

- `arithmetic_unit.v`
- `logic_unit.v`
- `shifter_unit.v`

It selects the required module based on a 5-bit opcode and outputs the computed result, carry/borrow flags, and multiplier outputs where applicable.

---

## 2. Features

- Parameterized data width (DATA_WIDTH)
- Clean modular hierarchy
- Support for:
  - **Arithmetic**: ADD, SUB, INC, DEC, MUL
  - **Logic**: AND, OR, XOR, NOT, NAND, NOR, XNOR
  - **Shift**: SLL, SRL, SRA
- Extensible opcode map (upper bits reserve future functions)
- Fully synthesizable Verilog RTL
- Independent testbenches for:
  - ALU top module
  - Arithmetic unit
  - Logic unit
  - Shifter unit
- Compatible with Icarus Verilog, ModelSim, Vivado, and Quartus

---

## 3. Top-Level Block Diagram

            +-----------------------+
            |     PARAMETERIZED     |
            |   A ---------->| ALU  |----------> RESULT
            | |
            |   B ---------->| +---------------+ |
            | | Arithmetic | |
            |   OPCODE ------>|-->| Unit | |
            | +---------------+ |
            | |
            | +---------------+ |
            | | Logic Unit | |
            | +---------------+ |
            | |
            | +---------------+ |
            | | Shifter Unit | |
            | +---------------+ |
            |+-----------------------+


---

## 4. Parameters

| Parameter  | Description            | Default |
|-----------|------------------------|---------|
| DATA_WIDTH | Width of operands A, B | 8 bits  |

---

## 5. I/O Specification

### Inputs

| Name   | Width      | Description                  |
|--------|-----------|-------------------------------|
| a      | DATA_WIDTH | Operand 1                     |
| b      | DATA_WIDTH | Operand 2 / shift amount      |
| op     | 5          | Opcode selecting ALU function |

### Outputs

| Name        | Width           | Description                |
|-------------|-----------------|----------------------------|
| result      | DATA_WIDTH      | ALU result                 |
| carry_out   | 1               | ADD/SUB carry/borrow       |
| mult_result | 2×DATA_WIDTH    | Full multiplication result |

---

## 6. Opcode Encoding Table

| Opcode [4:3] | Unit        | Opcode [2:0] | Operation |
|--------------|-------------|--------------|-----------|
| 00           | Arithmetic  | 000          | ADD       |
| 00           | Arithmetic  | 001          | SUB       |
| 00           | Arithmetic  | 010          | INC       |
| 00           | Arithmetic  | 011          | DEC       |
| 00           | Arithmetic  | 100          | MUL       |
| 01           | Logic       | 000          | AND       |
| 01           | Logic       | 001          | OR        |
| 01           | Logic       | 010          | XOR       |
| 01           | Logic       | 011          | NOT       |
| 01           | Logic       | 100          | NAND      |
| 01           | Logic       | 101          | NOR       |
| 01           | Logic       | 110          | XNOR      |
| 10           | Shifter     | 00           | SLL       |
| 10           | Shifter     | 01           | SRL       |
| 10           | Shifter     | 10           | SRA       |
| 11           | Reserved    | —            | Future Use |

---

## 7. Internal Module Behavior

### Arithmetic Unit

- Add, subtract, increment, decrement operations
- Multiplier supports full-precision multiplication
- Generates `carry_out` flag for addition/subtraction
- Handles overflow/underflow scenarios

### Logic Unit

- Bitwise operations on operands A and B
- NOT operation ignores operand B
- Supports all standard logic gates

### Shifter Unit

- **SLL** (Shift Logical Left): Logical left shift by shift_amount
- **SRL** (Shift Logical Right): Logical right shift by shift_amount
- **SRA** (Shift Arithmetic Right): Arithmetic right shift with sign extension

---

## 8. Verification

The verification environment includes:

### Testbenches

- `tb_alu.v` — Complete ALU module verification
- `tb_arithmetic_unit.v` — Arithmetic unit unit tests
- `tb_logic_unit.v` — Logic unit unit tests
- `tb_shifter_unit.v` — Shifter unit unit tests

### Verification Features

- Randomized test generation
- Directed corner-case tests:
  - Overflow/underflow scenarios
  - Negative number operations (for SUB/SRA)
  - Maximum/minimum boundary values
  - High shift amounts
- VCD (Value Change Dump) support for GTKWave waveform analysis
- Comprehensive test coverage across all operations

---

## 9. How to Run (Icarus Verilog)

### Prerequisites

- Icarus Verilog installed (`iverilog`)
- GTKWave installed (for waveform viewing)

### Simulation Steps

Compile all modules:

iverilog -o output/output_alu.vvp RTL/alu.v RTL/arithmetic_unit.v RTL/logic_unit.v RTL/shifter_unit.v testbench/tb_alu.v


Run simulation:

vvp output/output_alu.vvp


View waveforms (optional):

gtkwave sim_wave/tb_alu.vcd

### Running Individual Unit Tests

Arithmetic Unit:

iverilog -o output/output_arithmetic.vvp RTL/arithmetic_unit.v testbench/tb_arithmetic_unit.v
vvp output/output_arithmetic.vvp


Logic Unit:

iverilog -o output/output_logic.vvp RTL/logic_unit.v testbench/tb_logic_unit.v
vvp output/output_logic.vvp


Shifter Unit:

iverilog -o output/output_shifter_unit.vvp RTL/shifter_unit.v testbench/tb_shifter_unit.v
vvp output/output_shifter_unit.vvp


---

## 10. Design Considerations

### Timing

- All operations complete in a single cycle
- Combinational logic paths optimized for timing closure
- Suitable for both synchronous and asynchronous implementations

### Area

- Modular design allows unused units to be optimized away by synthesis tools
- Parameterizable to reduce area for smaller data widths
- Estimated gate count scales linearly with DATA_WIDTH

### Power

- No clock gating in current design
- Can be extended with gating for unused modules in future

---

## 11. Future Improvements

- Add rotate operations (ROL, ROR)
- Add division unit with quotient and remainder
- Add status flags: zero flag, negative flag, overflow flag
- Integrate into small CPU datapath
- Add SystemVerilog assertions for formal verification
- Extend to support variable-width operations
- Add pipeline stages for higher frequency operation

---

## 12. References

- IEEE Std 1364-2005 (Verilog Hardware Description Language)
- Icarus Verilog Documentation
- GTKWave User Guide

---

**Document Version**: 1.0
**Last Updated**: November 27, 2025
**Status**: Active
