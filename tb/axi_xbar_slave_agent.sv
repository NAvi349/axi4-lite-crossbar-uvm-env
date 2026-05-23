class axi_xbar_slave_agent extends uvm_agent;
  `uvm_component_utils(axi_xbar_slave_agent)
  
  axi_xbar_slave_driver axi_x_m_drvr;
  axi_xbar_slave_monitor axi_x_m_mon;
  axi_xbar_slave_sequencer axi_x_m_sqr;
  
  function new(string name = "axi_xbar_slave_agent", uvm_component parent);
    super.new(name, parent);

  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    axi_x_m_drvr = axi_xbar_slave_driver::type_id::create("axi_x_s_drvr", this);
    axi_x_m_mon  = axi_xbar_slave_monitor::type_id::create("axi_x_s_mon", this);
    axi_x_m_sqr  = axi_xbar_slave_sequencer::type_id::create("axi_x_s_sqr", this);
  endfunction
  
  function void connect_phase (uvm_phase phase);
    axi_x_s_drvr.seq_item_port.connect(axi_x_s_sqr.seq_item_export);
        
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask
  
endclass
