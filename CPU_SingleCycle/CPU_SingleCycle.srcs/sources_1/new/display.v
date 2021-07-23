module display (
    input  wire       clk    ,
    input  wire       rst_n  ,
    input  wire  [31:0] value_from_reg19  ,
    output reg        led0_en,
    output reg        led1_en,
    output reg        led2_en,
    output reg        led3_en,
    output reg        led4_en,
    output reg        led5_en,
    output reg        led6_en,
    output reg        led7_en,
    output reg        led_ca ,
    output reg        led_cb ,
    output reg        led_cc ,
    output reg        led_cd ,
    output reg        led_ce ,
    output reg        led_cf ,
    output reg        led_cg ,
    output reg        led_dp
);
reg [2:0] led_cnt;
reg clk_1khz;
reg [17:0]divcount;

always @ (posedge clk_1khz or negedge rst_n) begin
    if (~rst_n)    led_cnt <= 3'h0;
    else           led_cnt <= led_cnt + 3'h1;
end

always@(posedge clk)
    begin
        if(divcount == 18'd49999) 
            begin
                divcount <= 18'd0;
                clk_1khz <= ~clk_1khz;
            end
         else
            divcount <= divcount + 1;
    end

wire led0_en_d = ~(led_cnt == 3'h0);
wire led1_en_d = ~(led_cnt == 3'h1);
wire led2_en_d = ~(led_cnt == 3'h2);
wire led3_en_d = ~(led_cnt == 3'h3);
wire led4_en_d = ~(led_cnt == 3'h4);
wire led5_en_d = ~(led_cnt == 3'h5);
wire led6_en_d = ~(led_cnt == 3'h6);
wire led7_en_d = ~(led_cnt == 3'h7);

always @ (posedge clk_1khz or negedge rst_n) begin
    if (~rst_n) led0_en <= 1'b1;
    else        led0_en <= led0_en_d;
end

always @ (posedge clk_1khz or negedge rst_n) begin
    if (~rst_n) led1_en <= 1'b1;
    else        led1_en <= led1_en_d;
end

always @ (posedge clk_1khz or negedge rst_n) begin
    if (~rst_n) led2_en <= 1'b1;
    else        led2_en <= led2_en_d;
end

always @ (posedge clk_1khz or negedge rst_n) begin
    if (~rst_n) led3_en <= 1'b1;
    else        led3_en <= led3_en_d;
end

always @ (posedge clk_1khz or negedge rst_n) begin
    if (~rst_n) led4_en <= 1'b1;
    else        led4_en <= led4_en_d;
end

always @ (posedge clk_1khz or negedge rst_n) begin
    if (~rst_n) led5_en <= 1'b1;
    else        led5_en <= led5_en_d;
end

always @ (posedge clk_1khz or negedge rst_n) begin
    if (~rst_n) led6_en <= 1'b1;
    else        led6_en <= led6_en_d;
end

always @ (posedge clk_1khz or negedge rst_n) begin
    if (~rst_n) led7_en <= 1'b1;
    else        led7_en <= led7_en_d;
end

reg [3:0] led_display;

always @ (*) begin
    case (led_cnt)
        3'h0 : led_display = value_from_reg19[31:28];
        3'h7 : led_display = value_from_reg19[27:24];
        3'h6 : led_display = value_from_reg19[23:20];
        3'h5 : led_display = value_from_reg19[19:16]; 
        3'h4 : led_display = value_from_reg19[15:12];
        3'h3 : led_display = value_from_reg19[11:8];
        3'h2 : led_display = value_from_reg19[7:4];
        3'h1 : led_display = value_from_reg19[3:0];
        default : led_display <= 4'h0;
    endcase
end

wire eq0 = (led_display == 4'h0);
wire eq1 = (led_display == 4'h1);
wire eq2 = (led_display == 4'h2);
wire eq3 = (led_display == 4'h3);
wire eq4 = (led_display == 4'h4);
wire eq5 = (led_display == 4'h5);
wire eq6 = (led_display == 4'h6);
wire eq7 = (led_display == 4'h7);
wire eq8 = (led_display == 4'h8);
wire eq9 = (led_display == 4'h9);
wire eqa = (led_display == 4'ha);
wire eqb = (led_display == 4'hb);
wire eqc = (led_display == 4'hc);
wire eqd = (led_display == 4'hd);
wire eqe = (led_display == 4'he);
wire eqf = (led_display == 4'hf);

wire led_ca_d = ~(eq0 | eq2 | eq3 | eq5 | eq6 | eq7 | eq8 | eq9 | eqa | eqc | eqe | eqf);
wire led_cb_d = ~(eq0 | eq1 | eq2 | eq3 | eq4 | eq7 | eq8 | eq9 | eqa | eqd);
wire led_cc_d = ~(eq0 | eq1 | eq3 | eq4 | eq5 | eq6 | eq7 | eq8 | eq9 | eqa | eqb | eqd);
wire led_cd_d = ~(eq0 | eq2 | eq3 | eq5 | eq6 | eq8 | eq9 | eqb | eqc | eqd | eqe);
wire led_ce_d = ~(eq0 | eq2 | eq6 | eq8 | eqa | eqb | eqc | eqd | eqe | eqf);
wire led_cf_d = ~(eq0 | eq4 | eq5 | eq6 | eq8 | eq9 | eqa | eqb | eqc | eqe | eqf);
wire led_cg_d = ~(eq2 | eq3 | eq4 | eq5 | eq6 | eq8 | eq9 | eqa | eqb | eqd | eqe | eqf);
wire led_dp_d = 1; 

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) led_ca <= 1'b0;
    else        led_ca <= led_ca_d;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) led_cb <= 1'b0;
    else        led_cb <= led_cb_d;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) led_cc <= 1'b0;
    else        led_cc <= led_cc_d;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) led_cd <= 1'b0;
    else        led_cd <= led_cd_d;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) led_ce <= 1'b0;
    else        led_ce <= led_ce_d;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) led_cf <= 1'b0;
    else        led_cf <= led_cf_d;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) led_cg <= 1'b0;
    else        led_cg <= led_cg_d;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) led_dp <= 1'b1;
    else        led_dp <= led_dp_d;
end

endmodule


