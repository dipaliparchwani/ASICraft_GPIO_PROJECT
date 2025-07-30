/******************************************************************************************************************/
/*------------------------------------------------------------------------------------------------------*/
/*PROJECT_NAME : GPIO VIP                                                                               */           
/*FILE_NAME    : gpio_transaction.sv                                                                   */         
/*DESCRIPTION  : Read/Write, value to be driven on output pins(gpio_out) when direction is set to output*/       
/*CREATED_ON   : 22/07/2025                                                                             */                                          
/*DEVELOPER    : Dipali                                                                                 */
/*------------------------------------------------------------------------------------------------------*/
/****************************************************************************************************************/

class gpio_transaction extends uvm_sequence_item;

  rand logic [`DATA_WIDTH-1:0] gpio_in;    // External input to DUT   

  logic [`DATA_WIDTH-1:0] gpio_out;   // Output from DUT   

  logic [`DATA_WIDTH-1:0] gpio_intr;  // Interrupts 

  `uvm_object_utils_begin(gpio_transaction )
  `uvm_field_int(gpio_in,UVM_DEFAULT)
  `uvm_field_int(gpio_out,UVM_DEFAULT)
  `uvm_field_int(gpio_intr,UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "gpio_transaction");
    super.new(name);
  endfunction

endclass

