/*
Description: This is the monitor for master input/slave output.
There are two monitors here for both input (master) and output (slave).

Implementation plan:
1. Analysis port for scoreboard
2. get inputs of dut task
3. forever loop is used for monitor as it will act on
4. It gets the signals from dut and send to scoreboard through the analysis port

*/


class axi_xbar_master_monitor extends uvm_monitor;
 `uvm_component_utils(axi_xbar_master_monitor)
  
  virtual axi_xbar_if xif;
  
  uvm_analysis_port #(axi_xbar_item) dut_m_tx_in;
  uvm_analysis_port #(axi_xbar_item) dut_m_tx_out;
  
  axi_xbar_item axi_m_tx_in;
  axi_xbar_item axi_m_tx_out;
  
  function new(string name = "axi_xbar_master_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    dut_m_tx_in = new("dut_m_tx_in", this);
    dut_m_tx_out = new("dut_m_tx_out", this);
    uvm_config_db#(virtual axi_xbar_if)::get(this, "", "axi_xbar_if", xif);
  endfunction
  
  task run_phase(uvm_phase phase);
    
    fork
    
      begin // input dut trx
        forever begin
          //create seq item
          axi_m_tx_in = axi_xbar_item::type_id::create("axi_m_tx_in", this);
          get_dut_inputs();
          dut_m_tx_in.write(axi_m_tx_in);
        end
      end
      
      begin // output dut trx
        forever begin
          axi_m_tx_out = axi_xbar_item::type_id::create("axi_m_tx_out", this);
          get_dut_outputs();
          dut_m_tx_out.write(axi_m_tx_out);
        end
      end
    join
    
  endtask
  
  task get_dut_inputs();
    @(posedge xif.clock);
    //axi_m_tx_in <= vif.cb_m.
  endtask
  
  task get_dut_outputs();
    
  endtask
  
endclass
