//#######################################################################################
//----PROJECT_NAME : GPIO VIP                                                           #
//----FILE_NAME    : reg_interface.sv                                                   #
//----COMPONENT    : REG INTERFACE                                                      #  
//----DESCRIPTION  : interface can be re-used for other projects Also it becomes        #
//----               easier to connect with the DUT and other verification components.  #
//----CREATED_ON   : 21/07/2025                                                         #                                             
//----CREATED_BY   : Dipali                                                             #
//#######################################################################################


interface gpio_reg_if  (input logic clk, input logic rst_n);   
  //Register Block Signals
  logic [`ADDR_WIDTH-1:0] ADDRESS; 

  logic WRITE;  

  logic [`DATA_WIDTH-1:0] WDATA;

  logic [`DATA_WIDTH-1:0] RDATA;
  string inst_name = $sformatf("%m");
  function print();
    $display("------------------------------------getting interface : %s",inst_name);
  endfunction

  initial begin
    virtual gpio_reg_if grvif;
    grvif = interface::self();
    uvm_config_db#(virtual gpio_reg_if)::set(null,inst_name,"grvif",grvif);
  end

  //clocking block for register_model
  clocking reg_model_cb @(posedge clk);
    default input #0 output #0;
    output WRITE,WDATA,ADDRESS;
    input RDATA;
  endclocking:reg_model_cb

  //clocking block for monitor
  clocking reg_monitor_cb @(posedge clk);
    default input #0;
    input WDATA,RDATA,WRITE,ADDRESS;
  endclocking:reg_monitor_cb

  //modport for reg_model and monitor
  modport reg_model (clocking reg_model_cb,input clk,rst_n);
  modport reg_monitor (clocking reg_monitor_cb,input clk,rst_n);



endinterface   
