class gpio_base_test extends uvm_test;
  `uvm_component_utils(gpio_base_test)
 
  function new(input string name = "gpio_base_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
 
  gpio_env genv;
  reset_seq rseq;
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    genv = gpio_env::type_id::create("genv",this);
    rseq = reset_seq::type_id::create("rseq");
  endfunction

  virtual task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    rseq.start(genv.g_agent.gseqr);
    phase.drop_objection(this);
  endtask

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    if (uvm_report_server::get_server().get_severity_count(UVM_ERROR) > 0) begin
      `uvm_info(get_type_name(),"###################################################################################",UVM_NONE)
      `uvm_info(get_type_name(), "###################### TESTCASE FAILED: UVM_ERROR detected. #####################", UVM_NONE)
      `uvm_info(get_type_name(),"###################################################################################",UVM_NONE)
    end
    else begin
      `uvm_info(get_type_name(),"###################################################################################",UVM_NONE)
      `uvm_info(get_type_name(), "######################### TESTCASE PASSED: No UVM_ERROR detected. #####################", UVM_NONE)
      `uvm_info(get_type_name(),"###################################################################################",UVM_NONE)
    end
  endfunction

endclass
 
