`uvm_analysis_imp_decl(_reg_tr)
`uvm_analysis_imp_decl(_gpio_tr)

class gpio_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(gpio_scoreboard)

  uvm_analysis_imp_reg_tr #(gpio_reg_transaction, gpio_scoreboard) reg_imp;
  uvm_analysis_imp_gpio_tr #(gpio_transaction, gpio_scoreboard) gpio_imp;

  int gpio_no_total  = 0;
  int regtr_no_total = 0;

  bit [`DATA_WIDTH-1:0] gpio_in_q[$];
  bit [`DATA_WIDTH-1:0] gpio_out_q[$];
  bit [`DATA_WIDTH-1:0] dir_q[$];                  // Store direction writes
  bit [`DATA_WIDTH-1:0] reg_ex_in_data_q[$];       // For register reads
  bit [`DATA_WIDTH-1:0] reg_actual_out_data_q[$];  // For register writes

  function new(string name = "gpio_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    reg_imp  = new("reg_imp", this);
    gpio_imp = new("gpio_imp", this);
  endfunction

  function void write_gpio_tr(gpio_transaction gtr);
    gtr.print();
    gpio_in_q.push_back(gtr.gpio_in);
    gpio_out_q.push_back(gtr.gpio_out);
    gpio_no_total++;
    `uvm_info(get_full_name(), $sformatf("count of gpio_no_total : %0d", gpio_no_total), UVM_NONE)
  endfunction

  function void write_reg_tr(gpio_reg_transaction rtr);
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
    regtr_no_total++;
    `uvm_info(get_full_name(), $sformatf("count of regtr_no_total : %0d", regtr_no_total), UVM_NONE)
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
      wait( ((dir_q.size > 0) && (reg_actual_out_data_q.size > 0) && (gpio_out_q.size > 0)) ||
            ((gpio_in_q.size > 0) && (reg_ex_in_data_q.size > 0)) );

      if ((reg_actual_out_data_q.size > 0) && (gpio_out_q.size > 0) && (dir_q.size > 0)) begin
        bit [`DATA_WIDTH-1:0] actual_out   = gpio_out_q.pop_front();
        bit [`DATA_WIDTH-1:0] expected_out = reg_actual_out_data_q.pop_front();
        bit [`DATA_WIDTH-1:0] dir          = dir_q[0];

        foreach (dir[i]) begin
          if (dir[i]) begin // Output
            if (actual_out[i] !== expected_out[i]) begin
              `uvm_error("GPIO_SB", $sformatf("Mismatch gpio_out[%0d]: actual=%b, expected=%b", i, actual_out[i], expected_out[i]))
            end
          end else begin // Input — should be 0
            if (actual_out[i] !== 1'b0 || expected_out[i] !== 1'b0) begin
              `uvm_error("GPIO_SB", $sformatf("Invalid gpio_out[%0d] on input pin: actual=%b, expected=%b", i, actual_out[i], expected_out[i]))
            end
          end
        end
      end

      if ((gpio_in_q.size > 0) && (reg_ex_in_data_q.size > 0) && (dir_q.size > 0)) begin
        bit [`DATA_WIDTH-1:0] actual_in   = gpio_in_q.pop_front();
        bit [`DATA_WIDTH-1:0] expected_in = reg_ex_in_data_q.pop_front();
        bit [`DATA_WIDTH-1:0] dir         = dir_q[0];

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
    `uvm_info(get_full_name(), $sformatf("Final count -> regtr_no_total : [%0d] , gpio_no_total : [%0d]", regtr_no_total, gpio_no_total), UVM_LOW)
  endfunction

endclass

