/******************************************************************************************************************/
/*------------------------------------------------------------------------------------------------------*/
/*PROJECT_NAME : GPIO VIP                                                                               */           
/*FILE_NAME    : gpio_reg_transaction.sv                                                                   */         
/*DESCRIPTION  : Read/Write, value to be driven on output pins(gpio_out) when direction is set to output*/       
/*CREATED_ON   : 22/07/2025                                                                             */                                                
/*DEVELOPER    : Dipali                                                                                 */
/*------------------------------------------------------------------------------------------------------*/
/******************************************************************************************************************/

class gpio_reg_transaction extends uvm_sequence_item;

    rand logic [`ADDR_WIDTH-1 : 0] ADDRESS;
    rand logic [`DATA_WIDTH-1 : 0] WDATA;
    logic [`DATA_WIDTH-1 : 0]RDATA;
    rand logic WRITE;
  
  `uvm_object_utils_begin(gpio_reg_transaction )
  `uvm_field_int(ADDRESS,UVM_DEFAULT)
  `uvm_field_int(WDATA,UVM_DEFAULT)
  `uvm_field_int(RDATA,UVM_DEFAULT)
  `uvm_field_int(WRITE,UVM_DEFAULT)
  `uvm_object_utils_end
   
  
    function new(string name = "gpio_reg_transaction");
       super.new(name);
    endfunction 
  
    constraint addr_ctrl { 
      ADDRESS inside {'h0, 'h4, 'h8, 'hC, 'h10, 'h14, 'h18, 'h1C};
    }
 
endclass 
