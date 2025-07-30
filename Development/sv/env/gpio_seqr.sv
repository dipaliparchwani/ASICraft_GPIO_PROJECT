class gpio_seqr extends uvm_sequencer #(gpio_transaction);
  `uvm_component_utils(gpio_seqr)

  function new(string name = "gpio_seqr",uvm_component parent = null);
    super.new(name,parent);
  endfunction

endclass
