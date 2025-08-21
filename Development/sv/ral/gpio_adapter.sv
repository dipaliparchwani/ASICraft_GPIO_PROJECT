//#######################################################################################
//----PROJECT_NAME : GPIO VIP                                                           #
//----FILE_NAME    : gpio_adapter.sv                                                    #
//----COMPONENT    : GPIO ADAPTER                                                       #  
//----DESCRIPTION  : used for transaction conversion.                                   #
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
  // reg2bus method : Converts register operations to bus transactions.
  //--------------------------------------------------------------
  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    gpio_reg_transaction tr;
    tr = gpio_reg_transaction::type_id::create("tr");
    tr.WRITE = (rw.kind == UVM_WRITE) ? 1'b1 : 1'b0;
  //  tr.WDATA = (rw.kind == UVM_WRITE) ? rw.data : tr.WDATA;
   // tr.RDATA = (rw.kind == UVM_WRITE) ? 'h0 : rw.data;
    if(tr.WRITE) begin
      tr.WDATA = rw.data;
    end
    else begin
      tr.RDATA = rw.data;
    end
    tr.ADDRESS = rw.addr;
    `uvm_info("Adapter",$sformatf("wdata= %0h, rdata= %0h, write= %0h,addres= %0h",tr.WDATA,tr.RDATA,tr.WRITE,tr.ADDRESS),UVM_NONE)
    return tr;
  endfunction

  //----------------------------------------------------------------------

  // bus2reg method : Converts bus responses back to register operations.
  //----------------------------------------------------------------------
  function void bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);
    gpio_reg_transaction tr;
    assert($cast(tr,bus_item));

    rw.kind = (tr.WRITE) ? UVM_WRITE : UVM_READ;
    rw.data = (tr.WRITE) ? tr.WDATA : tr.RDATA;
    rw.addr = tr.ADDRESS;
    rw.status = UVM_IS_OK;
    `uvm_info("Adapter",$sformatf("data= %0h write= %0h,addres= %0h",rw.data,rw.kind,rw.addr),UVM_NONE)
  endfunction
endclass
