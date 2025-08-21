class gpio_base_test extends uvm_test;
  `uvm_component_utils(gpio_base_test)
 
  function new(input string name = "gpio_base_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
 
  gpio_env genv;
  //reset_seq rseq;
  gpio_test_cfg tcfg;
  virtual gpio_if gvif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual gpio_if)::get(null, "tb.gif", "gvif", gvif))
      `uvm_error(get_full_name(), "Error getting Interface Handle")
    genv = gpio_env::type_id::create("genv",this);
    tcfg = gpio_test_cfg::type_id::create("tcfg",this);
    if($value$plusargs("no_of_in_tx=%0d",tcfg.no_of_in_tx))
      `uvm_info(get_type_name(),$sformatf("no_of_in_tx : %0d",tcfg.no_of_in_tx),UVM_LOW)
    if($value$plusargs("no_of_out_tx=%0d",tcfg.no_of_out_tx))
      `uvm_info(get_type_name(),$sformatf("no_of_out_tx : %0d",tcfg.no_of_out_tx),UVM_LOW)
    uvm_config_db#(gpio_test_cfg)::set(null,"*","tcfg",tcfg);
  endfunction

  /*virtual task run_phase(uvm_phase phase);
    bseq.regmodel = genv.regmodel;
    rbseq.regmodel = genv.regmodel;
  endtask*/

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    if (uvm_report_server::get_server().get_severity_count(UVM_ERROR) > 0) begin
      `uvm_info(get_type_name(),"###################################################################################",UVM_NONE)
      `uvm_info(get_type_name(), "###################### TESTCASE FAILED #####################", UVM_NONE)
      `uvm_info(get_type_name(),"###################################################################################",UVM_NONE)
    end
    else begin
      `uvm_info(get_type_name(),"###################################################################################",UVM_NONE)
      `uvm_info(get_type_name(), "######################### TESTCASE PASSED #####################", UVM_NONE)
      `uvm_info(get_type_name(),"###################################################################################",UVM_NONE)
    end
  endfunction

  virtual task shutdown_phase(uvm_phase phase); 
    repeat(2)
      @(posedge gvif.clk);
  endtask

endclass
 
