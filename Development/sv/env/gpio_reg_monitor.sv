class gpio_reg_monitor extends uvm_monitor;
  `uvm_component_utils(gpio_reg_monitor)
  
  virtual gpio_reg_if grvif;
  uvm_analysis_port #(gpio_reg_transaction) rmon_ap;
  function new(string name="gpio_reg_monitor",uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase (phase);
    rmon_ap = new("rmon_ap", this);
    if(! uvm_config_db#(virtual gpio_reg_if)::get (null, "tb.grif", "grvif", grvif))
      `uvm_error("GPIO_REG_MON", "Error getting Interface Handle")
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      gpio_reg_transaction mtr;
      @(posedge grvif.clk);
      mtr = gpio_reg_transaction::type_id::create("mtr");
      if(grvif.WRITE) begin
        mtr.WDATA = grvif.WDATA;
        mtr.ADDRESS = grvif.ADDRESS;
        mtr.WRITE = grvif.WRITE;
        `uvm_info(get_full_name(),$sformatf("[%0t] : value of WDATA : %0h, WRITE : %0h, ADDRESS : %0h",$time,mtr.WDATA,mtr.WRITE,mtr.ADDRESS),UVM_NONE)
	
	if(!($isunknown(mtr.ADDRESS) || $isunknown(mtr.WDATA))) begin
          rmon_ap.write(mtr);
        end
      end

      else if(!grvif.WRITE) begin
        mtr.ADDRESS = grvif.ADDRESS;
        mtr.WRITE = grvif.WRITE;
        mtr.RDATA = grvif.RDATA;
        `uvm_info(get_full_name(),$sformatf("[%0t] : value of RDATA : %0h, WRITE : %0h, ADDRESS : %0h",$time,mtr.RDATA,mtr.WRITE,mtr.ADDRESS),UVM_NONE)
	if(!($isunknown(mtr.ADDRESS) || $isunknown(mtr.RDATA))) begin
          rmon_ap.write(mtr);
        end
      end

      //---------------------------------------------------------------------------------
      //-------------------------------- CHECKERS ---------------------------------------
      //---------------------------------------------------------------------------------
      
      // ####################### RESET CHECKER ########################
      if(!grvif.rst_n )
	if(((mtr.WRITE || mtr.ADDRESS || mtr.WDATA) != 0))
	  `uvm_error("GPIO_REG_MON","############## RESET CONDITION IS FAILED ################")
    end
  endtask
  
endclass
