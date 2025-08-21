/******************************************************************************************************************/
/*------------------------------------------------------------------------------------------------------*/
/* PROJECT_NAME : GPIO VIP                                                                             */           
/* FILE_NAME    : gpio_data_out_reg.sv                                                                 */         
/* DESCRIPTION  : Read/Write, value to be driven on output pins (gpio_out) when direction is set to output */       
/*------------------------------------------------------------------------------------------------------*/
/******************************************************************************************************************/

class gpio_data_out_reg extends uvm_reg;
  `uvm_object_utils(gpio_data_out_reg)
  // Register field declaration (read/write, randomized)
  rand uvm_reg_field DATA_OUT;

  // Constructor: Creates the register object
  function new(string name = "gpio_data_out_reg");
    super.new(name, `DATA_WIDTH, UVM_NO_COVERAGE);
  endfunction

  // Build method: Configures the register field
  function void build;
    DATA_OUT = uvm_reg_field::type_id::create("DATA_OUT");

    DATA_OUT.configure(
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

