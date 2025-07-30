/*************************************************************************************************/
/*-------------------------------------------------------------------------------------*/
/*PROJECT_NAME : GPIO VIP                                                              */           
/*FILE_NAME    : gpio_dir_reg.sv                                                       */         
/*DESCRIPTION  : Read/Write,Each bit set the direction for a pin(1 = ouput,0 = input)  */       
/*CREATED_ON   : 21/07/2025                                                            */                                                       
/*DEVELOPER    : Dipali                                                                */
/*------------------------------------------------------------------------------------ */
/*************************************************************************************************/
`include "uvm_macros.svh"
import uvm_pkg::*;
class gpio_dir_reg extends uvm_reg;
  `uvm_object_utils(gpio_dir_reg)

  rand uvm_reg_field DIR;

  function new(string name = "gpio_dir_reg");
    super.new(name,32,UVM_NO_COVERAGE);
  endfunction

  function void build;
     DIR = uvm_reg_field::type_id::create("DIR");

     DIR.configure( .parent(this),
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
