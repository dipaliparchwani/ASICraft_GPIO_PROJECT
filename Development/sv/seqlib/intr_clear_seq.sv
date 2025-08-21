class intr_clear_seq extends gpio_reg_base_seq;
  `uvm_object_utils(intr_clear_seq)

 function new(string name = "intr_clear_seq");
    super.new(name);
 endfunction

 task pre_body();
   super.pre_body();
 endtask
 
 task body();
   uvm_status_e status;
   regmodel.gpio_intr_status_reg_inst.write(status,32'hffffffff);
 endtask

 task post_body();
   super.post_body();
   @(posedge grvif.clk);
 endtask
  
endclass
