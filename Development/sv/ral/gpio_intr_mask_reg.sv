/************************************************************************************************/
/*-------------------------------------------------------------------------------------*/
/*PROJECT_NAME : GPIO VIP                                                              */           
/*FILE_NAME    : gpio_intr_mask_reg.sv                                                 */         
/*DESCRIPTION  : Read/Write, Enables or disables interrupt generation for each pin     */       
/*CREATED_ON   : 21/07/2025                                                            */                                                       
/*DEVELOPER    : Dipali                                                                */
/*------------------------------------------------------------------------------------ */
/************************************************************************************************/
`include "uvm_macros.svh"
import uvm_pkg::*;
class gpio_intr_mask_reg extends uvm_reg;
  `uvm_object_utils(gpio_intr_mask_reg)

  rand uvm_reg_field INTR_MASK;

  function new(string name = "gpio_intr_mask_reg");
    super.new(name,32,UVM_NO_COVERAGE);
  endfunction

  function void build;
     INTR_MASK = uvm_reg_field::type_id::create("INTR_MASK");

     INTR_MASK.configure( .parent(this),
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
