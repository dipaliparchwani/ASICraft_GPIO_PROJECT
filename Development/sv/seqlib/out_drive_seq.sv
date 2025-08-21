class out_drive_seq extends gpio_reg_base_seq;
  `uvm_object_utils(out_drive_seq)

  rand bit [`DATA_WIDTH-1:0] wdata;

 function new(string name = "out_drive_seq");
    super.new(name);
 endfunction

 task pre_body();
   super.pre_body();
 endtask
 
 task body();
   uvm_status_e status;
   repeat(tcfg.no_of_out_tx) begin
     assert(this.randomize());
     regmodel.gpio_data_out_reg_inst.write(status,wdata);
   end
 endtask

 task post_body();
   super.post_body();
 endtask
  
endclass

