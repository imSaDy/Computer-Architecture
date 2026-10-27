# Single-cycle RISC-V processor

A single-cycle RISC-V processor in Verilog. It supports the R-type and I-type arithmetic instructions, `lw`, `sw`, `beq`, `bne`, `jal`, `jalr` and `lui`.

`TopModule.v` connects the datapath (`DataPath.v`) and the controller (`Controller.v`). The program is read from `InstructionMemory.mem` and data from `DataMemory.mem`. The `tests` folder holds the programs used to check each instruction group. Run `Topmodule_tb.v` to simulate.
