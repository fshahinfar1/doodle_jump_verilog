module  RenderBox#(parameter SCREEN_WIDTH=400,
	SCREEN_HEIGHT=700,
	BLOCK_WIDTH=40,
	BLOCK_HEIGHT=5,
	X=0,
	Y=0)
	(color, doodleX, doodleY, blocksX, blocksY, minY, isBlockActive, gameOver, reset);

localparam WHITE=24'hff_ff_ff;
localparam GRAY=24'he6_e6_c1;
localparam GREEN=24'h00_ff_00;
localparam BROWN=24'hff_a0_0f;
localparam RED=24'hff_00_00;
localparam BKCOLOR=GRAY;
localparam DOODLE=GREEN;
localparam BLOCK=BROWN;
localparam GAMEOVER=RED;

localparam BLOCK_IN_WIDTH = SCREEN_WIDTH / BLOCK_WIDTH;
localparam BLOCK_IN_HEIGHT = SCREEN_HEIGHT / BLOCK_HEIGHT;
localparam COUNT_BLOCKS = BLOCK_IN_WIDTH * BLOCK_IN_HEIGHT;
localparam COUNT_PIXELS = SCREEN_WIDTH * SCREEN_HEIGHT; 

output reg [23: 0] color;

input wire gameOver, reset;
input [31: 0] doodleX, doodleY, minY;
input wire [COUNT_BLOCKS-1:0][31: 0] blocksX;
input wire [COUNT_BLOCKS-1:0][31: 0] blocksY;
input wire [COUNT_BLOCKS-1:0] isBlockActive;

integer i, j, k, index, scrIndex;
reg [31:0] x, y;

always @(doodleX, doodleY, blocksX, blocksY, isBlockActive, reset)
begin
	// render background
	if (gameOver)
	begin
		color = GAMEOVER;
	end
	else
	begin
		color = BKCOLOR;
	end
	// for(i = 0; i < SCREEN_WIDTH; i++)
	// begin
	// 	for(j = 0; j < SCREEN_HEIGHT; j++)
	// 	begin
	// 		scrIndex = (i * SCREEN_HEIGHT) + j;
	// 		screen[scrIndex] = 0;
	// 		$display(scrIndex, screen[scrIndex]);
	// 	end
	// end

	// render blocks
	for (i = 0; i < COUNT_BLOCKS; i++)
	begin
		if (isBlockActive[i] == 1)
		begin
			//$display("is active: ", isBlockActive[i] ,", i: ", i);
			for (k = 0; k < BLOCK_WIDTH; k++)
			begin
				x = blocksX[i] + k;
				y = blocksY[i];
				if (x==X && y==Y)
				begin
					//$display("block", x, y, ":", X, Y);
					color=BLOCK;
				end
			end
		end
	end
	// $display(doodleX," ", doodleY," minY:", minY, "  ", X, ",", Y);
	if (doodleX == X && (doodleY - minY) == Y)
	begin
	color = DOODLE;
	// $display("d:,", DOODLE);		
	end

	// render doodle
	// scrIndex = (doodleX * SCREEN_HEIGHT) + doodleY;
	// screen[scrIndex] = DOODLE;
end
endmodule

