class dir_out_seq extends gpio_reg_base_seq;
  `uvm_object_utils(dir_out_seq)
  bit [`DATA_WIDTH-1:0] rdata;
 function new(string name = "dir_out_seq");
    super.new(name);
 endfunction

 task pre_body();
   super.pre_body();
 endtask
 
 task body();
   uvm_status_e status;
   regmodel.gpio_dir_reg_inst.write(status,32'hffffffff);
   `uvm_info("dir_out_seq",$sformatf("value of dir in out case : %0d",rdata),UVM_NONE)
   //regmodel.gpio_dir_reg_inst.read(status,rdata);
   //`uvm_info("dir_out_seq",$sformatf("value of dir in out case : %0d",rdata),UVM_NONE)
 endtask

 task post_body();
   super.post_body();
 endtask
  
endclass

