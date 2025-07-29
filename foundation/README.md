# 4-Bit NAND-Only ALU – Project VALERIUS

## Overview
This repository contains a fully structural, 4-bit ALU implemented using **only NAND gates** for all operations (AND, OR, ADD). All code is modular and verified in simulation with Icarus Verilog.

## Directory Structure

- `ALU_4bit.v` — Top-level ALU and all submodules (NAND-based)
- `tb_ALU_4bit.v` — Self-checking testbench for all ALU modes

## Usage

### Compilation and Simulation
terminal comands:
iverilog -g2012 -o alu_tb ALU_4bit.v tb_ALU_4bit.v
vvp alu_tb


### Instructions

- All `a` and `b` inputs must be supplied as **signed 2's complement numbers**.
- For SUBTRACTION: user must supply B already negated (ALU does not internally invert).
- Outputs are shown by `$monitor` with each stimulus.

## Linting

- The project includes a GitHub Actions lint workflow (in `.github/workflows/lint.yml`) using Verilator.
- Lint is **automatically run** on every push to `main` or `master`.

## Author

**Sriram, B.Tech 4th year** — as part of the VALERIUS learning journey.

---

*For simulation output and more details, see commit logs and waveform (if used).*
