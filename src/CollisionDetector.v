/* Determinse the  block which the doodle has collided width.
/* collisionX and collisionY determines the index of the collision.
*/
module CollisionDetector #(SCREEN_WIDTH, SCREEN_HEIGHT, BLOCK_WIDTH, BLOCK_HEIGHT)
(collisionX, collisionY, hasCollide, doodleX, doodleY, blocksX, blocksY, isBlockActive);
localparam BLOCK_IN_WIDTH = SCREEN_WIDTH / BLOCK_WIDTH;
localparam BLOCK_IN_HEIGHT = SCREEN_HEIGHT / BLOCK_HEIGHT;

//OUTPUT
output reg hasCollide;
output reg [31: 0] collisionX, collisionY;

// INPUT
input [31:0] doodleX, doodleY;
input [31:0][BLOCK_IN_WIDTH - 1: 0] blocksX [BLOCK_IN_HEIGHT - 1:0]; // 
input [31:0][BLOCK_IN_WIDTH - 1: 0] blocksY [BLOCK_IN_HEIGHT - 1:0]; // 
output reg [BLOCK_IN_WIDTH - 1: 0] isBlockActive [BLOCK_IN_HEIGHT - 1:0]; // 

// 
integer i, j;

always @(doodleX, doodleY, blocksY, blocksX, isBlockActive)
begin
	hasCollide = 0;
	for (i = 0; i < BLOCK_WIDTH; i++)
	begin
		for (j = 0; j < BLOCK_HEIGHT; j++)
		begin
			if (isBlockActive == 1)
			begin
				if (doodleY == blocksY[i][j])
				begin
					if (doodleX <= (blocksX[i][j] + BLOCK_WIDTH))
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

