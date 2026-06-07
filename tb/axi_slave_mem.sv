module axi_slave_mem #(
    parameter AW = 32,
    parameter DW = 32,
    parameter DEPTH = 1024
)(
    input  wire               ACLK,
    input  wire               ARESETN,

    input  wire [AW-1:0]      AWADDR,
    input  wire               AWVALID,
    output reg                AWREADY,

    input  wire [DW-1:0]      WDATA,
    input  wire               WVALID,
    output reg                WREADY,

    output reg                BVALID,
    input  wire               BREADY,

    input  wire [AW-1:0]      ARADDR,
    input  wire               ARVALID,
    output reg                ARREADY,

    output reg [DW-1:0]       RDATA,
    output reg                RVALID,
    input  wire               RREADY
);

    reg [DW-1:0] mem [0:DEPTH-1];

    reg [AW-1:0] awaddr_r;
    reg [DW-1:0] wdata_r;

    reg aw_seen, w_seen;

    //----------------------------------------
    // RESET
    //----------------------------------------
    always @(posedge ACLK or negedge ARESETN) begin
        if (!ARESETN) begin
            AWREADY <= 0;
            WREADY  <= 0;
            ARREADY <= 0;
            BVALID  <= 0;
            RVALID  <= 0;
            aw_seen <= 0;
            w_seen  <= 0;
        end else begin

            //--------------------------------
            // WRITE ADDRESS
            //--------------------------------
            AWREADY <= 1;
            if (AWVALID && AWREADY) begin
                awaddr_r <= AWADDR[11:2]; // word aligned
                aw_seen  <= 1;
            end

            //--------------------------------
            // WRITE DATA
            //--------------------------------
            WREADY <= 1;
            if (WVALID && WREADY) begin
                wdata_r <= WDATA;
                w_seen  <= 1;
            end

            //--------------------------------
            // WRITE RESPONSE
            //--------------------------------
            if (aw_seen && w_seen && !BVALID) begin
                mem[awaddr_r] <= wdata_r;
                BVALID <= 1;
                aw_seen <= 0;
                w_seen  <= 0;
            end else if (BVALID && BREADY) begin
                BVALID <= 0;
            end

            //--------------------------------
            // READ ADDRESS
            //--------------------------------
            ARREADY <= 1;
            if (ARVALID && ARREADY && !RVALID) begin
                RDATA  <= mem[ARADDR[11:2]];
                RVALID <= 1;
            end

            //--------------------------------
            // READ DATA
            //--------------------------------
            if (RVALID && RREADY) begin
                RVALID <= 0;
            end

        end
    end

endmodule
