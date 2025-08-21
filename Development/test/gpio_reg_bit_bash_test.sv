class gpio_reg_bit_bash_test extends gpio_base_test;
  `uvm_component_utils(gpio_reg_bit_bash_test)
 
  uvm_reg_bit_bash_seq rbseq;

  function new(input string name = "gpio_reg_bit_bash_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rbseq = uvm_reg_bit_bash_seq::type_id::create("rbseq");
  endfunction
 
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rbseq.model =  genv.regmodel;
    `uvm_info(get_type_name(),"before seq start",UVM_HIGH);
     rbseq.start(genv.gr_agent.grseqr);
    `uvm_info(get_full_name(),"after seq start",UVM_HIGH);
    phase.drop_objection(this);
  endtask

  virtual task shutdown_phase(uvm_phase phase);
    super.shutdown_phase(phase);
  endtask


  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
  endfunction


endclass

