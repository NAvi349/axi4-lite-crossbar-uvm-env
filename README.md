# axi4-lite-crossbar
This repository contains UVM env (eventually!) of a AXI4 Lite Cross-bar with two master and four slaves.
This is a WIP.

# Design
https://github.com/ZipCPU/wb2axip/blob/master/rtl/axilxbar.v - This will be the design I will be using


# Design description and feature list to cover in testbench
This section will provide a concise summary of the design and feature list to be covered in testbench.
The design has 4 ports in the left side and 8 ports in the right side. The left side ports are master inputs and right side ports are slave inputs (master outputs). This interconnect maps a master to any one of the slaves. If two masters access the same slave at a time, arbitation rules are used.

Suppose we take Master 0 and Slave 2:

I place the address of slave 2 on master 0' address channel. Data that I will send to slave 2 will also be placed on master 0's data channel.
At the right side, I check slave 2 pins to see the address and data I placed on master 0 channels.

# Verification activities
- Prototype testbench in pure system verilog to understand design behaviour.
- UVM sequence item
- UVM sequence, sequencer and driver - Agent design
- UVM monitor
- UVM scoreboard
- UVM env

# Testplan
This section will cover test scenarios planned for the design.

# Testbench development
I will first try to understand the design properly through pure system verilog simulation before moving onto UVM testbench.

## System Verilog Prototype testbench

First I attempted a very crude system verilog testbench. I instantiated the design. I decided to keep the parameters default. Clock and reset_n are driven to the clock. I also implemented a seperate clock monitor inside a seperate initial block.

<img width="1772" height="626" alt="image" src="https://github.com/user-attachments/assets/a72b6e4e-56e0-43cd-944a-d833712a1724" />
This is the simulation result.

I drive slave address 'h4000_0002 on master 0 address channel. This slave address corresponds to slave 2. From the design and also from simulation I observed that there seems to be 2 clock cycle latency in the transmission path.

All these signals were driven sequentially only. But the thing is since we can drive from both sides of the DUT, there should be seperate parallel task for each side to functionally verify the DUT. I decided to do this in UVM testbench.

## Some lessons learnt

### When to drive the pins of the DUT
During the development of this SV testbench, I had this ambiguity of when I should drive the input to the DUT.

Always we shall remember the golden rule.

Wait for a posedge. Move a small timestep. Then assign the values. Since I use Verilator (which simulates using C++) this is the correct way to model hardware behaviour.

```verilog
@(posedge clk);
#1;
//drive inputs
```

### AXI Handshake

So AXI handshake works like this:
When VALID goes HIGH it should remain HIGH until READY is asserted and it gets captured by the DUT (in posedge of most designs).
It then can deassert to LOW.

```verilog
@(posedge clk);
#1;

VALID = HIGH
do begin
@(posedge clk);
end while (READY == LOW);

VALID = LOW
```

The above ensures that VALID and READY remain high for a edge

## UVM Testbench Phase 1

I am dividing this section into phases, as I will be developing the uvm architecture over many sessions. For now I have created a rough template code.
Since we drive in both directions of the DUT, we need a seperate agent at each side.

### UVM Sequence item (both master and slave signals)

First we shall create the sequence item. This will contain all the signals from both sides. After that we register with the factory and create the new constructor.

### Interface class (both master and slave signals)

I have a single interface class for all the signals. I am planning to take advantage of clocking blocks to drive the signals correctly without race situations between testbench and DUT.

### UVM Driver (for master input side)

Here there are two drive input tasks. One for driving the slave address and another for driving slave data. For now I have kept them sequentially. After compilation passes and simulation is stable I am planning to use fork join to launch them parallely as in real world designs data can come before address and vice versa.

### UVM Driver (for slave input side)

Here we drive the ready signals and response for the master transactions.

### UVM Environment

I have declared two agents here. One for each side of the DUT.

### Slave Memory

Here I have asked an AI chatbot to generate me a AXI-compliant memory model. I am consulting the help of chatbot here as this repo will focus on the verification part of the AXI Lite Crossbar. I have instantiated 8 slave memory units. Bit slicing is done since the top level AXI signals are flattened.

### UVM TB Top

Here I have instantiated the axi-lite crossbar DUT and 8 slave memory units. I have used generate loop for instantiating the slave memory units. Also here I am setting the uvm_config_db for the interface.

### Skeleton code for other components

For now I have created skeleton code for monitors, scoreboard, agents.

