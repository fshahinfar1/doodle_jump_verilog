/*
* This module holds the position of each block (platform)
*
* SCREEN_WIDTH / BLOCK_WIDTH: defines the number of blocks in the width
* SCREEN_HEIGHT / BLOCK_HEIGHT: defines the number of blocks in height
* 
* OUTPUTS:
* blocksX and blocksY is the position of left pixel of the block. all blocks
* are horizontal.
* isBlockActive[i] shows if the i-th block is active. 
*
* INPUTS: 
* newView: signal showing that the ViewManager has updated the view.
* The blocks blew the minY should be deactive (isBlockActive[i][j] = 0)
*
* minY: The minimum height of the view. (blew which the doodle dies)
* collisionX: if doodle collides with a block, this shows the x index
* collisionY: ... 
* */
module BlockManager #(SCREEN_WIDTH, SCREEN_HEIGHT, BLOCK_WIDTH, BLOCK_HEIGHT)
(blocksX, blocksY, isBlockActive, newView, minY,
	collisionX, collisionY, hasCollide, reset);
localparam BLOCK_IN_WIDTH = SCREEN_WIDTH / BLOCK_WIDTH;
localparam BLOCK_IN_HEIGHT = SCREEN_HEIGHT / BLOCK_HEIGHT;

// INPUTS
input newView, minY, hasCollide, reset;
input [31: 0] collisionX, collisionY ;  // a 32 bit integer for showing the index

// OUTPUTS
output reg [31:0][BLOCK_IN_WIDTH - 1: 0] blocksX [BLOCK_IN_HEIGHT - 1:0]; // 
output reg [31:0][BLOCK_IN_WIDTH - 1: 0] blocksY [BLOCK_IN_HEIGHT - 1:0]; // 
output reg [BLOCK_IN_WIDTH - 1: 0] isBlockActive [BLOCK_IN_HEIGHT - 1:0]; // 

// Control register
output reg [BLOCK_IN_WIDTH - 1: 0] ttl [BLOCK_IN_HEIGHT - 1:0]; // Time To leave

integer i, j;

// TODO: moving blocks,
// TODO: destroying blocks,
// TODO: random placement
always @(newView, reset)
begin
	if (newView)
	begin
		for (i = 0; i < BLOCK_IN_WIDTH; i++)
		begin
			// TODO: check miny to be greater
			// initialize the Y of the block just at the bottom
			blocksY[i][0] = minY;
		end

		for (j = 1; j < BLOCK_IN_HEIGHT; j++)
		begin
			for (i = 0; i < BLOCK_IN_WIDTH; i++)
			begin
				if (blocksY[i][j] < minY)
				begin
					blocksY[i][j] = minY + blocksY[i][j-1];
				end
			end
		end
	end

	if (reset)
	begin
		for (j = 0; j < BLOCK_IN_HEIGHT; j++)
		begin
			// initialize the X of the blocks just at the left side
			// of the screen
			blocksX[0][j] = 0;
		end
		for (i = 0; i < BLOCK_IN_WIDTH; i++)
		begin
			// initialize the Y of the block just at the bottom
			blocksY[i][0] = 0;
		end

		for (j = 0; j < BLOCK_IN_HEIGHT; j++)
		begin
			for (i = 1; i < BLOCK_IN_WIDTH; i++)
			begin
				blocksX[i][j] = blocksX[i-1][j] + BLOCK_WIDTH;
			end
		end

		for (j = 1; j < BLOCK_IN_HEIGHT; j++)
		begin
			for (i = 0; i < BLOCK_IN_WIDTH; i++)
			begin
				blocksY[i][j] = blocksY[i][j-1] + BLOCK_IN_HEIGHT;
			end
		end

		for (j = 0; j < BLOCK_IN_HEIGHT; j++)
		begin
			for (i = 0; i < BLOCK_IN_WIDTH; i++)
			begin
				// TODO: only active some of the blocks not
				// all
				isBlockActive = 1;
			end
		end

	end
end
endmodule

