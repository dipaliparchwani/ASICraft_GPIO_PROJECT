/*********************************************************************************************************************/
/*------------------------------------------------------------------------------------------------------------*/
/*PROJECT_NAME : GPIO VIP                                                                                     */           
/*FILE_NAME    : gpio_intr_status_reg.sv                                                                      */         
/*DESCRIPTION  : Read/Write-Clear, Indicates which pins have pending interrupt. Writing 1 clears the interrupt*/       
/*CREATED_ON   : 21/07/2025                                                                                   */                                          
/*DEVELOPER    : Dipali                                                                                       */
/*------------------------------------------------------------------------------------------------------------*/
/**********************************************************************************************************************/
`include "uvm_macros.svh"
import uvm_pkg::*;
class gpio_intr_status_reg extends uvm_reg;
  `uvm_object_utils(gpio_intr_status_reg)

  uvm_reg_field INTR_STATUS;

  function new(string name = "gpio_intr_status_reg");
    super.new(name,32,UVM_NO_COVERAGE);
  endfunction

  function void build;
     INTR_STATUS = uvm_reg_field::type_id::create("INTR_STATUS");

     INTR_STATUS.configure( .parent(this),
                        .size(`DATA_WIDTH),
			.lsb_pos(0),
			.access("RO"),
			.volatile(0),
			.reset(0),
			.has_reset(1),
			.is_rand(0),
			.individually_accessible(1));
  endfunction
endclass
