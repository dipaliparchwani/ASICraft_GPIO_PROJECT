//***************************************************************************************
//* FILE NAME    : gpio_reg_seqr.sv                                                     *
//* COMPONENT    : GPIO REGISTER SEQUENCER                                              *
//* DESCRIPTION  :Coordinates between sequences and the gpio reg driver.                *
//***************************************************************************************

class gpio_reg_seqr extends uvm_sequencer #(gpio_reg_transaction);
  `uvm_component_utils(gpio_reg_seqr)

  //* Constructor: initializes the sequencer with optional name and parent
  function new(string name = "gpio_reg_seqr", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass
