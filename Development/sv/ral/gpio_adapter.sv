//#######################################################################################
//----PROJECT_NAME : GPIO VIP                                                           #
//----FILE_NAME    : gpio_adapter.sv                                                    #
//----COMPONENT    : GPIO ADAPTER                                                      #  
//----DESCRIPTION  : interface can be re-used for other projects Also it becomes        #
//----               easier to connect with the DUT and other verification components.  #
//----CREATED_ON   : 21/07/2025                                                         #                                             
//----CREATED_BY   : Dipali                                                             #
//#######################################################################################
class gpio_adapter extends uvm_reg_adapter;
  `uvm_object_utils(gpio_adapter)

  //----------------------------------------
  // constructor
  // ---------------------------------------
  function new(string name = "gpio_adapter");
    super.new(name);
  endfunction

  //--------------------------------------------------------------
  // reg2bus method
  //--------------------------------------------------------------
  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    gpio_reg_transaction tr;
    tr = gpio_reg_transaction::type_id::create("tr");
    tr.WRITE = (rw.kind == UVM_WRITE) ? 1'b1 : 1'b0;
    tr.ADDRESS = rw.addr;

   tr.WDATA = (tr.WRITE == 1'b1) ?  rw.data : 32'h00000000;
   
    $display("hello adapter : %0d",tr.WDATA);
    return tr;
  endfunction

  //----------------------------------------------------------------------
  // bus2reg method
  //----------------------------------------------------------------------
  function void bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);
    gpio_reg_transaction tr;
    assert($cast(tr,bus_item));

    rw.kind = (tr.WRITE == 1'b1) ? UVM_WRITE : UVM_READ;
    rw.data = (tr.WRITE == 1'b1) ? tr.WDATA : tr.RDATA;
    rw.addr = tr.ADDRESS;
    rw.status = UVM_IS_OK;
  endfunction
endclass
