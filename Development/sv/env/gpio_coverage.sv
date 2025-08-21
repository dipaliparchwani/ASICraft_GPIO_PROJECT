/***************************************************************************************/ 
/* ------------------------------------------------------------------------------------*/ 
/* File name     :  gpio_coverage.sv                                               */  
/* Project       :  GPIO VIP                                                       */ 
/* ------------------------------------------------------------------------------------*/ 
/* *************************************************************************************/

module gpio_coverage(
  input logic clk,
  input logic rst_n,
  input logic gpio_in,
  input logic gpio_out,
  input logic data_out,
  input logic data_in,
  input logic gpio_dir,
  input logic gpio_intr,
  input logic intr_status,
  input logic intr_type,
  input logic intr_polarity,
  input logic intr_mask
);

  covergroup gpio_cov @(posedge clk);
    cp1: coverpoint gpio_in {bins b1 = {0};
                             bins b2 = {1};
			     bins b3[] = (0,1 => 0,1);
			    }
    cp2: coverpoint gpio_out {bins b1 = {0};
                              bins b2 = {1};
			      bins b3[] = (0,1 => 0,1);
			     }
    cp3: coverpoint data_in {bins b1 = {0};
                             bins b2 = {1};
			     bins b3[] = (0,1 => 0,1);
			    }
    cp4: coverpoint data_out {bins b1 = {0};
                              bins b2 = {1};
			      bins b3[] = (0,1 => 0,1);
			     }
    cp5: coverpoint gpio_dir {bins b1 = {0};
                              bins b2 = {1};
			      bins b3[] = (0,1 => 0,1);
			     }
    cp6: coverpoint gpio_intr {bins b1 = {0};
                               bins b2 = {1};
			       bins b3[] = (0,1 => 0,1);
			      }
    cp7: coverpoint intr_status {bins b1 = {0};
                                 bins b2 = {1};
			         bins b3[] = (0,1 => 0,1);
			        }
    cp8: coverpoint intr_type {bins b1 = {0};
                               bins b2 = {1};
			       bins b3[] = (0,1 => 0,1);
			      }
    cp9: coverpoint intr_polarity {bins b1 = {0};
                                   bins b2 = {1};
			           bins b3[] = (0,1 => 0,1);
			          }
    cp10: coverpoint intr_mask {bins b1 = {0};
                                bins b2 = {1};
			        bins b3[] = (0,1 => 0,1);
			       }

    TxPxM: cross cp8,cp9,cp10;
  endgroup : gpio_cov

  gpio_cov gcov = new();


  endmodule

