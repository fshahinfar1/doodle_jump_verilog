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
input wire [COUNT_BLOCKS - 1:0][31:0] blocksX; // 
input wire [COUNT_BLOCKS - 1:0][31:0] blocksY; // 
input wire [COUNT_BLOCKS - 1:0] isBlockActive; // 

// 
integer i, j, index;

always @(doodleX, doodleY, blocksY, blocksX, isBlockActive)
begin
	hasCollide = 0;
	for (i = 0; i < COUNT_BLOCKS; i++)
	begin
		if (isBlockActive[i] == 1)
		begin
			if(doodleY == blocksY[i])
			begin
				if(doodleX <= (blocksX[i] + BLOCK_WIDTH) && doodleX >= blocksX[i])
				begin
					hasCollide = 1;
					collisionX = blocksX[i];
					collisionY = blocksY[i];
				end
			end
		end
	end	
end
endmodule

