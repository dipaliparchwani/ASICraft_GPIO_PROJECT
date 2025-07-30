//#######################################################################################
//----PROJECT_NAME : GPIO VIP                                                           #
//----FILE_NAME    : gpio_reg_block.sv                                                  #
//----COMPONENT    : REGISTER BLOCK                                                     #  
//----DESCRIPTION  : interface can be re-used for other projects Also it becomes        #
//----               easier to connect with the DUT and other verification components.  #
//----CREATED_ON   : 21/07/2025                                                         #                                             
//----CREATED_BY   : Dipali                                                             #
//#######################################################################################
class gpio_reg_block extends uvm_reg_block;
  `uvm_object_utils(gpio_reg_block);

  gpio_data_in_reg gpio_data_in_reg_inst;
  gpio_intr_status_reg gpio_intr_status_reg_inst;
  rand gpio_data_out_reg gpio_data_out_reg_inst;
  rand gpio_dir_reg gpio_dir_reg_inst;
  rand gpio_intr_mask_reg gpio_intr_mask_reg_inst;
  rand gpio_intr_type_reg gpio_intr_type_reg_inst;
  rand gpio_intr_polarity_reg gpio_intr_polarity_reg_inst;
  rand gpio_oe_reg gpio_oe_reg_inst;

  function new(string name = "gpio_reg_block");
    super.new(name,UVM_NO_COVERAGE);
  endfunction

  function void build;
   gpio_data_in_reg_inst = gpio_data_in_reg::type_id::create("gpio_data_in_reg_inst");
   gpio_data_in_reg_inst.build();
   gpio_data_in_reg_inst.configure(this);

   gpio_data_out_reg_inst = gpio_data_out_reg::type_id::create("gpio_data_out_reg_inst");
   gpio_data_out_reg_inst.build();
   gpio_data_out_reg_inst.configure(this);

   gpio_oe_reg_inst = gpio_oe_reg::type_id::create("gpio_oe_reg_inst");
   gpio_oe_reg_inst.build();
   gpio_oe_reg_inst.configure(this);

   gpio_dir_reg_inst = gpio_dir_reg::type_id::create("gpio_dir_reg_inst");
   gpio_dir_reg_inst.build();
   gpio_dir_reg_inst.configure(this);

   gpio_intr_type_reg_inst = gpio_intr_type_reg::type_id::create("gpio_intr_type_reg_inst");
   gpio_intr_type_reg_inst.build();
   gpio_intr_type_reg_inst.configure(this);

   gpio_intr_polarity_reg_inst = gpio_intr_polarity_reg::type_id::create("gpio_intr_polarity_reg_inst");
   gpio_intr_polarity_reg_inst.build();
   gpio_intr_polarity_reg_inst.configure(this);

   gpio_intr_mask_reg_inst = gpio_intr_mask_reg::type_id::create("gpio_intr_type_reg_inst");
   gpio_intr_mask_reg_inst.build();
   gpio_intr_mask_reg_inst.configure(this);

   gpio_intr_status_reg_inst = gpio_intr_status_reg::type_id::create("gpio_intr_status_reg_inst");
   gpio_intr_status_reg_inst.build();
   gpio_intr_status_reg_inst.configure(this);

    default_map = create_map("default_map",0,(`DATA_WIDTH/8),UVM_LITTLE_ENDIAN);
    default_map.add_reg(gpio_data_in_reg_inst,'h0,"RO");
    default_map.add_reg(gpio_data_out_reg_inst,'h4,"RW");
    default_map.add_reg(gpio_dir_reg_inst,'h8,"RW");
    default_map.add_reg(gpio_oe_reg_inst,'hC,"RW");
    default_map.add_reg(gpio_intr_mask_reg_inst,'h10,"RW");
    default_map.add_reg(gpio_intr_status_reg_inst,'h14,"RO");
    default_map.add_reg(gpio_intr_type_reg_inst,'h18,"RW");
    default_map.add_reg(gpio_intr_polarity_reg_inst,'h1C,"RW");
    
    default_map.set_auto_predict(1);

    lock_model();
  endfunction
endclass
