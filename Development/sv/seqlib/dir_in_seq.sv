class dir_in_seq extends gpio_reg_base_seq;
  `uvm_object_utils(dir_in_seq)

 function new(string name = "dir_in_seq");
    super.new(name);
 endfunction

 task pre_body();
   super.pre_body();
 endtask
 
 task body();
   uvm_status_e status;
   regmodel.gpio_dir_reg_inst.write(status,32'h00000000);
 endtask

 task post_body();
   super.post_body();
 endtask
  
endclass

