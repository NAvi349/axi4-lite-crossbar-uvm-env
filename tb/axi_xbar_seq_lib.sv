
typedef uvm_sequencer #(axi_xbar_item) axi_xbar_master_sequencer;
typedef uvm_sequencer #(axi_xbar_item) axi_xbar_slave_sequencer;

// Sequence used for master input/slave output
class axi_xbar_master_sequence extends uvm_sequence();
  
  axi_xbar_item axi_m_tx;
  
 `uvm_object_utils(axi_xbar_master_sequence)
 
  function new(string name = "axi_xbar_master_sequence");
    super.new(name);
  endfunction: new
  
  
  task body();
   
    axi_m_tx = axi_xbar_item::type_id::create("axi_m_tx");
    
    // send addr + data in single sequence item
    `uvm_info(get_full_name(), "Masterside item", UVM_LOW)
    start_item(axi_m_tx);  // request grant
               
    axi_m_tx.randomize();
    
    finish_item(axi_m_tx);
    
  endtask
  
  
endclass: axi_xbar_master_sequence

//Sequence used for slave input/master output
class axi_xbar_slave_sequence extends uvm_sequence();
  
  axi_xbar_item axi_s_tx;
  
 `uvm_object_utils(axi_xbar_slave_sequence)
  
  function new(string name = "axi_xbar_slave_sequence");
    super.new(name);
  endfunction: new
  
  
  task body();
    
    // send ready for valid 
    
    start_item(axi_s_tx);
    
    axi_s_tx.randomize();
    
    finish_item(axi_s_tx);
    
  endtask
  
endclass: axi_xbar_slave_sequence

