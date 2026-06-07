/* Description: 
The scoreboard will have four ports.

It will receive the transactions from both master and slave side monitors.


*/

class axi_xbar_scoreboard extends uvm_scoreboard;
 `uvm_component_utils(axi_xbar_scoreboard)
  
  uvm_tlm_analysis_fifo #(axi_xbar_item) m_tx_in_fifo;
  uvm_tlm_analysis_fifo #(axi_xbar_item) m_tx_out_fifo;
  uvm_tlm_analysis_fifo #(axi_xbar_item) s_tx_in_fifo;
  uvm_tlm_analysis_fifo #(axi_xbar_item) s_tx_out_fifo;
  
  function new(string name = "axi_xbar_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_tx_in_fifo = new("m_tx_in_fifo", this);
    m_tx_out_fifo = new("m_tx_out_fifo", this);
    s_tx_in_fifo = new("s_tx_in_fifo", this);
    s_tx_out_fifo = new("s_tx_out_fifo", this);
  endfunction: build_phase
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
  endtask: run_phase
  
endclass
