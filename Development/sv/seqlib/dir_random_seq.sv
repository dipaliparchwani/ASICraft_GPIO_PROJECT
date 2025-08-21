class dir_random_seq extends gpio_reg_base_seq;
  `uvm_object_utils(dir_random_seq)

  rand bit [`DATA_WIDTH-1:0] wdata;

 function new(string name = "dir_random_seq");
    super.new(name);
 endfunction

 task pre_body();
   super.pre_body();
 endtask
 
 task body();
   uvm_status_e status;
   regmodel.gpio_dir_reg_inst.write(status,wdata);
 endtask

 task post_body();
   super.post_body();
 endtask
  
endclass
