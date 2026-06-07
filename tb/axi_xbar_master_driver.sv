/*
Description: This is the driver of master input/slave output. The driver respects the AXI Lite protocol.
*/

class axi_xbar_master_driver extends uvm_driver #(axi_xbar_item);

 `uvm_component_utils(axi_xbar_master_driver)
  virtual axi_xbar_if xif;
   
  //uvm_sequence_item tx;
  axi_xbar_item m_tx;
  

  
  function new(string name = "axi_xbar_master_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual axi_xbar_if)::get(this, "", "axi_xbar_if", xif);
  endfunction
  
  
  task run_phase (uvm_phase phase);
    
   `uvm_info("MST_DRV", "Waiting for reset release", UVM_LOW)
    
    reset_dut();

    forever begin
     `uvm_info("MST_DRV", "Getting next item from sequence in master driver", UVM_LOW)
      seq_item_port.get_next_item(m_tx);
      
     `uvm_info(get_full_name(), "Driving master", UVM_LOW)      
      //$cast(m_tx, tx);
      // address channel
      // data channel
      // implement fork for this in future
      drive_slave_address_into_master_input(m_tx);
      // second task changes based on read or write
      drive_slave_data_into_master_input(m_tx);
      
      seq_item_port.item_done();
    end
    
  endtask
  
  virtual task reset_dut();
    
    xif.s_axi_awvalid <= 0;
    xif.s_axi_awaddr <= 0;
    xif.s_axi_awprot <= 0;
    xif.s_axi_wvalid <= 0;
    xif.s_axi_wdata <= 0;
    xif.s_axi_wstrb <= 0;
    xif.s_axi_bready <= 0;
    xif.s_axi_bresp <= 0;
    xif.s_axi_arvalid <= 0;
    xif.s_axi_araddr <= 0;
    xif.s_axi_arprot <= 0;
    xif.s_axi_rready <= 0;
   
    @(posedge xif.rst_n);
    
    `uvm_info("MST_DRV", "Reset released", UVM_LOW)
  endtask
  
  
  virtual task drive_slave_address_into_master_input(axi_xbar_item m_tx);
    
    @(posedge xif.clock);
    
    
   `uvm_info("MST_DRV", $sformatf("Driving Address of Slave 2 to Master 0"), UVM_LOW)
    xif.s_axi_awaddr  [31:0]  <= 'h4000_0001;
    xif.s_axi_awvalid [   0]  <= 'b1;

    repeat (2) @(posedge xif.clock);
    
    do @(posedge xif.clock) begin
      `uvm_info("MST_DRV", "Waiting for AW Ready from slave", UVM_LOW)
    end while (xif.s_axi_awready[0] === 0);
    
    xif.s_axi_awvalid [   0]  <= 'b0;
    
    `uvm_info("MST_DRV", $sformatf("Got AW[0] Ready"), UVM_LOW)
   
  endtask
  
  virtual task drive_slave_data_into_master_input(axi_xbar_item m_tx);
    
    @(posedge xif.clock);
    
    `uvm_info("MST_DRV", $sformatf("Driving Data of Slave 2 to Master 0"), UVM_LOW)
    
    xif.s_axi_wdata   [31:0]  <= 'h0000_0002;
    xif.s_axi_wstrb   [ 3:0]  <= 'hF;
    
    xif.s_axi_wvalid  [   0]  <= 'b1;
    
    repeat (2) @(posedge xif.clock);
    // wait till wready HIGH
    //do @(posedge xif.clock) begin
    // `uvm_info("MST_DRV", "Waiting for W Ready from slave", UVM_LOW)      
    //end
    while (xif.s_axi_wready[0] === 0);
      
      
    
    `uvm_info("MST_DRV", $sformatf("Got W[0] Ready"), UVM_LOW)
    
    xif.s_axi_wvalid  [   0]  <= 'b0;
    
    // wait till bvalid to assert bready
    
    fork 
      
      begin
        do @(posedge xif.clock) begin
      `uvm_info("MST_DRV", "Waiting for BVALID from slave", UVM_LOW)
    end while (xif.s_axi_bvalid[0] === 0);
        
      end
      
      begin
        #40ns;
        `uvm_error("MST_DRV", "BVALID not received from slave")
      end
      
    join_any
    
    `uvm_info("MST_DRV", $sformatf("Got Bvalid from slave"), UVM_LOW);
    xif.s_axi_bready[0] <= 1;
    
    repeat (2) @(posedge xif.clock);
      
  endtask
  
  
  
endclass: axi_xbar_master_driver
