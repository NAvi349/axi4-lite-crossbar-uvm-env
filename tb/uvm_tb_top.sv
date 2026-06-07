`include "uvm_macros.svh"
import uvm_pkg::*;

`include "axi_xbar_if.sv"
`include "axi_slave_mem.sv"
`include "axi_xbar_item.sv"
`include "axi_xbar_seq_lib.sv"
`include "axi_xbar_master_driver.sv"
`include "axi_xbar_slave_driver.sv"
`include "axi_xbar_master_monitor.sv"
`include "axi_xbar_slave_monitor.sv"
//`include "axi_xbar_master_sequencer.sv"
//`include "axi_xbar_slave_sequencer.sv"
`include "axi_xbar_master_agent.sv"
`include "axi_xbar_slave_agent.sv"
`include "axi_xbar_scoreboard.sv"
`include "axi_xbar_env.sv"
`include "axi_xbar_base_test.sv"
`include "axi_xbar_write_read_test.sv"


module testbench;
  //import axi_xbar_pkg::*;
    
  bit clk;
  bit rst_n;
  genvar i;  
  
  axi_xbar_if axi_xif(.clock(clk), .rst_n(rst_n));
  

  axilxbar axi_crossbar_uut (
     .S_AXI_ACLK    (clk),
     .S_AXI_ARESETN (rst_n),

     // Slave AXI-Lite Write Address Channel
     .S_AXI_AWVALID (axi_xif.s_axi_awvalid),
     .S_AXI_AWREADY (axi_xif.s_axi_awready),
     .S_AXI_AWADDR  (axi_xif.s_axi_awaddr),
     .S_AXI_AWPROT  (axi_xif.s_axi_awprot),

     // Write Data
     .S_AXI_WVALID  (axi_xif.s_axi_wvalid),
     .S_AXI_WREADY  (axi_xif.s_axi_wready),
     .S_AXI_WDATA   (axi_xif.s_axi_wdata),
     .S_AXI_WSTRB   (axi_xif.s_axi_wstrb),

     // Write Response
     .S_AXI_BVALID  (axi_xif.s_axi_bvalid),
     .S_AXI_BREADY  (axi_xif.s_axi_bready),
     .S_AXI_BRESP   (axi_xif.s_axi_bresp),

     // Read Address
     .S_AXI_ARVALID (axi_xif.s_axi_arvalid),
     .S_AXI_ARREADY (axi_xif.s_axi_arready),
     .S_AXI_ARADDR  (axi_xif.s_axi_araddr),
     .S_AXI_ARPROT  (axi_xif.s_axi_arprot),

     // Read Data
     .S_AXI_RVALID  (axi_xif.s_axi_rvalid),
     .S_AXI_RREADY  (axi_xif.s_axi_rready),
     .S_AXI_RDATA   (axi_xif.s_axi_rdata),
     .S_AXI_RRESP   (axi_xif.s_axi_rresp),

     // Master AXI-Lite Write Address Channel
     .M_AXI_AWADDR  (axi_xif.m_axi_awaddr),
     .M_AXI_AWPROT  (axi_xif.m_axi_awprot),
     .M_AXI_AWVALID (axi_xif.m_axi_awvalid),
     .M_AXI_AWREADY (axi_xif.m_axi_awready),

     // Write Data
     .M_AXI_WDATA   (axi_xif.m_axi_wdata),
     .M_AXI_WSTRB   (axi_xif.m_axi_wstrb),
     .M_AXI_WVALID  (axi_xif.m_axi_wvalid),
     .M_AXI_WREADY  (axi_xif.m_axi_wready),

     // Write Response
     .M_AXI_BRESP   (axi_xif.m_axi_bresp),
     .M_AXI_BVALID  (axi_xif.m_axi_bvalid),
     .M_AXI_BREADY  (axi_xif.m_axi_bready),

     // Read Address
     .M_AXI_ARADDR  (axi_xif.m_axi_araddr),
     .M_AXI_ARPROT  (axi_xif.m_axi_arprot),
     .M_AXI_ARVALID (axi_xif.m_axi_arvalid),
     .M_AXI_ARREADY (axi_xif.m_axi_arready),

     // Read Data
     .M_AXI_RDATA   (axi_xif.m_axi_rdata),
     .M_AXI_RRESP   (axi_xif.m_axi_rresp),
     .M_AXI_RVALID  (axi_xif.m_axi_rvalid),
     .M_AXI_RREADY  (axi_xif.m_axi_rready)
  );

  
  
  generate
    for (i = 0; i < 8; i++) begin : SLAVE
  
      axi_slave_mem slave (
          .ACLK    (clk),
          .ARESETN (rst_n),

        .AWADDR  (axi_xif.m_axi_awaddr[i*32 +: 32]),
          .AWVALID (axi_xif.m_axi_awvalid[i]),
          .AWREADY (axi_xif.m_axi_awready[i]),

        .WDATA   (axi_xif.m_axi_wdata[i*32 +: 32]),
          .WVALID  (axi_xif.m_axi_wvalid[i]),
          .WREADY  (axi_xif.m_axi_wready[i]),

          .BVALID  (axi_xif.m_axi_bvalid[i]),
          .BREADY  (axi_xif.m_axi_bready[i]),

        .ARADDR  (axi_xif.m_axi_araddr[i*32 +: 32]),
          .ARVALID (axi_xif.m_axi_arvalid[i]),
          .ARREADY (axi_xif.m_axi_arready[i]),

        .RDATA   (axi_xif.m_axi_rdata[i*32 +: 32]),
          .RVALID  (axi_xif.m_axi_rvalid[i]),
          .RREADY  (axi_xif.m_axi_rready[i])
      );
  
  end
endgenerate

  


  initial begin
    uvm_config_db#(virtual axi_xbar_if)::set(uvm_root::get(), "*", "axi_xbar_if", axi_xif);
    
    run_test("axi_xbar_write_read_test");
    
  end
  
  
  
  initial begin
    clk <= 0;
    rst_n <= 0;
    
    #20ns;
    
    $display("reset released");
    rst_n <= 1;

    
    //#50ns;
    //$finish;
  end
 
  
  initial begin
        
        forever #5ns clk = ~clk;
    
  end
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
