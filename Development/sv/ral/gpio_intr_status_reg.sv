/*********************************************************************************************************************/
/*------------------------------------------------------------------------------------------------------------*/
/* PROJECT_NAME : GPIO VIP                                                                                     */           
/* FILE_NAME    : gpio_intr_status_reg.sv                                                                      */         
/* DESCRIPTION  : Read/Write-Clear, Indicates which pins have pending interrupt. Writing 1 clears the interrupt*/       
/*------------------------------------------------------------------------------------------------------------*/
/*********************************************************************************************************************/

class gpio_intr_status_reg extends uvm_reg;
  `uvm_object_utils(gpio_intr_status_reg)
  // Register field declaration (write-1-to-clear, non-random)
  uvm_reg_field INTR_STATUS;

  // Constructor: Creates the register object
  function new(string name = "gpio_intr_status_reg");
    super.new(name, `DATA_WIDTH, UVM_NO_COVERAGE);
  endfunction

  // Build method: Configures the register field
  function void build;
    INTR_STATUS = uvm_reg_field::type_id::create("INTR_STATUS");

    INTR_STATUS.configure(
      .parent(this),
      .size(`DATA_WIDTH),
      .lsb_pos(0),
      .access("W1C"),
      .volatile(1),
      .reset(0),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(1)
    );
  endfunction

endclass

