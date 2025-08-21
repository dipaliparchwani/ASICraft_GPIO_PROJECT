//***************************************************************************************
//* FILE NAME    : gpio_scoreboard.sv                                                   *
//* COMPONENT    : GPIO SCOREBOARD                                                      *
//* DESCRIPTION  : Scoreboard compares GPIO DUT output/input signals against expected   *
//*                register model values.                                               *
//*                - Verifies output correctness using DATA_OUT register                *
//*                - Verifies input correctness using DATA_IN register                  *
//*                - Checks direction bits from DIR register                            *
//***************************************************************************************
`uvm_analysis_imp_decl(_reg_tr)
`uvm_analysis_imp_decl(_gpio_tr)

class gpio_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(gpio_scoreboard)
// Analysis imports for register and GPIO transactions
  uvm_analysis_imp_reg_tr #(gpio_reg_transaction, gpio_scoreboard) reg_imp;
  uvm_analysis_imp_gpio_tr #(gpio_transaction, gpio_scoreboard) gpio_imp;
  gpio_reg_block regmodel;         // Register model instance

// Counters and queues
  int gpio_total_no_packet  = 0;
  int reg_total_no_packet = 0;
  gpio_transaction gpio_q[$];
  gpio_reg_transaction reg_q[$];
  gpio_transaction str;
  bit[`DATA_WIDTH-1:0] rdata,
	               dir;

 //* Constructor
  function new(string name = "gpio_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

 //* Build phase — create analysis ports
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    reg_imp  = new("reg_imp", this);
    gpio_imp = new("gpio_imp", this);
    if(!uvm_config_db#(gpio_reg_block)::get(this, "", "regmodel", regmodel))
      `uvm_error(get_type_name(),"error in getting regblock")
  endfunction

// Receives GPIO monitor transaction and stores in queue
  function void write_gpio_tr(gpio_transaction gtr);
    gtr.print();
    gpio_q.push_back(gtr);
    gpio_total_no_packet++;
    `uvm_info(get_full_name(), $sformatf("count of gpio_no_total : %0d", gpio_total_no_packet), UVM_NONE)
  endfunction

  function void write_reg_tr(gpio_reg_transaction rtr);
    rtr.print();
    reg_total_no_packet++;
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever
      begin
	compare();
      end
  endtask

  task compare();
    uvm_status_e status;
    wait(gpio_q.size>0);
    str = gpio_q.pop_front();
    regmodel.gpio_dir_reg_inst.read(status, dir, UVM_BACKDOOR);
    if(status != UVM_IS_OK) begin
      `uvm_error(get_type_name(), "Backdoor read of gpio_dir_reg_inst failed")
    end
    foreach(dir[i]) begin
      if(!dir[i]) begin
        regmodel.gpio_data_in_reg_inst.read(status, rdata, UVM_BACKDOOR);
        if(status != UVM_IS_OK) begin
          `uvm_error(get_type_name(), "Backdoor read of gpio_data_in_reg_inst failed")
	end
        if(rdata[i] !== str.gpio_in[i]) begin
          `uvm_error(get_type_name(),$sformatf("actual gpio_in = %0h , expected gpio_in = %0h",str.gpio_in,rdata))
        end
	else begin
	  `uvm_info(get_type_name(),$sformatf("actual gpio_in = %h , expected gpio_in = %h",str.gpio_in,rdata),UVM_LOW)
        end
      end

      else begin
        regmodel.gpio_data_out_reg_inst.read(status, rdata, UVM_BACKDOOR);
        if(status != UVM_IS_OK) begin
          `uvm_error(get_type_name(), "Backdoor read of gpio_data_out_reg_inst failed")
	end
        if(rdata[i] !== str.gpio_out[i]) begin
          `uvm_error(get_type_name(),$sformatf("actual gpio_out = %0h , expected gpio_out = %0h",rdata,str.gpio_out))
        end
	else begin
          `uvm_info(get_type_name(),$sformatf("actual gpio_out = %h , expected gpio_out = %h",rdata,str.gpio_out),UVM_LOW)
        end
	
      end
    end
  endtask

  // Report phase — prints total transactions processed
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_full_name(), $sformatf("Final count -> reg_total_no_packet : [%0d] , gpio_total_no_packet : [%0d]", reg_total_no_packet, gpio_total_no_packet), UVM_LOW)
  endfunction

endclass
