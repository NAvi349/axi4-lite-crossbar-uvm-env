/* Description: 



*/

class axi_xbar_scoreboard extends uvm_scoreboard;
 `uvm_component_utils(axi_xbar_scoreboard)
  
  
  
  function new(string name = "axi_xbar_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);    
  endfunction: build_phase
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
  endtask: run_phase
  
endclass
