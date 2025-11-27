# Parameterized ALU (Verilog)

A modular, parameterized Arithmetic Logic Unit supporting arithmetic, logic, and shifting operations. Designed for FPGA/ASIC-style RTL and verified using Icarus Verilog.

## 🚀 Features

- ✅ Parameterized DATA_WIDTH
- ✅ Arithmetic operations (ADD, SUB, INC, DEC, MUL)
- ✅ Logic operations (AND, OR, XOR, NOT, NAND, NOR, XNOR)
- ✅ Shift operations (SLL, SRL, SRA)
- ✅ Clean, modular RTL hierarchy
- ✅ Independent testbenches for each module
- ✅ Verified using Icarus + GTKWave

## 📂 Project Structure

project_4_parametarized_ALU/
│
├── RTL/
│ ├── alu.v
│ ├── arithmetic_unit.v
│ ├── logic_unit.v
│ └── shifter_unit.v
│
├── testbench/
│ ├── tb_alu.v
│ ├── tb_arithmetic_unit.v
│ ├── tb_logic_unit.v
│ └── tb_shifter_unit.v
│
├── docs/
│ └── specification.md
│
├── output/
│ ├── output_alu.vvp
│ ├── output_arithmetic.vvp
│ ├── output_logic.vvp
│ └── output_shifter_unit.vvp
│
└── sim_wave/
├── tb_alu.vcd
└── tb_alu_8.vcd

## 🧩 Opcode Encoding

| Unit        | Opcode [4:3] | Sub-Opcode [2:0] | Operation |
|-------------|--------------|------------------|-----------|
| Arithmetic  | 00           | 000              | ADD       |
|             | 00           | 001              | SUB       |
|             | 00           | 010              | INC       |
|             | 00           | 011              | DEC       |
|             | 00           | 100              | MUL       |
| Logic       | 01           | 000              | AND       |
|             | 01           | 001              | OR        |
|             | 01           | 010              | XOR       |
|             | 01           | 011              | NOT       |
|             | 01           | 100              | NAND      |
|             | 01           | 101              | NOR       |
|             | 01           | 110              | XNOR      |
| Shifter     | 10           | 00               | SLL       |
|             | 10           | 01               | SRL       |
|             | 10           | 10               | SRA       |
| Reserved    | 11           | —                | Future use |

## ▶️ How to Run Simulation (Icarus Verilog)

Open the terminal in the project folder and run the following commands:

### Compile

iverilog -o output/output_alu.vvp RTL/alu.v RTL/arithmetic_unit.v RTL/logic_unit.v RTL/shifter_unit.v testbench/tb_alu.v


### Run Simulation

vvp output/output_alu.vvp


### View Waveforms

gtkwave sim_wave/tb_alu.vcd


### All-in-One Command

iverilog -o output/output_alu.vvp RTL/alu.v RTL/arithmetic_unit.v RTL/logic_unit.v RTL/shifter_unit.v testbench/tb_alu.v && vvp output/output_alu.vvp && gtkwave sim_wave/tb_alu.vcd


## 🧪 Testbenches Included

- ✔️ `tb_alu.v` — Complete ALU verification with all operations
- ✔️ `tb_arithmetic_unit.v` — Arithmetic unit unit tests
- ✔️ `tb_logic_unit.v` — Logic unit unit tests
- ✔️ `tb_shifter_unit.v` — Shifter unit unit tests
- ✔️ VCD dumping enabled for waveform analysis

## 📋 Module Description

### ALU Top Module (alu.v)

Main module that instantiates all three sub-units and routes operations based on opcode:

- **Parameters**: DATA_WIDTH, SHIFT_BITS
- **Inputs**: a, b, opcode, shift_amount
- **Outputs**: result, carry_out, mult_result

### Arithmetic Unit (arithmetic_unit.v)

Handles arithmetic operations with full precision:

- ADD: Addition with carry detection
- SUB: Subtraction with borrow detection
- INC: Increment
- DEC: Decrement
- MUL: Full-precision multiplication (result width = 2 × DATA_WIDTH)

### Logic Unit (logic_unit.v)

Implements bitwise logical operations:

- AND: Bitwise AND
- OR: Bitwise OR
- XOR: Bitwise XOR
- NOT: Bitwise NOT (ignores second operand)
- NAND: Bitwise NAND
- NOR: Bitwise NOR
- XNOR: Bitwise XNOR

### Shifter Unit (shifter_unit.v)

Performs shift operations on data:

- SLL: Shift Logical Left (fill with 0)
- SRL: Shift Logical Right (fill with 0)
- SRA: Shift Arithmetic Right (sign-extended)

## 📊 Design Specifications

| Specification | Value |
|---------------|-------|
| Data Width | Parameterized (default: 8 bits) |
| Opcode Width | 5 bits |
| Operations | 15 total (Arithmetic: 5, Logic: 7, Shift: 3) |
| Latency | 1 cycle (combinational) |
| Target Frequency | 100+ MHz |
| Synthesis Tool | Vivado, Quartus, etc. |

## 🔧 Prerequisites

- Icarus Verilog (`iverilog`)
- GTKWave (for waveform viewing)
- Linux/macOS/Windows (with WSL)


## 📖 Documentation

See `docs/specification.md` for:

- Complete I/O specifications
- Detailed opcode encoding table
- Internal module behavior
- Verification methodology
- Design considerations
- Future improvements


## 🧪 Test Coverage

The testbenches provide coverage for:

- Basic functionality of each operation
- Boundary conditions (0, max value)
- Overflow/underflow scenarios
- Sign extension in arithmetic right shift
- All shift amounts from 0 to DATA_WIDTH-1
- Randomized test patterns

## 🛠️ Future Work

- [ ] Add rotate operations (ROL, ROR)
- [ ] Add divide unit with quotient and remainder
- [ ] Add status flags (zero, overflow, sign)
- [ ] Move to SystemVerilog with interfaces
- [ ] Add constrained random testing (UVM)
- [ ] Integrate into small CPU datapath
- [ ] Add formal verification assertions


## 📚 References

- IEEE Std 1364-2005 (Verilog HDL)
- Icarus Verilog Manual
- GTKWave Documentation
- VLSI Design Textbooks

## 🤝 Contributing

This is a learning project. Suggestions and improvements are welcome!

## 📄 License

Open source - Free to use and modify

## ✅ Project Status

- ✅ RTL Design Complete
- ✅ Testbenches Complete
- ✅ Simulation Verified
- ✅ Documentation Complete
- 🔜 Future: Synthesis & P&R

---

**Last Updated**: November 27, 2025
**Version**: 1.0
**Status**: Active


