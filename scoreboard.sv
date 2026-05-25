class bridge_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(bridge_scoreboard)

  uvm_tlm_analysis_fifo #(read_xtn)  fifo_rdh; 
  uvm_tlm_analysis_fifo #(write_xtn) fifo_wrh; 

  write_xtn wr_data;
  read_xtn  rd_data;

  write_xtn ahb_q[$];     
  bit [31:0] prdata_q[$]; 

  function new(string name="bridge_scoreboard",uvm_component parent);
    super.new(name,parent);
    fifo_rdh = new("fifo_rdh", this);
    fifo_wrh = new("fifo_wrh", this);
  endfunction

  task run_phase(uvm_phase phase);
    fork
      forever begin
        fifo_wrh.get(wr_data);
        ahb_q.push_back(wr_data);
      end

      forever begin
        fifo_rdh.get(rd_data);
        prdata_q.push_back(rd_data.Prdata);

        if (ahb_q.size() > 0) begin
          write_xtn wr = ahb_q.pop_front();
          check_data(wr, rd_data, prdata_q.size()-1);
        end
      end
    join
  endtask

  function void check_data(write_xtn wr_data, read_xtn rd_data, int idx);
    if (wr_data.Hwrite) begin
      if (wr_data.Hwdata == rd_data.Pwdata)
        `uvm_info("SB", $sformatf("WRITE data matched : Hwdata=%0d Pwdata=%0d",
                                  wr_data.Hwdata, rd_data.Pwdata), UVM_LOW)
      else
        `uvm_error("SB", $sformatf("WRITE mismatch : Hwdata=%0d Pwdata=%0d",
                                   wr_data.Hwdata, rd_data.Pwdata))
    end
    else begin
      if ((idx % 2) == 1) begin  
        if (wr_data.Hrdata == prdata_q[idx])
          `uvm_info("SB", $sformatf("READ matched : Hrdata=%0d Prdata=%0d",
                                    wr_data.Hrdata, prdata_q[idx]), UVM_LOW)
        else
          `uvm_error("SB", $sformatf("READ mismatch : Hrdata=%0d Prdata=%0d",
                                     wr_data.Hrdata, prdata_q[idx]))
      end
    end
  endfunction
endclass

