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
    

    forever begin
      `uvm_info(get_full_name(), "Getting next item from sequence in master driver", UVM_LOW)
      seq_item_port.get_next_item(m_tx);
      
      //$cast(m_tx, tx);
      // address channel
      // data channel
      // implement fork for this in future
      drive_slave_address_into_master_input(m_tx);
      drive_slave_data_into_master_input(m_tx);
      
      seq_item_port.item_done();
    end
    
  endtask
  
  
  virtual task drive_slave_address_into_master_input(axi_xbar_item m_tx);
    
    @(posedge xif.clock);
    
    
   `uvm_info(get_full_name(), $sformatf("Driving Address of Slave 2 to Master 0"), UVM_LOW)
    xif.s_axi_awaddr  [31:0]  <= 'h4000_0001;
    xif.s_axi_awvalid [   0]  <= 'b1;

    
    //do @(xif.cb_m) begin
      
    //end while (xif.cb_m.s_axi_awready[0] === 0);  
    
    xif.s_axi_awvalid [   0]  <= 'b0;
    
   `uvm_info(get_full_name(), $sformatf("Got AW[0] Ready"), UVM_LOW)
   
  endtask
  
  virtual task drive_slave_data_into_master_input(axi_xbar_item m_tx);
    
    @(posedge xif.clock);
    
   `uvm_info(get_full_name(), $sformatf("Driving Data of Slave 2 to Master 0"), UVM_LOW)
    
    xif.s_axi_wdata   [31:0]  <= 'h0000_0002;
    xif.s_axi_wstrb   [ 3:0]  <= 'hF;
    
    xif.s_axi_wvalid  [   0]  <= 'b1;
    
    // wait till wready HIGH
    //do @(xif.cb_m) begin
      
    //end while (xif.cb_m.s_axi_wready[0] === 0);
      
    
   `uvm_info(get_full_name(), $sformatf("Got W[0] Ready"), UVM_LOW)
    
    xif.s_axi_wvalid  [   0]  <= 'b0;
  endtask
  
  
  
endclass: axi_xbar_master_driver
