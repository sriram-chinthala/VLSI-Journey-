📄 PARAMETERIZED ALU — SPECIFICATION DOCUMENT


1. Overview

This document describes the architecture, operation, and implementation details of a parameterized Arithmetic Logic Unit (ALU) designed in synthesizable Verilog. The ALU supports arithmetic, logical, and shift operations and allows the data width to be configured using a parameter (DATA_WIDTH). The design is modular, easily extensible, and verification-friendly.

The ALU integrates three independent sub-modules:

arithmetic_unit.v

logic_unit.v

shifter_unit.v

It selects the required module based on a 5-bit opcode and outputs the computed result, carry/borrow flags, and multiplier outputs where applicable.

2. Features

Parameterized data width (DATA_WIDTH)

Clean modular hierarchy

Support for:

ADD, SUB, INC, DEC, MUL

AND, OR, XOR, NOT, NAND, NOR, XNOR

SLL, SRL, SRA

Extensible opcode map (upper bits reserve future functions)

Fully synthesizable Verilog RTL

Independent testbenches for:

ALU top module

Arithmetic unit

Logic unit

Shifter unit

Compatible with Icarus Verilog, ModelSim, Vivado, and Quartus

3. Top-Level Block Diagram
                +-----------------------+
                |     PARAMETERIZED     |
   A ---------->|          ALU          |----------> RESULT
                |                       |
   B ---------->|   +---------------+   |
                |   | Arithmetic    |   |
  OPCODE ------>|-->|   Unit        |   |
                |   +---------------+   |
                |                       |
                |   +---------------+   |
                |   | Logic Unit    |   |
                |   +---------------+   |
                |                       |
                |   +---------------+   |
                |   | Shifter Unit  |   |
                |   +---------------+   |
                +-----------------------+

4. Parameter
Parameter	Description	Default
DATA_WIDTH	Width of operands A, B	8 bits
5. I/O Specification
Inputs
Name	Width	Description
a	DATA_WIDTH	Operand 1
b	DATA_WIDTH	Operand 2 / shift amount
op	5	Opcode selecting ALU function
Outputs
Name	Width	Description
result	DATA_WIDTH	ALU result
carry_out	1	ADD/SUB carry/borrow
mult_result	2×DATA_WIDTH	Full multiplication result
6. Opcode Encoding Table
Opcode [4:3]	Unit	Opcode [2:0]	Operation
00	Arithmetic	000	ADD
00	Arithmetic	001	SUB
00	Arithmetic	010	INC
00	Arithmetic	011	DEC
00	Arithmetic	100	MUL
01	Logic	000	AND
01	Logic	001	OR
01	Logic	010	XOR
01	Logic	011	NOT
01	Logic	100	NAND
01	Logic	101	NOR
01	Logic	110	XNOR
10	Shifter	00	SLL
10	Shifter	01	SRL
10	Shifter	10	SRA
11	Reserved	—	Future Use
7. Internal Module Behavior
Arithmetic Unit

Add, subtract, increment, decrement

Multiplier supports full-precision multiplication

Generates carry_out for addition/subtraction

Logic Unit

Bitwise operations on A and B

NOT operation ignores B

Shifter Unit

SLL: Logical left shift

SRL: Logical right shift

SRA: Arithmetic right shift (sign-extended)

8. Verification

The verification environment includes:

Testbenches

tb_alu.v

tb_arithmetic_unit.v

tb_logic_unit.v

tb_shifter_unit.v

Verification Features

Randomized tests

Directed corner-case tests:

Overflow/underflow

Negative numbers (for SUB/SRA)

Maximum/minimum values

High shift amounts

VCD dumping supported for GTKWave

9. How to Run (Icarus)
iverilog -o output/output_alu.vvp RTL/alu.v RTL/arithmetic_unit.v RTL/logic_unit.v RTL/shifter_unit.v testbench/tb_alu.v
vvp output/output_alu.vvp
gtkwave sim_wave/tb_alu.vcd


10. Future Improvements

Add rotate left/right operations

Add division

Add flags: zero, negative, overflow

Integrate into a small CPU datapath

Add SystemVerilog assertions