module ViewManager #(parameter SCREEN_WIDTH=400,
	SCREEN_HEIGHT=700,
	BLOCK_WIDTH=40,
	BLOCK_HEIGHT=5)
(minYCrossed, newView, minY, doodleY, reset);
input reset;
input [31: 0] doodleY;
output reg minYCrossed, newView;
output reg [31: 0] minY;

reg [31:0] halfScreenPos;

always @(reset, doodleY, minY, halfScreenPos)
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
		
		$display("doodle", doodleY);
		$display("hfScr", halfScreenPos);
		if (doodleY > halfScreenPos) 
		begin
			// if doodle crossed half of the screen then update
			// the view and send a signal.
			newView = 1'b1;
			minY = minY + 1;
			halfScreenPos = halfScreenPos + 1;
		end
	end
end
endmodule
