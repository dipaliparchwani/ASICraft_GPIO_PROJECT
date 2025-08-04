class gpio_monitor extends uvm_monitor;
  `uvm_component_utils(gpio_monitor)
  
  virtual gpio_if gvif;
  uvm_analysis_port #(gpio_transaction) gmon_ap;

  function new(string name="gpio_monitor",uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase (phase);
    gmon_ap = new("gmon_ap", this);
    if(! uvm_config_db#(virtual gpio_if)::get (null, "tb.gif", "gvif", gvif))
      `uvm_error("GPIO_MON", "Error getting Interface Handle")
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      gpio_transaction mtr = gpio_transaction::type_id::create("mtr");
      @(gvif.clk );
      @(gvif.gpio_in or gvif.gpio_out or gvif.gpio_intr);
      mtr.gpio_in   = gvif.gpio_in;
      mtr.gpio_out  = gvif.gpio_out;
      mtr.gpio_intr = gvif.gpio_intr;
      if(!($isunknown(mtr.gpio_in) || $isunknown(mtr.gpio_out) || $isunknown(mtr.gpio_intr))) begin
        gmon_ap.write(mtr);
      end

      `uvm_info(get_full_name(),$sformatf("[%0t] : value of gpio_in : %0h, gpio_out : %0h, gpio_intr : %0h",$time,mtr.gpio_in,mtr.gpio_out,mtr.gpio_intr),UVM_NONE)

      
      //---------------------------------------------------------------------------------
      //-------------------------------- CHECKERS ---------------------------------------
      //---------------------------------------------------------------------------------
      
      // ######################  RESET CHECKER #######################
      if(!gvif.rst_n )
	if(((mtr.gpio_in || mtr.gpio_out || mtr.gpio_intr) != 0))
	  `uvm_error("GPIO_MON","############## RESET CONDITION IS FAILED ################")

    end
  endtask
  
endclass
