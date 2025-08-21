//***************************************************************************************
//* FILE NAME    : gpio_seqr.sv                                                         *
//* COMPONENT    : GPIO SEQUENCER                                                       *
//* DESCRIPTION  : Coordinates between sequences and the GPIO driver.                   *
//***************************************************************************************

class gpio_seqr extends uvm_sequencer #(gpio_transaction);
  `uvm_component_utils(gpio_seqr)

  //* Constructor: initializes the sequencer with optional name and parent
  function new(string name = "gpio_seqr", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass
