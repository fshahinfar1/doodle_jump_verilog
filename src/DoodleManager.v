/*
* This module holds the state of the doodle.
* 
* MAX_JUMP_HEIGHT: how heigh the doodle jumps. a constant int which shows that
* the maximum y value for the doodle is base + MAX_JUMP_HEIGHT.
* base is the Y of the platform doodle is jumping from
*
* falling: shows if the doodle is moving down ward
* hasCollide: if doodle has collided with a block. (so it can now jump of from
* that block)
* */
module DoodleManager #(SCREEN_WIDTH, SCREEN_HEIGHT, BLOCK_WIDTH, BLOCK_HEIGHT,
	MAX_JUMP_HEIGHT)
(doodleX, doodleY, left, right, hasCollide, falling, clk, rest);
begin

localparam UP = 1, DOWN = 0;

// OUTPUT
output reg [31: 0] doodleX, doodleY;

// INPUT
input left, right, hasCollide

// State
// 1: UP 0: DOWN
reg state; // one bit is enough for jumping state

//
reg [31: 0] base; // Y of the platform doodle is jumping from
reg [31: 0] maxJumpThreshold;

always @(reset, doodleY, falling, hasCollide)
begin
	if (reset)
	begin
		doodleX = SCREEN_WIDTH << 1; // half of the screen
		doodleY = 0; starting from the bottom;
	end
	else if (falling && hasCollide)
	begin
		base = doodleY;
		maxJumpThreshold = base + MAX_JUMP_HEIGHT;
	end
end

// update output
// Implementing jumping
always @(posedge clk)
begin
	if (!reset)
	begin
		if (state == UP && doodleY < maxJumpThreshold)
		begin
			doodleY = doodleY + 1;
		end
		else if (state == DOWN & doodleY > base)
		begin
			doodleY = doodleY - 1;
		end
		else ;
	end
end


// calculate next state
always @(state, doodleY, maxJumpThreshold, base)
begin
	if (state == UP && doodleY == maxJumpThreshold) state = DOWN;
	else if (state == DOWN && doodleY == base) state = UP;
	else ;
end

end
