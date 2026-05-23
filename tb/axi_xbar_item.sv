class axi_xbar_item extends uvm_sequence();
  
  

  // master input, slave output
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

  // slave input, master output
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

 `uvm_object_utils(axi_xbar_item)
  
  function new(string name="axi_xbar_item");
    super.new(name);
  endfunction
   
  
endclass
