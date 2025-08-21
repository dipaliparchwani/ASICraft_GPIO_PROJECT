/*************************************************************************************************/
/*-----------------------------------------------------------------------------------------------*/
/* PROJECT_NAME : GPIO VIP                                                                       */           
/* FILE_NAME    : gpio_dir_reg.sv                                                                */         
/* DESCRIPTION  : Read/Write, Each bit sets the direction for a pin (1 = output, 0 = input)      */       
/*-----------------------------------------------------------------------------------------------*/
/*************************************************************************************************/

class gpio_dir_reg extends uvm_reg;
  `uvm_object_utils(gpio_dir_reg)

  // Register field declaration (read/write, randomized)
  rand uvm_reg_field DIR;

  // Constructor: Creates the register object
  function new(string name = "gpio_dir_reg");
    super.new(name, `DATA_WIDTH, UVM_NO_COVERAGE);
  endfunction

  // Build method: Configures the register field
  function void build;
    DIR = uvm_reg_field::type_id::create("DIR");

    DIR.configure(
      .parent(this),
      .size(`DATA_WIDTH),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
  endfunction

endclass

