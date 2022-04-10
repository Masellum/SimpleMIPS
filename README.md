# Simple MIPS

A simplified MIPS CPU implemented in Verilog.

# Description

This project is my homework of Computer Organization and Design course and only implemented the most basic functions of a MIPS CPU.

It is:
  - 32-bit
  - 5-stage-pipelined
  - always assuming branch is not taken
  - detecting and performing branch and jump in stage 2
  - supporting stalls
  - forwarding data from stage 3, 4 and 5 to stage 2 and 3
  - divided into many modules
  - messily coded
  - without testbench
  - lacking comment

# Test

There are two assembly files (and the hex code of them) in thr root of the project which can be used to test several basic instructions. 

# Thanks

This project is inspired by the book *Computer Organization and Design: The Hardware/Software Interface* by D. A. Patterson and J. L. Hennessy (5th ed. 2014).

# License

WTFPL