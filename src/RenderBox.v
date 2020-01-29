module RenderBox #(SCREEN_WIDTH, SCREEN_HEIGHT, BLOCK_WIDTH, BLOCK_HEIGHT)
(screen, doodleX, doodleY, blocksX, blocksY);
output reg [23:0][SCREEN_WIDTH - 1: 0] screen [SCREEN_HEIGHT - 1: 0]; // r,g,b (8bit, 8bit, 8bit)

localparam WHITE=24'hff_ff_ff;
localparam GREEN=24'h08_ff_08;
localparam BROWN=24'hf0_ff_f0;
localparam BKCOLOR=WHITE;
localparam DOODLE=GREEN;
localparam BLOCK=BROWN;

localparam BLOCK_IN_WIDTH = SCREEN_WIDTH / BLOCK_WIDTH;
localparam BLOCK_IN_HEIGHT = SCREEN_HEIGHT / BLOCK_HEIGHT;

input [31: 0] doodleX, doodleY;
input [31: 0][BLOCK_IN_WIDTH - 1: 0] blocksX[BLOCK_HEIGHT - 1: 0]
input [31: 0][BLOCK_IN_WIDTH - 1: 0] blocksY[BLOCK_HEIGHT - 1: 0]

integer i, j;
reg x, y;

always @(doodleX, doodleY,)
begin
	// render background
	for(i = 0; i < SCREEN_WIDTH; i++)
	begin
		for(j = 0; j < SCREEN_HEIGHT; j++)
		begin
			screen[i][j] = BKCOLOR;
		end
	end

	// render blocks
	for (i = 0; i < BLOCK_WIDTH; i++)
	begin
		for (j = 0; j < BLOCK_HEIGHT; j++)
		begin
			x = blocksX[i][j];
			y = blocksX[i][j];
			screen[x][y] = BROWN;
		end
	end

	// render doodle
	screen[doodleX][doodleY] = DOODLE;
end
endmodule

