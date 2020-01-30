module  RenderBox#(parameter SCREEN_WIDTH=400,
	SCREEN_HEIGHT=700,
	BLOCK_WIDTH=40,
	BLOCK_HEIGHT=5,
	X=0,
	Y=0)
	(color, doodleX, doodleY, blocksX, blocksY, minY, isBlockActive, reset);

localparam WHITE=24'hff_ff_ff;
localparam RND=24'h00_ab_00;
localparam GREEN=24'h00_ff_00;
localparam BROWN=24'hff_00_00;
localparam BKCOLOR=RND;
localparam DOODLE=GREEN;
localparam BLOCK=BROWN;

localparam BLOCK_IN_WIDTH = SCREEN_WIDTH / BLOCK_WIDTH;
localparam BLOCK_IN_HEIGHT = SCREEN_HEIGHT / BLOCK_HEIGHT;
localparam COUNT_BLOCKS = BLOCK_IN_WIDTH * BLOCK_IN_HEIGHT;
localparam COUNT_PIXELS = SCREEN_WIDTH * SCREEN_HEIGHT; 

output reg [23: 0] color;

input wire reset;
input [31: 0] doodleX, doodleY, minY;
input wire [COUNT_BLOCKS-1:0][31: 0] blocksX;
input wire [COUNT_BLOCKS-1:0][31: 0] blocksY;
input wire [COUNT_BLOCKS-1:0] isBlockActive;

integer i, j, k, index, scrIndex;
reg x, y;

always @(doodleX, doodleY, blocksX, blocksY, isBlockActive, reset)
begin
	// render background
	color = BKCOLOR;
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
					if (x==X && y==Y)
					begin
						color=BLOCK;
					end
				end
			end
		end
	end
	$display(doodleX," ", doodleY - minY, ":", X, ",", Y);
	if (doodleX == X && (doodleY - minY) == Y)
	begin
	color = DOODLE;
	$display("d:,", DOODLE);		
	end

	// render doodle
	// scrIndex = (doodleX * SCREEN_HEIGHT) + doodleY;
	// screen[scrIndex] = DOODLE;
end
endmodule

