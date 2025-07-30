/******************************************************************************************************/
/*----------------------------------------------------------------------------------------------------*/
/*PROJECT_NAME : GPIO VIP                                                                             */           
/*FILE_NAME    : gpio_intr_type_reg.sv                                                                */         
/*DESCRIPTION  : Read/Write, Selects between level-sensitive or edge-sensitive interrupt for each pin.*/
/*CREATED_ON   : 21/07/2025                                                                           */                                                  
/*DEVELOPER    : Dipali                                                                               */
/*--------------------------------------------------------------------------------------------------- */
/******************************************************************************************************/
`include "uvm_macros.svh"
import uvm_pkg::*;
class gpio_intr_type_reg extends uvm_reg;
  `uvm_object_utils(gpio_intr_type_reg)

  rand uvm_reg_field INTR_TYPE;

  function new(string name = "gpio_intr_type_reg");
    super.new(name,32,UVM_NO_COVERAGE);
  endfunction

  function void build;
     INTR_TYPE = uvm_reg_field::type_id::create("INTR_TYPE");

     INTR_TYPE.configure( .parent(this),
                        .size(`DATA_WIDTH),
			.lsb_pos(0),
			.access("RW"),
			.volatile(0),
			.reset(0),
			.has_reset(1),
			.is_rand(1),
			.individually_accessible(1));
  endfunction
endclass
