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
output reg [COUNT_BLOCKS-1:0][31:0] blocksX; // 
output reg [COUNT_BLOCKS- 1:0][31:0] blocksY; // 
output reg [COUNT_BLOCKS- 1:0] isBlockActive; // 

// Control register
output reg [COUNT_BLOCKS-1:0]ttl; // Time To leave

integer i, j, index;

// TODO: moving blocks,
// TODO: destroying blocks,
// TODO: random placement
always @(newView, reset, minY)
begin
	if (reset)
	begin
		for (i = 0; i < COUNT_BLOCKS; i++)
		begin
			if (i[0] == 0 && i[1] == 0) 
			begin
				isBlockActive[i] = 1;
			end
			else isBlockActive[i] = 0;

			blocksX[i] = (i / BLOCK_IN_HEIGHT) * BLOCK_WIDTH;	
			blocksY[i] = (i % BLOCK_IN_HEIGHT) * BLOCK_HEIGHT;
			// $display(blocksX[i],", ", blocksY[i]);
		end
	end
	else if (newView)
	begin
		$display("NEWVIEW!!!!!");
		for (i = 0; i < COUNT_BLOCKS; i++)
		begin
			if (blocksY[i] < minY)
			begin
				isBlockActive[i] = 0;
				//blocksY[index] = minY + blocksY[index - 1];
			end
		end
	end
end
endmodule
