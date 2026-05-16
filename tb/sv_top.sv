`include "axilxbar.sv"
`include "skidbuffer.sv"
`include "addrdecode.sv"

`timescale 1ns/1ps
module sv_top ();
  
  logic clk;
  logic rst_n;

  logic [3:0] s_axi_awvalid;
  logic [3:0] s_axi_awready;
  logic [127:0] s_axi_awaddr;
  logic [11:0] s_axi_awprot;
  logic [3:0] s_axi_wvalid;
  logic [3:0] s_axi_wready;
  logic [127:0] s_axi_wdata;
  logic [15:0] s_axi_wstrb;
  logic [3:0] s_axi_bvalid;
  logic [3:0] s_axi_bready;
  logic [7:0] s_axi_bresp;
  logic [3:0] s_axi_arvalid;
  logic [3:0] s_axi_arready;
  logic [127:0] s_axi_araddr;
  logic [11:0] s_axi_arprot;
  logic [3:0] s_axi_rvalid;
  logic [3:0] s_axi_rready;
  logic [127:0] s_axi_rdata;
  logic [7:0] s_axi_rresp;

  logic [255:0] m_axi_awaddr;
  logic [23:0] m_axi_awprot;
  logic [7:0] m_axi_awvalid;
  logic [7:0] m_axi_awready;
  logic [255:0] m_axi_wdata;
  logic [31:0] m_axi_wstrb;
  logic [7:0] m_axi_wvalid;
  logic [7:0] m_axi_wready;
  logic [15:0] m_axi_bresp;
  logic [7:0] m_axi_bvalid;
  logic [7:0] m_axi_bready;
  logic [255:0] m_axi_araddr;
  logic [23:0] m_axi_arprot;
  logic [7:0] m_axi_arvalid;
  logic [7:0] m_axi_arready;
  logic [255:0] m_axi_rdata;
  logic [15:0] m_axi_rresp;
  logic [7:0] m_axi_rvalid;
  logic [7:0] m_axi_rready;
  
  axilxbar  axi_crossbar_uut (
      .S_AXI_ACLK     (clk),
      .S_AXI_ARESETN (rst_n),
  
      // Slave AXI-Lite Write Address Channel
      .S_AXI_AWVALID (s_axi_awvalid),
      .S_AXI_AWREADY (s_axi_awready),
      .S_AXI_AWADDR  (s_axi_awaddr),
      .S_AXI_AWPROT  (s_axi_awprot),
  
      // Slave AXI-Lite Write Data Channel
      .S_AXI_WVALID  (s_axi_wvalid),
      .S_AXI_WREADY  (s_axi_wready),
      .S_AXI_WDATA   (s_axi_wdata),
      .S_AXI_WSTRB   (s_axi_wstrb),
  
      // Slave AXI-Lite Write Response Channel
      .S_AXI_BVALID  (s_axi_bvalid),
      .S_AXI_BREADY  (s_axi_bready),
      .S_AXI_BRESP   (s_axi_bresp),
  
      // Slave AXI-Lite Read Address Channel
      .S_AXI_ARVALID (s_axi_arvalid),
      .S_AXI_ARREADY (s_axi_arready),
      .S_AXI_ARADDR  (s_axi_araddr),
      .S_AXI_ARPROT  (s_axi_arprot),
  
      // Slave AXI-Lite Read Data Channel
      .S_AXI_RVALID  (s_axi_rvalid),
      .S_AXI_RREADY  (s_axi_rready),
      .S_AXI_RDATA   (s_axi_rdata),
      .S_AXI_RRESP   (s_axi_rresp),
  
      // Master AXI-Lite Write Address Channel
      .M_AXI_AWADDR  (m_axi_awaddr),
      .M_AXI_AWPROT  (m_axi_awprot),
      .M_AXI_AWVALID (m_axi_awvalid),
      .M_AXI_AWREADY (m_axi_awready),
  
      // Master AXI-Lite Write Data Channel
      .M_AXI_WDATA   (m_axi_wdata),
      .M_AXI_WSTRB   (m_axi_wstrb),
      .M_AXI_WVALID  (m_axi_wvalid),
      .M_AXI_WREADY  (m_axi_wready),
  
      // Master AXI-Lite Write Response Channel
      .M_AXI_BRESP   (m_axi_bresp),
      .M_AXI_BVALID  (m_axi_bvalid),
      .M_AXI_BREADY  (m_axi_bready),
  
      // Master AXI-Lite Read Address Channel
      .M_AXI_ARADDR  (m_axi_araddr),
      .M_AXI_ARPROT  (m_axi_arprot),
      .M_AXI_ARVALID (m_axi_arvalid),
      .M_AXI_ARREADY (m_axi_arready),
  
      // Master AXI-Lite Read Data Channel
      .M_AXI_RDATA   (m_axi_rdata),
      .M_AXI_RRESP   (m_axi_rresp),
      .M_AXI_RVALID  (m_axi_rvalid),
      .M_AXI_RREADY  (m_axi_rready)
  );
  

  initial begin
    
    clk = 0;
    rst_n = 0;
    
    #5ns;

    rst_n = 1;

  end

  initial begin
    
    #1ns;
	$display("Waiting for Reset release");    
	// wait till reset released
    @(posedge rst_n);
    
	$display("Reset released");
    $finish;
       
  end
  
  always #5ns clk = !clk;


endmodule
