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
(doodleX, doodleY, left, right, hasCollide, clk, physicsUpdate, rest);
begin

localparam UP = 1, DOWN = 0;

// OUTPUT
output reg [31: 0] doodleX, doodleY;

// INPUT
input left, right, hasCollide, clk, reset;

// State
// 1: UP 0: DOWN
reg state; // one bit is enough for jumping state
reg nextState;

//
reg [31: 0] base; // Y of the platform doodle is jumping from
reg [31: 0] maxJumpThreshold;
wire hitGround;
wire falling;

assign falling = state == DOWN;
assign hitGround = falling && hasCollide;

always @(reset, doodleY, hitGround)
begin
	if (reset)
	begin
		doodleX = SCREEN_WIDTH >> 1; // half of the screen
		doodleY = 0; // starting from the bottom;
		state = UP;
		base = 0;
		maxJumpThreshold = MAX_JUMP_HEIGHT;
	end
	else if (hitGround)
	begin
		base = doodleY;
		maxJumpThreshold = base + MAX_JUMP_HEIGHT;
	end
end

always @(posedge clk)
begin
	if (!reset)
	begin
		state = nextState;
	end
end


// calculate next state
always @(state, doodleY, maxJumpThreshold, hitGround)
begin
	if (state == UP && doodleY == maxJumpThreshold) nextState = DOWN;
	else if (hitGround) nextState = UP;
	else ;
end

/* 
* do physic update (doodle position)
* update output
* Implementing jumping
*/
always @(posedge physicsUpdate)
begin
	if (!reset)
		begin
		if (falling)
		begin
			// state  == DOWN;
			doodleY = doodleY - 1;
		end
		else
		begin
			// state == UP;
			doodleY = doodleY + 1;
		end
	end
end
endmodule
