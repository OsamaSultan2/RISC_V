module Hazard_unit(
input regWriteM, regWriteW, resultSrcE,PCsrcE,
input [4:0]  Rs1D,Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,  

output reg stallD, stallF, flushE,flushD,
output reg [1:0] forwardAE, forwardBE
);

//==============================================================================
// RAW HAZARD DETECTION (forwarding mechanism) 
//==============================================================================
always @(*) begin
    //--------------------------------------------------
    // first register source hazard detection
    //--------------------------------------------------
    if ((Rs1E == RdM) && regWriteM) begin
        forwardAE = 2'b10;
    end 
    else if ((Rs1E == RdW) && regWriteW ) begin
        forwardAE = 2'b01;
    end
    else 
        forwardAE = 2'b00;
    //--------------------------------------------------
    // second register source hazard detection
    //--------------------------------------------------
    if ((Rs2E == RdM) && regWriteM) begin
        forwardBE = 2'b10;
    end 
    else if ((Rs2E == RdW) && regWriteW ) begin
        forwardBE = 2'b01;
    end
    else 
        forwardBE = 2'b00;        
end

//==============================================================================
// RAW HAZARD DETECTION (stall mechanism) AND CONTROL HAZARD
//==============================================================================
always @(*) begin
    //--------------------------------------------------
    // CONTROL HAZARD
    //--------------------------------------------------
    if(PCsrcE) begin
        flushD = 1;
        flushE = 1;
        stallD = 0;
        stallF = 0;
    end 
    else begin
    //--------------------------------------------------
    // RAW HAZARD ==> FIRST REGISTER
    //--------------------------------------------------
        if( (resultSrcE == 1) && (Rs1D == RdE || Rs2D == RdE)) begin
            stallF = 1;
            stallD = 1;
            flushE = 1;
            flushD = 0;
        end
        else begin
            stallF = 0;
            stallD = 0;
            flushE = 0;
            flushD = 0;
        end
    end  
end

endmodule