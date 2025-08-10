# Verilog Vending Machine Controller

This project is a complete implementation of a vending machine controller using a Moore Finite State Machine (FSM). The design is written in Verilog and is fully validated with a comprehensive testbench.

The project is structured to follow standard industry practices:
* **RTL Design**: The core logic of the vending machine.
* **Verification**: A self-checking testbench to validate functionality.

---

## Features

* **Moore FSM Architecture**: The controller's logic is based on a 3-state Moore machine (`IDLE`, `VEND`, `CHANGE`).
* **Incremental Deposits**: Accepts 5, 10, and 25-cent coin inputs.
* **Parameterized Price**: The item price can be easily configured.
* **Automatic Change Calculation**: Automatically computes and outputs the correct change.
* **Comprehensive Testbench**: Includes directed test cases for exact payment, overpayment, and reset scenarios.

---

## File Structure

The repository is organized into two main directories:

* `rtl/`: Contains the synthesizable Verilog source code.
    * `vending_machine.v`: The core FSM and combinational logic for the controller.
* `sim/`: Contains the verification files.
    * `vending_machine_tb.v`: The self-checking testbench used to simulate and validate the design.

---

## How to Use

### Simulation

1.  **Setup**: Create a project in your simulation tool (e.g., ModelSim, QuestaSim, or Vivado's built-in simulator).
2.  **Add Files**: Add `vending_machine.v` from the `rtl/` directory and `vending_machine_tb.v` from the `sim/` directory.
3.  **Run Simulation**: Set `vending_machine_tb` as the top module and run the simulation. The testbench will automatically run through its test cases and print success or failure messages to the console.

---

## Future Work

A potential next step for this project is to synthesize the design and implement it on an FPGA (like the Digilent Basys 3). This would involve creating a top-level wrapper to connect the design to physical switches and LEDs and writing an XDC constraints file for pin mapping.
