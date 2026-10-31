# Computer Architecture

Hardware designs in Verilog for the Computer Architecture course at the University of Tehran, Spring 2025. I did these assignments with [Sepanta](https://github.com/sepantagh). Each design has a testbench and was simulated in ModelSim.

| Folder | Design |
| --- | --- |
| [CA1](CA1/CA1_810102588_810102483) | **Maze solver.** Finds a path through a 16×16 maze stored in memory. The controller explores by depth-first search, keeps its moves on a hardware stack and backtracks from dead ends, then outputs the path through a queue. `checker.py` counts the moves in the output. Datapath and controller diagrams are included. |
| [CA2](CA2) | **Single-cycle RISC-V processor.** Supports the R-type and I-type arithmetic instructions, `lw`, `sw`, `beq`, `bne`, `jal`, `jalr` and `lui`. The `tests` folder holds the programs used to check each instruction group. |
| [CA3](CA3) | **Multi-cycle stack processor.** An 8-bit processor with a 5-bit address bus and eight instructions (`push`, `pop`, `add`, `sub`, `and`, `not`, `jmp`, `jz`), where every operation works on an internal stack. |
| [CA4](CA4) | **Pipelined RISC-V processor.** A five-stage version of the CA2 processor. A hazard unit forwards results from the memory and write-back stages, stalls on load-use hazards and flushes the pipeline on taken branches and jumps. |

## Running

Open the Verilog files in ModelSim (or any Verilog simulator), compile them, and run the top-level testbench in each folder (`Topmodule_tb.v`, or `Tobmodule_tb.v` in CA3). Memory contents are loaded from the `.mem` and `.txt` files next to the sources.
