/*
Description: This monitor will have two ports each of them will monitor the input/output of the slave side of the DUT.


*/


class axi_xbar_slave_monitor extends uvm_monitor;
 `uvm_component_utils(axi_xbar_slave_monitor)
  
  virtual axi_xbar_if xif;
    
  uvm_analysis_port #(axi_xbar_item) dut_slave_tx_in;
  uvm_analysis_port #(axi_xbar_item) dut_slave_tx_out;
  
  function new(string name = "axi_xbar_slave_monitor", uvm_component parent);
    super.new(name, parent);
   
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    dut_slave_tx_in = new("dut_slave_tx_in", this);
    dut_slave_tx_out = new("dut_slave_tx_out", this); 
    uvm_config_db#(virtual axi_xbar_if)::get(this, "", "axi_xbar_if", xif);
  endfunction

  
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    
    fork
      
      // input ports
      begin
        
      end
      
      // output ports
      begin
        
      end
      
    join
  endtask
  
endclass
