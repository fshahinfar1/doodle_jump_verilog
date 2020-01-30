module tbDoodle();
	localparam SCR_W=30;
	localparam SCR_H=30;
	localparam COUNT_PIXELS = SCR_W * SCR_H;

	wire [23:0][COUNT_PIXELS - 1:0] screen; // r,g,b (8bit, 8bit, 8bit)
	reg left, right, clk, reset;
	GameBox _gameBox(screen, left, right, clk, reset);

	initial
	begin
		$dumpfile("test.vcd");
		$dumpvars(0,tbDoodle);
		$monitor("time: %t, clk: %b, ph: %b", $time, clk, _gameBox.physicsUpdate);
		reset = 1;
		clk = 0;
		# 10
		reset = 0;
		# 3000
		$finish();

	end
	
	always
	begin
		#10 clk = ~clk;
	end
endmodule
