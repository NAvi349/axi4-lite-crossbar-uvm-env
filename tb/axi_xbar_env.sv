/*
Description: AXI Cross environment. This is a multi-agent env as it can be driven from both sides.


*/


class axi_xbar_env extends uvm_env;
  `uvm_component_utils(axi_xbar_env)
  
  axi_xbar_master_agent axi_m_agt; // agent for the master input/slave output
  axi_xbar_slave_agent axi_s_agt;  // agent for the master output/slave input
  axi_xbar_scoreboard axi_x_scbd;  // scoreboard
  
  
  function new(string name = "axi_bar_env", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    // connect analysis ports from master monitors to scoreboard
    // connect analysis ports from slave monitors to scoreboard
  endfunction
  
  
  
endclass
  
