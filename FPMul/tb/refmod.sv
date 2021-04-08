class refmod extends uvm_component;
    `uvm_component_utils(refmod)
    
	shortreal rA;
	shortreal rB;
	shortreal rdata, rdata1, rdata2;
	int i;

    packet_in tr_in;
    packet_out tr_out;
    uvm_get_port #(packet_in) in;
    uvm_put_port #(packet_out) out;
    
    function new(string name = "refmod", uvm_component parent);
        super.new(name, parent);
        in = new("in", this);
        out = new("out", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr_out = packet_out::type_id::create("tr_out", this);
    endfunction: build_phase
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        i = 0;
	rdata=0;
	rdata1=0;
	rdata2=0;
        forever begin
            in.get(tr_in);
			rA = $bitstoshortreal(tr_in.A);
			rB = $bitstoshortreal(tr_in.B);
			// The pipeline of the FPMul introduces a delay of the output samples. This means that the refmod output also has to be delayed, to achieve a correct synchronization.
			rdata2 = rdata1;
			rdata1 = rdata;
         		rdata = rA * rB;
			if(i < 2) begin
				tr_out.data = 0;
				i++;
			end
			else begin
				tr_out.data = $shortrealtobits(rdata2);
			end
            		$display("refmod: input A = %f, input B = %f, output OUT = %f",tr_in.A, tr_in.B, tr_out.data);
			$display("refmod: input A = %b, input B = %b, output OUT = %b",tr_in.A, tr_in.B, tr_out.data);
            out.put(tr_out);
        end
    endtask: run_phase
endclass: refmod
