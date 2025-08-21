class intr_random_seq extends gpio_reg_base_seq;
  `uvm_object_utils(intr_random_seq)

  rand bit [`DATA_WIDTH-1:0] type_data,polarity_data,mask_data;

 function new(string name = "intr_random_seq");
    super.new(name);
 endfunction

 task pre_body();
   super.pre_body();
 endtask
 
 task body();
   uvm_status_e status;
   regmodel.gpio_intr_type_reg_inst.write(status,type_data);
   regmodel.gpio_intr_polarity_reg_inst.write(status,polarity_data);
   regmodel.gpio_intr_mask_reg_inst.write(status,mask_data);
 endtask

 task post_body();
   super.post_body();
 endtask
  
endclass
