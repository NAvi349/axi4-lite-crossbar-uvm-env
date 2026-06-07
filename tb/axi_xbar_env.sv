/*
Description: AXI Cross environment. This is a multi-agent env as it can be driven from both sides.
*/


class axi_xbar_env extends uvm_env;
  `uvm_component_utils(axi_xbar_env)
  
  axi_xbar_master_agent axi_m_agt; // agent for the master input/slave output
  axi_xbar_slave_agent axi_s_agt;  // agent for the master output/slave input
  axi_xbar_scoreboard axi_x_scbd;  // scoreboard
  
  
  function new(string name = "axi_xbar_env", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    axi_m_agt = axi_xbar_master_agent::type_id::create("axi_m_agt", this);
    axi_s_agt = axi_xbar_slave_agent::type_id::create("axi_s_agt", this);
    axi_x_scbd = axi_xbar_scoreboard::type_id::create("axi_x_scbd", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    // connect analysis ports from master monitors to scoreboard
    // connect analysis ports from slave monitors to scoreboard
    
    axi_m_agt.axi_x_m_mon.dut_m_tx_in.connect(axi_x_scbd.m_tx_in_fifo.analysis_export);
    axi_m_agt.axi_x_m_mon.dut_m_tx_out.connect(axi_x_scbd.m_tx_out_fifo.analysis_export);
    axi_s_agt.axi_x_s_mon.dut_slave_tx_in.connect(axi_x_scbd.s_tx_in_fifo.analysis_export);
    axi_s_agt.axi_x_s_mon.dut_slave_tx_out.connect(axi_x_scbd.s_tx_out_fifo.analysis_export);
    
  
  endfunction
  
  
  
endclass
  
