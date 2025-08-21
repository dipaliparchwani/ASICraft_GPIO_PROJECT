/******************************************************************************************************************/
/*------------------------------------------------------------------------------------------------------*/
/*PROJECT_NAME : GPIO VIP                                                                               */           
/*FILE_NAME    : gpio_transaction.sv                                                                    */         
/*DESCRIPTION  : GPIO input/output transaction class with input pattern generation constraints          */       
/*CREATED_ON   : 22/07/2025                                                                             */                                          
/*DEVELOPER    : Dipali                                                                                 */
/*------------------------------------------------------------------------------------------------------*/
/****************************************************************************************************************/

class gpio_transaction extends uvm_sequence_item;
  rand logic [`DATA_WIDTH-1:0] gpio_in;    
       logic [`DATA_WIDTH-1:0] gpio_out;   
       logic [`DATA_WIDTH-1:0] gpio_intr;

  // Index driven from sequence for walking patterns
  int pattern_index;

  typedef enum {
    WALKING_0,
    WALKING_1,
    WALKING_A,
    WALKING_5,
    INCREMENT,
    DECREMENT,
    ALT_0_1
  } gpio_pattern_e;

  rand gpio_pattern_e pattern_sel;

  static int total_txn = 32;

  `uvm_object_utils_begin(gpio_transaction)
    `uvm_field_int(gpio_in, UVM_DEFAULT)
    `uvm_field_int(gpio_out, UVM_DEFAULT)
    `uvm_field_int(gpio_intr, UVM_DEFAULT)
    `uvm_field_int(pattern_index, UVM_DEFAULT)
    `uvm_field_enum(gpio_pattern_e, pattern_sel, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "gpio_transaction");
    super.new(name);
  endfunction

  // Constraints using pattern_index instead of txn_count
  constraint walk_1_c {
    (pattern_sel == WALKING_1) ->
      gpio_in == (32'b1 << (pattern_index % `DATA_WIDTH));
  }

  constraint walk_0_c {
    (pattern_sel == WALKING_0) ->
      gpio_in == ~(32'b1 << (pattern_index % `DATA_WIDTH)) & ((1 << `DATA_WIDTH) - 1);
  }

  constraint walking_a_c {
    (pattern_sel == WALKING_A) ->
      gpio_in == ((4'hA << ((pattern_index * 4) % `DATA_WIDTH)) & ((1 << `DATA_WIDTH) - 1));
  }

  constraint walking_5_c {
    (pattern_sel == WALKING_5) ->
      gpio_in == ((4'h5 << ((pattern_index * 4) % `DATA_WIDTH)) & ((1 << `DATA_WIDTH) - 1));
  }

  constraint incr_c {
    (pattern_sel == INCREMENT) ->
      gpio_in == pattern_index;
  }

  constraint decr_c {
    (pattern_sel == DECREMENT) ->
      gpio_in == (total_txn - pattern_index - 1);
  }

  constraint alt_c {
    (pattern_sel == ALT_0_1) ->
      gpio_in == (pattern_index % 2 == 0 ? {(`DATA_WIDTH/2){2'b10}} : {(`DATA_WIDTH/2){2'b01}});
  }
endclass

