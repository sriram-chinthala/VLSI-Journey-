📘 Parameterized ALU (Verilog)

A modular, parameterized Arithmetic Logic Unit supporting arithmetic, logic, and shifting operations. Designed for FPGA/ASIC-style RTL and verified using Icarus Verilog.

🚀 Features

Parameterized DATA_WIDTH

Arithmetic operations (ADD, SUB, INC, DEC, MUL)

Logic operations (AND, OR, XOR, NOT, NAND, NOR, XNOR)

Shift operations (SLL, SRL, SRA)

Clean, modular RTL hierarchy

Independent testbenches for each module

Verified using Icarus + GTKWave

📂 Project Structure
project_4_paramaterized_ALU/
│
├── RTL/
│   ├── alu.v
│   ├── arithmetic_unit.v
│   ├── logic_unit.v
│   └── shifter_unit.v
│
├── testbench/
│   ├── tb_alu.v
│   ├── tb_arithmetic_unit.v
│   ├── tb_logic_unit.v
│   └── tb_shifter_unit.v
│
└── docs/
|    └── specification.md
|
|
|--sim_wave/
    |____ tb_alu.vcd
    |
    |____ tb_alu_8.vcd



🧩 Opcode Encoding
Unit	Opcode [4:3]	Sub-Opcode [2:0]	Operation
Arithmetic	00	000	ADD
		001	SUB
		010	INC
		011	DEC
		100	MUL
Logic	01	000	AND
		001	OR
		010	XOR
		011	NOT
		100	NAND
		101	NOR
		110	XNOR
Shifter	10	00	SLL
		01	SRL
		10	SRA
Reserved	11	—	Future use

▶️ How to Run Simulation (Icarus)

open the terminal in the project folder and 

iverilog -o output/output_alu.vvp RTL/alu.v RTL/arithmetic_unit.v RTL/logic_unit.v RTL/shifter_unit.v testbench/tb_alu.v
vvp output/output_alu.vvp
gtkwave sim_wave/tb_alu.vcd


🧪 Testbenches Included

✔ tb_alu.v — Complete ALU verification

✔ tb_arithmetic_unit.v

✔ tb_logic_unit.v

✔ tb_shifter_unit.v

✔ VCD dumping enabled

🛠 Future Work

Add rotate operations

Add divide unit

Add zero/overflow flags

Move to SystemVerilog with interfaces & constrained random testing