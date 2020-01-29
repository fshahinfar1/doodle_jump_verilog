module tbDoodle();
	localparam SCR_W=400;
	localparam SCR_H=700;
	localparam COUNT_PIXELS = SCR_W * SCR_H;

	wire [23:0][COUNT_PIXELS - 1:0] screen; // r,g,b (8bit, 8bit, 8bit)
	reg left, right, clk, reset;
	GameBox _gameBox(screen, left, right, clk, reset);

	initial
	begin
		$dumpfile("test.vcd");
		$dumpvars(0,tbDoodle);
		$monitor("time: %t, clk: %b", $time, clk);
		clk = 0;

	end
	
	always
	begin
		#10 clk = ~clk;
	end
endmodule
