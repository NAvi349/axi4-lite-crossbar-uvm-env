/*
Description: This is the slave input driver
*/


class axi_xbar_slave_driver extends uvm_driver #(axi_xbar_item);
  virtual axi_xbar_if xif;
 
 `uvm_component_utils(axi_xbar_slave_driver)
  
  uvm_sequence_item tx;
  axi_xbar_item s_tx;
  
  function new(string name = "axi_xbar_slave_driver", uvm_component parent);
    super.new(name, parent);    
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    uvm_config_db#(virtual axi_xbar_if)::get(this, "", "axi_xbar_if", xif);
  endfunction: build_phase
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
      seq_item_port.get_next_item(tx);
      $cast(s_tx, tx);
      drive_slave_address_response(s_tx);
      drive_slave_data_response(s_tx);
      drive_slave_final_response(s_tx);
      seq_item_port.item_done(); 
    end
    
    
  endtask
  
  task drive_slave_address_response(axi_xbar_item s_tx);
    
    // this task should drive the ready signal for address
    @(posedge xif.clock);
    
    do begin
      @(posedge xif.clock);
    end while (xif.m_axi_awvalid != 0);
    
    xif.m_axi_awready <= 1;
    
  endtask
  
  task drive_slave_data_response(axi_xbar_item s_tx);
    
    // this task drives ready signal for data
    @(posedge xif.clock);
    
    //do begin
      //@xif.cb;      
    //end while (m_axi_wvalid != 0);
    
    xif.m_axi_wready <= 1;
  endtask
  
  task drive_slave_final_response(axi_xbar_item s_tx);
    
    // drive slave response handshake
    @(posedge xif.clock);
    
    xif.m_axi_bvalid <= 1;
    
    //do begin
    @(posedge xif.clock);
    //end while (xif.cb_s.m_axi_bready === 0);
    
    xif.m_axi_bvalid <= 0;
  endtask
  
  
endclass
