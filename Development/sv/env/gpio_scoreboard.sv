`uvm_analysis_imp_decl(_reg_tr)
`uvm_analysis_imp_decl(_gpio_tr)

class gpio_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(gpio_scoreboard)

  uvm_analysis_imp_reg_tr #(gpio_reg_transaction, gpio_scoreboard) reg_imp;
  uvm_analysis_imp_gpio_tr #(gpio_transaction, gpio_scoreboard) gpio_imp;

  int gpio_total_no_packet  = 0;
  int regtr_total_no_packet = 0;
  
  gpio_transaction gpio_q[$];
  bit [`DATA_WIDTH-1:0] dir_q[$],                  // Store direction writes
                        reg_ex_in_data_q[$],       // For register reads
                        reg_actual_out_data_q[$];  // For register writes

  function new(string name = "gpio_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    reg_imp  = new("reg_imp", this);
    gpio_imp = new("gpio_imp", this);
  endfunction

  function void write_gpio_tr(gpio_transaction gtr);
    `uvm_info(get_full_name(),"gpio_transaction",UVM_NONE)
    gtr.print();
    gpio_q.push_back(gtr);
    gpio_total_no_packet++;
    `uvm_info(get_full_name(), $sformatf("count of gpio_no_total : %0d", gpio_total_no_packet), UVM_NONE)
  endfunction

  function void write_reg_tr(gpio_reg_transaction rtr);
    `uvm_info(get_full_name(),"reg_transaction",UVM_NONE)
    rtr.print();
    if (rtr.WRITE) begin
      case (rtr.ADDRESS)
        'h08: dir_q.push_back(rtr.WDATA);                 // DIR write
        'h04: reg_actual_out_data_q.push_back(rtr.WDATA); // DATA_OUT write
      endcase
    end else begin
      case (rtr.ADDRESS)
        'h00: reg_ex_in_data_q.push_back(rtr.RDATA);      // DATA_IN read
      endcase
    end
    regtr_total_no_packet++;
    `uvm_info(get_full_name(), $sformatf("count of regtr_no_total : %0d", regtr_total_no_packet), UVM_NONE)
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
      wait( ((dir_q.size > 0) && (reg_actual_out_data_q.size > 0) && (gpio_q.size > 0)) ||
            ((gpio_q.size > 0) && (reg_ex_in_data_q.size > 0)) );

      if ((reg_actual_out_data_q.size > 0) && (gpio_q.size > 0) && (dir_q.size > 0)) begin
	gpio_transaction etr = gpio_q.pop_front(); 
        bit [`DATA_WIDTH-1:0] expected_out   = etr.gpio_out,
                              actual_out = reg_actual_out_data_q.pop_front(),
                              dir          = dir_q[0];

        foreach (dir[i]) begin
          if (dir[i]) begin // Output
            if (actual_out[i] !== expected_out[i]) begin
              `uvm_error("GPIO_SB", $sformatf("Mismatch gpio_out[%0d]: actual=%b, expected=%b", i, actual_out[i], expected_out[i]))
            end
          end 
	 /* else if (!dir[i])begin // Input — should be 0
            if (actual_out[i] !== 1'b0 || expected_out[i] !== 1'b0) begin
              `uvm_error("GPIO_SB", $sformatf("Invalid gpio_out[%0d] on input pin: actual=%b, expected=%b", i, actual_out[i], expected_out[i]))
            end
          end*/
        end
      end

      if ((gpio_q.size > 0) && (reg_ex_in_data_q.size > 0) && (dir_q.size > 0)) begin
	gpio_transaction atr = gpio_q.pop_front();
        bit [`DATA_WIDTH-1:0] actual_in   = atr.gpio_in,
                              expected_in = reg_ex_in_data_q.pop_front(),
                              dir         = dir_q[0];

        foreach (dir[i]) begin
          if (!dir[i]) begin // Input
            if (actual_in[i] !== expected_in[i]) begin
              `uvm_error("GPIO_SB", $sformatf("Mismatch gpio_in[%0d]: actual=%b, expected=%b", i, actual_in[i], expected_in[i]))
            end
          end else begin // Output — should be 0
            if (actual_in[i] !== 1'b0 || expected_in[i] !== 1'b0) begin
              `uvm_error("GPIO_SB", $sformatf("Invalid gpio_in[%0d] on output pin: actual=%b, expected=%b", i, actual_in[i], expected_in[i]))
            end
          end
        end
      end

      if (dir_q.size > 1)
        void'(dir_q.pop_front());
    end
  endtask

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_full_name(), $sformatf("Final count -> regtr_total_no_packet : [%0d] , gpio_total_no_packet : [%0d]", regtr_total_no_packet, gpio_total_no_packet), UVM_LOW)
    //uvm_report_server::get_server()==> Gets the singleton instance of the UVM report server which logs all UVM reports.
    //.get_severity_count(UVM_ERROR) ==> Returns how many UVM_ERROR severity reports were issued during the simulation.
    //> 0 ==> If one or more errors occurred, the condition is true.
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

