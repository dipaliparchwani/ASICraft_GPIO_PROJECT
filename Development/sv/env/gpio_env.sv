/**********************************************************************************************
*  PROJECT NAME : GPIO VIP                                                                    *
*  FILE NAME    : gpio_env.sv                                                                 *
*  DESCRIPTION  : This is the top-level environment for the GPIO testbench. It instantiates   *
*                 and connects the register agent, GPIO agent, scoreboard, and register model.*
**********************************************************************************************/

class gpio_env extends uvm_env;
  `uvm_component_utils(gpio_env)

  //==========================================
  // Component Instances
  //==========================================
  gpio_reg_agent gr_agent;         // Register interface agent
  gpio_agent     g_agent;          // GPIO pin-level agent
  gpio_reg_block regmodel;         // Register model instance
  gpio_adapter   adapter_inst;     // Adapter to convert reg2bus and bus2reg
  gpio_scoreboard gscb;            // Scoreboard for checking functional correctness

  //==========================================
  // Constructor
  //==========================================
  function new(string name = "gpio_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
 
  //==========================================
  // Build Phase - Create all components
  //==========================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create instances of all components
    gr_agent     = gpio_reg_agent::type_id::create("gr_agent", this);
    g_agent      = gpio_agent::type_id::create("g_agent", this);
    gscb         = gpio_scoreboard::type_id::create("gscb", this);
    regmodel     = gpio_reg_block::type_id::create("regmodel", this);
    adapter_inst = gpio_adapter::type_id::create("adapter_inst", , get_full_name());

    // Build register model
    regmodel.build();

    uvm_config_db#(gpio_reg_block)::set(this, "gscb", "regmodel", regmodel);

  endfunction 
  
  //==========================================
  // Connect Phase - Connect analysis ports and regmodel adapter
  //==========================================
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect register monitor to scoreboard
    gr_agent.grmon.rmon_ap.connect(gscb.reg_imp);

    // Connect GPIO monitor to scoreboard
    g_agent.gmon.gmon_ap.connect(gscb.gpio_imp);

    // Connect register model to register sequencer via adapter
    regmodel.default_map.set_sequencer(
      .sequencer(gr_agent.grseqr),
      .adapter(adapter_inst)
    );

    // Set base address  for register accesses
    regmodel.default_map.set_base_addr(0);
  endfunction 
 
endclass
