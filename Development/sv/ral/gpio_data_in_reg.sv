/******************************************************************************************/
/*----------------------------------------------------------------------------------------*/
/* PROJECT_NAME : GPIO VIP                                                               */           
/* FILE_NAME    : gpio_data_in_reg.sv                                                        */         
/* DESCRIPTION  : Read-only, Reflects the current state of the physical pins             */       
/*----------------------------------------------------------------------------------------*/
/******************************************************************************************/

class gpio_data_in_reg extends uvm_reg;
  `uvm_object_utils(gpio_data_in_reg)

  // Register field declaration
  uvm_reg_field DATA_IN;

  // Constructor: Initializes register with no coverage
  function new(string name = "gpio_data_in_reg");
    super.new(name, `DATA_WIDTH, UVM_NO_COVERAGE);
  endfunction

  // Build method: Defines the register field properties
  function void build;
    DATA_IN = uvm_reg_field::type_id::create("DATA_IN");

    DATA_IN.configure(
      .parent(this),
      .size(`DATA_WIDTH),
      .lsb_pos(0),
      .access("RO"),
      .volatile(0),
      .reset(0),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(1)
    );
  endfunction

endclass

