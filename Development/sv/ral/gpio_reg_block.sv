//############################################################################################
//----PROJECT_NAME : GPIO VIP                                                                #
//----FILE_NAME    : gpio_reg_block.sv                                                       #
//----COMPONENT    : REGISTER BLOCK                                                          #
//----DESCRIPTION  : This register block encapsulates all GPIO control and status registers. #
//----               It includes direction, data, output enable, and interrupt-related regs. #
//----               Provides address mapping,  and supports auto prediction.                #
//############################################################################################

class gpio_reg_block extends uvm_reg_block;
  `uvm_object_utils(gpio_reg_block)
  // Register Instances
  gpio_data_in_reg           gpio_data_in_reg_inst;
  gpio_intr_status_reg       gpio_intr_status_reg_inst;
  rand gpio_data_out_reg     gpio_data_out_reg_inst;
  rand gpio_dir_reg          gpio_dir_reg_inst;
  rand gpio_intr_mask_reg    gpio_intr_mask_reg_inst;
  rand gpio_intr_type_reg    gpio_intr_type_reg_inst;
  rand gpio_intr_polarity_reg gpio_intr_polarity_reg_inst;
  //rand gpio_oe_reg           gpio_oe_reg_inst;

  // Constructor
  function new(string name = "gpio_reg_block");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

  // Build Method
  function void build;
    
    add_hdl_path("tb.dut", "RTL"); // design instance which is taken in top,RTL

    //==================== Register: GPIO_DATA_IN (Read-Only) ====================
    gpio_data_in_reg_inst = gpio_data_in_reg::type_id::create("gpio_data_in_reg_inst");
    gpio_data_in_reg_inst.build();
    gpio_data_in_reg_inst.configure(this);
    gpio_data_in_reg_inst.add_hdl_path_slice("data_in",0,`DATA_WIDTH); // register name as per design,starting position,no.of bits

    //==================== Register: GPIO_DATA_OUT (Read/Write) ====================
    gpio_data_out_reg_inst = gpio_data_out_reg::type_id::create("gpio_data_out_reg_inst");
    gpio_data_out_reg_inst.build();
    gpio_data_out_reg_inst.configure(this);
    gpio_data_out_reg_inst.add_hdl_path_slice("data_out_reg",0,`DATA_WIDTH);

    //==================== Register: GPIO_OE (Output Enable) ====================
   // gpio_oe_reg_inst = gpio_oe_reg::type_id::create("gpio_oe_reg_inst");
    //gpio_oe_reg_inst.build();
    //gpio_oe_reg_inst.configure(this);

    //==================== Register: GPIO_DIR (Direction Control) ====================
    gpio_dir_reg_inst = gpio_dir_reg::type_id::create("gpio_dir_reg_inst");
    gpio_dir_reg_inst.build();
    gpio_dir_reg_inst.configure(this);
    gpio_dir_reg_inst.add_hdl_path_slice("data_dir_reg",0,`DATA_WIDTH);

    //==================== Register: GPIO_INTR_TYPE (Edge/Level Interrupt Type) ====================
    gpio_intr_type_reg_inst = gpio_intr_type_reg::type_id::create("gpio_intr_type_reg_inst");
    gpio_intr_type_reg_inst.build();
    gpio_intr_type_reg_inst.configure(this);
    gpio_intr_type_reg_inst.add_hdl_path_slice("INTR_TYPE_REG",0,`DATA_WIDTH);

    //==================== Register: GPIO_INTR_POLARITY (Interrupt Polarity) ====================
    gpio_intr_polarity_reg_inst = gpio_intr_polarity_reg::type_id::create("gpio_intr_polarity_reg_inst");
    gpio_intr_polarity_reg_inst.build();
    gpio_intr_polarity_reg_inst.configure(this);
    gpio_intr_polarity_reg_inst.add_hdl_path_slice("INTR_POLARITY_REG",0,`DATA_WIDTH);

    //==================== Register: GPIO_INTR_MASK (Interrupt Mask) ====================
    gpio_intr_mask_reg_inst = gpio_intr_mask_reg::type_id::create("gpio_intr_mask_reg_inst");
    gpio_intr_mask_reg_inst.build();
    gpio_intr_mask_reg_inst.configure(this);
    gpio_intr_mask_reg_inst.add_hdl_path_slice("INTR_MASK_REG",0,`DATA_WIDTH);

    //==================== Register: GPIO_INTR_STATUS (Interrupt Status - W1C) ====================
    gpio_intr_status_reg_inst = gpio_intr_status_reg::type_id::create("gpio_intr_status_reg_inst");
    gpio_intr_status_reg_inst.build();
    gpio_intr_status_reg_inst.configure(this);
    gpio_intr_status_reg_inst.add_hdl_path_slice("INTR_STATAUS",0,`DATA_WIDTH);

    //==================== Register Map Creation ====================
    default_map = create_map("default_map", 0, (`DATA_WIDTH/8), UVM_LITTLE_ENDIAN);
    
    default_map.add_reg(gpio_data_in_reg_inst,       'h00, "RO");
    default_map.add_reg(gpio_data_out_reg_inst,      'h04, "RW");
    default_map.add_reg(gpio_dir_reg_inst,           'h08, "RW");
    //default_map.add_reg(gpio_oe_reg_inst,            'h0C, "RW");
    default_map.add_reg(gpio_intr_mask_reg_inst,     'h10, "RW");
    default_map.add_reg(gpio_intr_status_reg_inst,   'h14, "W1C");
    default_map.add_reg(gpio_intr_type_reg_inst,     'h18, "RW");
    default_map.add_reg(gpio_intr_polarity_reg_inst, 'h1C, "RW");

    //==================== Enable Auto Prediction ====================
    default_map.set_auto_predict(1);

    //==================== Lock the Register Model ====================
    lock_model();
  endfunction

endclass
