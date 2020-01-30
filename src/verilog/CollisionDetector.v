/* Determinse the  block which the doodle has collided width.
/* collisionX and collisionY determines the index of the collision.
*/
module CollisionDetector #(parameter SCREEN_WIDTH=400,
	SCREEN_HEIGHT=700,
	BLOCK_WIDTH=40, BLOCK_HEIGHT=5)
(collisionX, collisionY, hasCollide, doodleX, doodleY, blocksX, blocksY, isBlockActive);
localparam BLOCK_IN_WIDTH = SCREEN_WIDTH / BLOCK_WIDTH;
localparam BLOCK_IN_HEIGHT = SCREEN_HEIGHT / BLOCK_HEIGHT;
localparam COUNT_BLOCKS = BLOCK_IN_HEIGHT * BLOCK_IN_WIDTH;

//OUTPUT
output reg hasCollide;
output reg [31: 0] collisionX, collisionY;

// INPUT
//[31:0][(BLOCK_IN_HEIGHT - 1) * (BLOCK_IN_WIDTH - 1):0]
input [31:0] doodleX, doodleY;
input wire [31:0][COUNT_BLOCKS - 1:0] blocksX; // 
input wire [31:0][COUNT_BLOCKS - 1:0] blocksY; // 
input wire [COUNT_BLOCKS - 1:0] isBlockActive; // 

// 
integer i, j, index;

always @(doodleX, doodleY, blocksY, blocksX, isBlockActive)
begin
	hasCollide = 0;
	for (i = 0; i < BLOCK_WIDTH; i++)
	begin
		for (j = 0; j < BLOCK_HEIGHT; j++)
		begin
			index = (i * BLOCK_IN_HEIGHT) + j;
			if (isBlockActive[index] == 1)
			begin
				if (doodleY == blocksY[index])
				begin
					if (doodleX <= (blocksX[index] + BLOCK_WIDTH))
					begin
						hasCollide = 1;
						collisionX = i;
						collisionY = j;
					end
				end
			end
		end
	end
end
endmodule

