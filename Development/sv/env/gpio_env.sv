class gpio_env extends uvm_env;
  `uvm_component_utils(gpio_env)

  gpio_reg_agent gr_agent;
  gpio_agent g_agent;
  gpio_reg_block regmodel;
  gpio_adapter adapter_inst;
  gpio_scoreboard gscb;

  function new(string name = "gpio_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
 
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gr_agent = gpio_reg_agent::type_id::create("gr_agent", this);
    g_agent  = gpio_agent::type_id::create("g_agent", this);
    gscb     = gpio_scoreboard::type_id::create("gscb",this);
    regmodel = gpio_reg_block::type_id::create("regmodel", this);
    regmodel.build();
    adapter_inst = gpio_adapter::type_id::create("adapter_inst",, get_full_name());
    
  endfunction 
  
 
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    gr_agent.grmon.rmon_ap.connect(gscb.reg_imp);
    g_agent.gmon.gmon_ap.connect(gscb.gpio_imp);
    regmodel.default_map.set_sequencer( .sequencer(gr_agent.grseqr), .adapter(adapter_inst) );
    regmodel.default_map.set_base_addr(0);
    
  endfunction 
 
endclass
