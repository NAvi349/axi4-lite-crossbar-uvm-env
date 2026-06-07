# AXI4-Lite Crossbar Verification

This repository contains a work-in-progress UVM verification environment for an **AXI4-Lite crossbar** with multiple master and slave ports.

The verification environment is being developed incrementally, starting with a pure SystemVerilog prototype testbench before moving into a full UVM-based architecture.

> **Status:** Work in Progress (WIP)

---

## Design Under Verification

The design used for this project is the AXI-Lite crossbar from the ZipCPU `wb2axip` repository:

- [axilxbar.v — ZipCPU/wb2axip](https://github.com/ZipCPU/wb2axip/blob/master/rtl/axilxbar.v)

---

## Design Description and Feature List

The DUT is an **AXI4-Lite crossbar interconnect**.

The crossbar configuration being verified has:

- **4 ports on the left side** — master input-side ports
- **8 ports on the right side** — slave output-side ports

The interconnect maps a transaction from any master to one of the available slaves based on the address. If two or more masters attempt to access the same slave at the same time, arbitration logic decides which master gets access.

### Example Transaction

Consider **Master 0** accessing **Slave 2**:

1. The address corresponding to Slave 2 is driven on Master 0's address channel.
2. The write data intended for Slave 2 is driven on Master 0's data channel.
3. On the slave side, the testbench checks the Slave 2 output pins.
4. The address and data observed on Slave 2 should match what was driven by Master 0.

This confirms that the crossbar correctly routes transactions from the selected master to the addressed slave.

---

## Verification Activities

- Prototype testbench in pure SystemVerilog to understand design behavior
- UVM sequence item
- UVM sequence, sequencer, and driver — agent design
- UVM monitor
- UVM scoreboard
- UVM environment

---

## Test Plan

This section will cover test scenarios planned for the design.

Planned scenarios include:

- Single master accessing a single slave
- One master accessing multiple slaves
- Multiple masters accessing different slaves
- Multiple masters accessing the same slave (arbitration)
- Read transactions
- Write transactions
- Back-to-back transactions
- `READY` / `VALID` handshake behavior
- Slave response handling
- Reset behavior
- Address decoding checks

---

## Testbench Development

The testbench is being developed in stages. The first stage is a pure SystemVerilog prototype to understand DUT behavior, followed by a full UVM environment.

---

## SystemVerilog Prototype Testbench

A simple SystemVerilog testbench was developed first.

In this testbench:

- The DUT is instantiated directly
- Default DUT parameters are used
- Clock and `reset_n` are driven by the testbench
- A separate clock monitor is implemented in another `initial` block

### Initial Simulation

- Slave address `32'h4000_0002` was driven on the Master 0 address channel
- This address corresponds to **Slave 2**
- The transaction appeared correctly on the Slave 2 side
- A **2 clock cycle latency** was observed in the transmission path

<img width="1772" height="626" alt="Simulation Result" src="https://github.com/user-attachments/assets/a72b6e4e-56e0-43cd-944a-d833712a1724" />

The initial stimulus was driven sequentially. However, since both sides of the DUT need to be exercised, future testbenches should use parallel tasks for each interface — which is one motivation for moving to UVM.

---

## Lessons Learned

### When to Drive DUT Inputs

The golden rule followed:

1. Wait for a positive clock edge
2. Move a small timestep after the edge
3. Drive the input signals

This avoids race conditions between the DUT and testbench. Since Verilator simulates using a C++ backend, this style helps model hardware behavior correctly.

```verilog
@(posedge clk);
#1;
// drive inputs
```

### AXI Handshake

The AXI handshake rule:

- When `VALID` goes HIGH, it must remain HIGH until `READY` is asserted and the transfer is captured by the DUT (typically on a `posedge`)
- After the handshake, `VALID` may be deasserted

```verilog
@(posedge clk);
#1;
VALID = 1'b1;

do begin
  @(posedge clk);
end while (READY == 1'b0);

VALID = 1'b0;
```

The above ensures that `VALID` and `READY` are both high for at least one clock edge, allowing the transfer to be captured.

---

## UVM Testbench — Phase 1

The UVM testbench is being developed in phases. For now, a rough template has been created.

Since the DUT is driven from both sides, **separate agents** are used for each side.

### UVM Sequence Item (Master and Slave Signals)

A single sequence item is used containing all signals from both sides. It is registered with the UVM factory and includes a standard `new` constructor.

### Interface (Master and Slave Signals)

A single interface contains all DUT signals. **Clocking blocks** are used to drive signals correctly without race conditions between the testbench and DUT.

### UVM Driver — Master Input Side

The master-side driver contains two drive tasks:

- One for driving the slave address
- One for driving the slave data

For now, these run sequentially. After compilation passes and simulation is stable, the plan is to use `fork...join` to launch them in parallel — since in real AXI designs, data can arrive before address and vice versa.

### UVM Driver — Slave Input Side

The slave-side driver drives the `READY` signals and responses for master transactions.

### UVM Environment

Two agents are declared in the environment — one for each side of the DUT.

### Slave Memory

An AXI-compliant memory model was generated with the help of an AI chatbot, since this repository focuses on the **verification** side of the AXI-Lite crossbar.

- 8 slave memory units are instantiated
- Bit slicing is done because the top-level AXI signals are flattened

### UVM TB Top

In the top-level testbench:

- The AXI-Lite crossbar DUT is instantiated
- 8 slave memory units are instantiated using a `generate` loop
- The interface handle is set in `uvm_config_db` for UVM components to access

### Skeleton Code for Other Components

Skeleton code has been created for:

- Monitors
- Scoreboard
- Agents

These will be filled in during later phases.

### Phase 2

This is where we do a basic transaction driving to the DUT with compilation cleaned up
There is one agent each at master and slave side of the DUT.
