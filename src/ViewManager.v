module ViewManager #(SCREEN_WIDTH, SCREEN_HEIGHT, BLOCK_WIDTH, BLOCK_HEIGHT)
(minYCrossed, newView, minY, doodleY, reset);
input [31: 0] doodleY;
output reg minYCrossed, newView;
output reg [31: 0] minY;

reg [31:0] halfScreenPos;

always @()
begin
	newView = 0;
	minYCrossed = 0;
	if(reset)
	begin
		minY = 0;
		minYCrossed = 1'b0;
		newView = 1'b0;
		halfScreenPos = SCREEN_HEIGHT >> 1;
	end
	else
	begin
		if (doodleY < minY)
		begin
			minYCrossed = 1'b1;
		end
		
		if (doodleY > halfScreenPos) 
		begin
			// if doodle crossed half of the screen then update
			// the view and send a signal.
			newView = 1'b1;
			minY = minY + SCREEN_HEIGHT >> 2;
		end
	end
end
endmodule
