interface axi_xbar_if(input clock, input rst_n);


  logic [  3:0]   s_axi_awvalid;
  logic [  3:0]   s_axi_awready;
  logic [127:0]   s_axi_awaddr;
  logic [ 11:0]   s_axi_awprot;
  logic [  3:0]   s_axi_wvalid;
  logic [  3:0]   s_axi_wready;
  logic [127:0]   s_axi_wdata;
  logic [ 15:0]   s_axi_wstrb;
  logic [  3:0]   s_axi_bvalid;
  logic [  3:0]   s_axi_bready;
  logic [  7:0]   s_axi_bresp;
  logic [  3:0]   s_axi_arvalid;
  logic [  3:0]   s_axi_arready;
  logic [127:0]   s_axi_araddr;
  logic [ 11:0]   s_axi_arprot;
  logic [  3:0]   s_axi_rvalid;
  logic [  3:0]   s_axi_rready;
  logic [127:0]   s_axi_rdata;
  logic [  7:0]   s_axi_rresp;

  logic [255:0]   m_axi_awaddr;
  logic [ 23:0]   m_axi_awprot;
  logic [  7:0]   m_axi_awvalid;
  logic [  7:0]   m_axi_awready;
  logic [255:0]   m_axi_wdata;
  logic [ 31:0]   m_axi_wstrb;
  logic [  7:0]   m_axi_wvalid;
  logic [  7:0]   m_axi_wready;
  logic [ 15:0]   m_axi_bresp;
  logic [  7:0]   m_axi_bvalid;
  logic [  7:0]   m_axi_bready;
  logic [255:0]   m_axi_araddr;
  logic [ 23:0]   m_axi_arprot;
  logic [  7:0]   m_axi_arvalid;
  logic [  7:0]   m_axi_arready;
  logic [255:0]   m_axi_rdata;
  logic [ 15:0]   m_axi_rresp;
  logic [  7:0]   m_axi_rvalid;
  logic [  7:0]   m_axi_rready;
  
  /*
  // M_driver
  clocking cb_m_d @(posedge clock);
    //default input #setup_time output #hold_time;
  
    output s_axi_awvalid;
    output s_axi_awprot;
    output s_axi_wvalid;
    output s_axi_wdata;
    output s_axi_wstrb;
    output s_axi_bready;
    output s_axi_arvalid;
    output s_axi_araddr;
    output s_axi_arprot;
    output s_axi_rready;
     
    input s_axi_awready;
    input s_axi_wready;
    input s_axi_bvalid;
    input s_axi_bresp;
    input s_axi_arready;
    input s_axi_rvalid;
    input s_axi_rdata;
    input s_axi_rresp;
    
  endclocking
  
  // slave input driver
    
  clocking cb_s_d @(posedge clock);
    input m_axi_awready;
    input m_axi_wready;
    input m_axi_bresp;
    input m_axi_bvalid;
    input m_axi_arready;
    input m_axi_rdata;
    input m_axi_rresp;
    
    
    output m_axi_awaddr;
    output m_axi_awprot;
    output m_axi_awvalid;
    output m_axi_wdata;
    output m_axi_wstrb;
    output m_axi_wvalid;
    output m_axi_bready;
    output m_axi_araddr;
    output m_axi_arprot;
    output m_axi_arvalid;
    output m_axi_rready;
  endclocking
  */
  
  
endinterface
