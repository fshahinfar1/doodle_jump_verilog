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
module BlockManager #(parameter SCREEN_WIDTH=400,
	SCREEN_HEIGHT=700,
	BLOCK_WIDTH=40, BLOCK_HEIGHT=5)
(blocksX, blocksY, isBlockActive, newView, minY,
	collisionX, collisionY, hasCollide, reset);
localparam BLOCK_IN_WIDTH = SCREEN_WIDTH / BLOCK_WIDTH;
localparam BLOCK_IN_HEIGHT = SCREEN_HEIGHT / BLOCK_HEIGHT;
localparam COUNT_BLOCKS = BLOCK_IN_HEIGHT * BLOCK_IN_WIDTH;

// INPUTS
input newView, hasCollide, reset;
input [31: 0] collisionX, collisionY, minY;  // a 32 bit integer for showing the index

// OUTPUTS
output reg [31:0][COUNT_BLOCKS-1:0] blocksX; // 
output reg [31:0] [COUNT_BLOCKS- 1:0]blocksY; // 
output reg [COUNT_BLOCKS- 1:0] isBlockActive; // 

// Control register
output reg [COUNT_BLOCKS-1:0]ttl; // Time To leave

integer i, j, index;

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
			blocksY[0] = {BLOCK_IN_WIDTH{minY}}; // FIXME: ??
		end

		for (j = 1; j < BLOCK_IN_HEIGHT; j++)
		begin
			for (i = 0; i < BLOCK_IN_WIDTH; i++)
			begin
				index = (i * BLOCK_IN_HEIGHT)  + j;
				if (blocksY[index] < minY)
				begin
					blocksY[index] = minY + blocksY[index - 1];
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
			blocksX[j] = 0;
		end
		for (i = 0; i < BLOCK_IN_WIDTH; i++)
		begin
			// initialize the Y of the block just at the bottom
			index = (i * BLOCK_IN_HEIGHT);
			blocksY[index] = 0;
		end

		for (j = 0; j < BLOCK_IN_HEIGHT; j++)
		begin
			for (i = 1; i < BLOCK_IN_WIDTH; i++)
			begin
				index = (i * BLOCK_IN_HEIGHT) + j;
				blocksX[index] = blocksX[index - BLOCK_IN_HEIGHT] + BLOCK_WIDTH;
			end
		end

		for (j = 1; j < BLOCK_IN_HEIGHT; j++)
		begin
			for (i = 0; i < BLOCK_IN_WIDTH; i++)
			begin
				index = (i * BLOCK_IN_HEIGHT) + j;
				blocksY[index] = blocksY[index-1] + BLOCK_IN_HEIGHT;
			end
		end

		for (j = 0; j < BLOCK_IN_HEIGHT; j++)
		begin
			for (i = 0; i < BLOCK_IN_WIDTH; i++)
			begin
				// TODO: only active some of the blocks not
				// all
				index = (i * BLOCK_IN_HEIGHT) + j;
				isBlockActive[index] = 1;
			end
		end

	end
end
endmodule

