***

# 4-Bit Parameterized Up-Counter (Verilog)

## Overview

This project implements a **parameterized, synchronous N-bit up-counter** with:

- **Asynchronous active-low reset**
- **Synchronous enable**
- **Synchronous load with external input**
- Fully scalable width (default: 4 bits)
- Robust testbench
- Infrastructure for waveform simulation 

This is part of my VLSI learning journey  
Author: *Chinthala Sriram (B.Tech, 4th Year)*
  
***

## Files

| File                       | Description                                                  |
|----------------------------|-------------------------------------------------------------|
| `counter_4bit.v`           | Main parameterized counter RTL                              |
| `tb_counter_4bit.v`        | Testbench for function, corner, and robustness checks       |
| `README.md`                | Project documentation, usage, and structure                 |
| `counter_tb.vvp`(generated)| Executable simulation file with waveform details also       |      
| `counter.vcd` (generated)  | Waveform file for GTKWave visualization (created after sim) |

***

## Port & Parameter Description

- **Parameter**
  - `width` (default 4): Sets the bit-width of the counter.

- **Ports**
  | Name      | Direction | Width           | Description                                                       |
  |-----------|-----------|-----------------|-------------------------------------------------------------------|
  | `clk`     | input     | 1               | System clock (posedge-triggered)                                  |
  | `rst_n`   | input     | 1               | Asynchronous active-low reset; clears counter immediately         |
  | `enable`  | input     | 1               | Synchronous enable; count increments only when asserted           |
  | `load`    | input     | 1               | Synchronous load; counter is set to `data_in` on clk edge         |
  | `data_in` | input     | `[width-1:0]`   | Data value loaded when `load` is asserted                         |
  | `out`     | output    | `[width-1:0]`   | Current counter value                                             |

**Control signal priority:**  
1. Asynchronous Reset (highest, immediate)  
2. Synchronous Load  
3. Synchronous Enable  
4. Hold (no control asserted)

***

## Key Features

- **Parameterizable:** Change `width` to create wider/narrower counters
- **Standardized load:** Loads from external input, not internal value
- **Latching/latch-free:** Output always reflects register; safe for synthesis
- **Verilator/Icarus-friendly:** Standard-compliant for open-source flows
- **Portable testbench:** Exercises all major control features and edge cases

***

## Waveform Visualization (GTKWave)
** Remove the commented lines for the block in tb files, for clarity visit file **
1. Include in your testbench:
    ```verilog
    initial begin
      $dumpfile("counter.vcd");
      $dumpvars(0, tb_counter_4bit); // Dump all signals from testbench downward
    end
    ```
2. Re-run simulation:
    ```
    iverilog -g2012 -o counter_tb.vvp counter_4bit.v tb_counter_4bit.v
    vvp counter_tb.vvp
    ```
3. Launch GTKWave:
    ```
    gtkwave counter.vcd &
    ```
***

## Testbench Highlights

- Performs functional testing: count, pause, reset, load
- Checks reset and wrap-around (overflow) behavior
- $monitor outputs all state transitions for review

> **Note:** Verilator produces warnings for `#` delays in testbenches (`STMTDLY`). This is expected and does not affect synthesis or GitHub pushes.

***

## Usage Example

**Compile and Run:**
** Remove the commented lines for the lines in tb files, for clarity visit file **
```sh
iverilog -g2012 -o counter_tb.vvp counter_4bit.v tb_counter_4bit.v
vvp counter_tb.vvp
```

**Change Parameterization:**
- Edit `localparam width = N;` in `tb_counter_4bit.v` and `.width(width)` in instantiations for different counter widths.

***

## Example Waveform

| Time (ns) | enable | rst_n | load | data_in | out | Notes                                  |
|-----------|--------|-------|------|---------|-----|----------------------------------------|
| 0         | 1      | 1     | 0    |   x     |  0  | Power-up, begin count                  |
| 10        | 0      | 1     | 0    |   x     |  n  | Counting paused                        |
| 60        | 1      | 1     | 0    |   x     | n+1 | Counting resumes                       |
| 110       | 1      | 0     | 0    |   x     |  0  | Async reset triggers                   |
| 180       | 1      | 1     | 1    | 0xB     | n   | Load active—will be set on next clock  |
| 185       | 1      | 1     | 1    | 0xB     | 0xB | Value loaded; output updates           |

***

## Known Limitations & Next Steps

- The counter is unsigned and wraps on overflow. Down-counting, saturating, or Gray code features can be added as enhancements.
- Testbench could be further enhanced with randomized and self-checking properties.

***

## Professional/CI Notes

- All synthesis warnings from Verilator regarding `#` delays in the testbench are **expected** and safe to ignore for simulation/testing.
- RTL (counter_4bit.v) is fully synthesizable.

***

**Contact & Attribution**  
For questions, raise a GitHub Issue or contact:  
Chinthala Sriram — [sriramchintala200@gmail.com]

***

*“Clear, reproducible documentation is as critical as flawless hardware. This file is your contract with every future user and collaborator.”*

***
