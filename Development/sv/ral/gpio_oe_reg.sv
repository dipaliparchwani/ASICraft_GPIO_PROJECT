/**************************************************************************************************************/
/*---------------------------------------------------------------------------------------------------*/
/* PROJECT_NAME : GPIO VIP                                                                            */           
/* FILE_NAME    : gpio_oe_reg.sv                                                                      */         
/* DESCRIPTION  : Read/Write, Enables output driver for each pin (for tri-state or open drain support). */
/*---------------------------------------------------------------------------------------------------*/
/**************************************************************************************************************/

class gpio_oe_reg extends uvm_reg;
  `uvm_object_utils(gpio_oe_reg)
  // Register field declaration (read/write, randomized)
  rand uvm_reg_field OE;

  // Constructor: Creates the register object
  function new(string name = "gpio_oe_reg");
    super.new(name, `DATA_WIDTH, UVM_NO_COVERAGE);
  endfunction

  // Build method: Configures the register field
  function void build;
    OE = uvm_reg_field::type_id::create("OE");

    OE.configure(
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
