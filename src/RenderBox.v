module  RenderBox#(parameter SCREEN_WIDTH=400,
	SCREEN_HEIGHT=700,
	BLOCK_WIDTH=40,
	BLOCK_HEIGHT=5)
	(screen, doodleX, doodleY, blocksX, blocksY, isBlockActive);

localparam WHITE=24'hff_ff_ff;
localparam GREEN=24'h08_ff_08;
localparam BROWN=24'hf0_ff_f0;
localparam BKCOLOR=WHITE;
localparam DOODLE=GREEN;
localparam BLOCK=BROWN;

localparam BLOCK_IN_WIDTH = SCREEN_WIDTH / BLOCK_WIDTH;
localparam BLOCK_IN_HEIGHT = SCREEN_HEIGHT / BLOCK_HEIGHT;
localparam COUNT_BLOCKS = BLOCK_IN_WIDTH * BLOCK_IN_HEIGHT;
localparam COUNT_PIXELS = SCREEN_WIDTH * SCREEN_HEIGHT; 

output reg [23:0][COUNT_PIXELS -1 : 0]screen ; // r,g,b (8bit, 8bit, 8bit)

input [31: 0] doodleX, doodleY;
input wire [31: 0][COUNT_BLOCKS-1:0] blocksX;
input wire [31: 0][COUNT_BLOCKS-1:0] blocksY;
input wire [COUNT_BLOCKS-1:0] isBlockActive;

integer i, j, k, index, scrIndex;
reg x, y;

always @(doodleX, doodleY, blocksX, blocksY, isBlockActive)
begin
	// render background
	for(i = 0; i < SCREEN_WIDTH; i++)
	begin
		for(j = 0; j < SCREEN_HEIGHT; j++)
		begin
			scrIndex = (i * SCREEN_HEIGHT) + j;
			screen[scrIndex] = BKCOLOR;
		end
	end

	// render blocks
	for (i = 0; i < BLOCK_WIDTH; i++)
	begin
		for (j = 0; j < BLOCK_HEIGHT; j++)
		begin
			index = (i * BLOCK_IN_HEIGHT) + j;
			if (isBlockActive[index] == 1)
			begin
				for (k = 0; k < BLOCK_WIDTH; k++)
				begin
					x = blocksX[index] + k;
					y = blocksX[index];
					scrIndex = (x * SCREEN_HEIGHT) + y;
					screen[scrIndex] = BROWN;
				end
			end
		end
	end

	// render doodle
	scrIndex = (doodleX * SCREEN_HEIGHT) + doodleY;
	screen[scrIndex] = DOODLE;
end
endmodule

