/**************************************************************************************************************/
/*---------------------------------------------------------------------------------------------------*/
/*PROJECT_NAME : GPIO VIP                                                                            */           
/*FILE_NAME    : gpio_oe_reg.sv                                                                      */         
/*DESCRIPTION  : Read/Write, Enables output driver for each pin(for tri-state or open drain support).*/
/*CREATED_ON   : 21/07/2025                                                                          */                                                   
/*DEVELOPER    : Dipali                                                                              */
/*---------------------------------------------------------------------------------------------------*/
/**************************************************************************************************************/
`include "uvm_macros.svh"
import uvm_pkg::*;
class gpio_oe_reg extends uvm_reg;
  `uvm_object_utils(gpio_oe_reg)

  rand uvm_reg_field OE;

  function new(string name = "gpio_oe_reg");
    super.new(name,32,UVM_NO_COVERAGE);
  endfunction

  function void build;
     OE = uvm_reg_field::type_id::create("OE");

     OE.configure( .parent(this),
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
