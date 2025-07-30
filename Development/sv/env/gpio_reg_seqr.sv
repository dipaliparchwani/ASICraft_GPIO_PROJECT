class gpio_reg_seqr extends uvm_sequencer #(gpio_reg_transaction);
  `uvm_component_utils(gpio_reg_seqr)

  function new(string name = "gpio_reg_seqr",uvm_component parent = null);
    super.new(name,parent);
  endfunction

endclass
