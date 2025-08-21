/*******************************************************************************************************/
/*----------------------------------------------------------------------------------------------*/
/* PROJECT_NAME : GPIO VIP                                                                       */           
/* FILE_NAME    : gpio_intr_polarity_reg.sv                                                      */         
/* DESCRIPTION  : Read/Write, Selects between high/rising or low/falling for interrupt detection.*/       
/*----------------------------------------------------------------------------------------------*/
/*******************************************************************************************************/

class gpio_intr_polarity_reg extends uvm_reg;
  `uvm_object_utils(gpio_intr_polarity_reg)
  // Register field declaration (read/write, randomized)
  rand uvm_reg_field INTR_POLARITY;

  // Constructor: Creates the register object
  function new(string name = "gpio_intr_polarity_reg");
    super.new(name, `DATA_WIDTH, UVM_NO_COVERAGE);
  endfunction

  // Build method: Configures the register field
  function void build;
    INTR_POLARITY = uvm_reg_field::type_id::create("INTR_POLARITY");

    INTR_POLARITY.configure(
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

