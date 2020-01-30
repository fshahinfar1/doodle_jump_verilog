/*
* This is the main board of our arcade game
* */
module GameBox (screen, left, right, clk, reset);

localparam countPulseBeforePhysicsUpdate=1;
localparam SCR_W=30;
localparam SCR_H=30;
localparam BLK_W=3;
localparam BLK_H=3;
localparam MAX_JMP_H=1;
localparam BLOCK_IN_WIDTH = SCR_W / BLK_W;
localparam BLOCK_IN_HEIGHT = SCR_H / BLK_H;
localparam COUNT_BLOCKS = BLOCK_IN_HEIGHT * BLOCK_IN_WIDTH;
localparam COUNT_PIXELS = SCR_W * SCR_H;

input left, right, clk, reset;
reg _left, _right, _clk, _reset;

// screen
output reg [COUNT_PIXELS - 1:0][23:0] screen; // r,g,b (8bit, 8bit, 8bit)
wire [COUNT_PIXELS - 1:0][23:0] _screen; // r,g,b (8bit, 8bit, 8bit)

// collision detector
wire _hasCollide;
wire [31: 0] _collisionX, _collisionY;
reg hasCollide;
reg [31 : 0] collisionX, collisionY;
			
// doodle manager
wire [31:0] _doodleX, _doodleY;
reg [31:0] doodleX, doodleY;

// blocks manager
wire [31:0][COUNT_BLOCKS - 1:0] _blocksX;
wire [31:0][COUNT_BLOCKS - 1:0] _blocksY;
wire [COUNT_BLOCKS - 1:0] _isBlockActive;
reg [31:0][COUNT_BLOCKS - 1:0] blocksX;
reg [31:0][COUNT_BLOCKS - 1:0] blocksY;
reg [COUNT_BLOCKS - 1:0] isBlockActive;

// view manager
wire _minYCrossed, _newView;
wire [31: 0] _minY;
reg newView;
reg [31: 0] minY;

// create physics clk
reg physicsUpdate;
reg [31:0] pulsCounter;
always @(reset)
begin
	if (reset)
	begin
		pulsCounter = 0;
		physicsUpdate = 0;
	end	
end

always @(posedge clk)
begin
	if (!reset)
	begin
		pulsCounter = pulsCounter + 1;
		if (pulsCounter == countPulseBeforePhysicsUpdate)
		begin
			pulsCounter = 0;
			physicsUpdate = ~physicsUpdate;
		end
	end
end

DoodleManager #(.SCREEN_WIDTH(SCR_W),
	.SCREEN_HEIGHT(SCR_H),
	.BLOCK_WIDTH(BLK_W),
	.BLOCK_HEIGHT(BLK_H),
	.MAX_JUMP_HEIGHT(MAX_JMP_H)) _doodleMan
				(_doodleX, _doodleY, _left, _right, hasCollide,
					_clk, physicsUpdate, _reset);

BlockManager #(.SCREEN_WIDTH(SCR_W),
	.SCREEN_HEIGHT(SCR_H),
	.BLOCK_WIDTH(BLK_W),
	.BLOCK_HEIGHT(BLK_H)) _blockMan
			(_blocksX, _blocksY, _isBlockActive, newView, minY,
			collisionX, collisionY, hasCollide, _reset);

ViewManager #(.SCREEN_WIDTH(SCR_W),
	.SCREEN_HEIGHT(SCR_H),
	.BLOCK_WIDTH(BLK_W),
	.BLOCK_HEIGHT(BLK_H)) _viewMan
			(_minYCrossed, _newView, _minY, doodleY, _reset);

CollisionDetector #(.SCREEN_WIDTH(SCR_W),
	.SCREEN_HEIGHT(SCR_H),
	.BLOCK_WIDTH(BLK_W),
	.BLOCK_HEIGHT(BLK_H)) _collisionDetector
			(_collisionX, _collisionY, _hasCollide, doodleX, doodleY,
			blocksX, blocksY, isBlockActive);

genvar px, py;
generate
	for (px = 0; px < SCR_W; px = px +1)
	begin
		for (py = 0; py < SCR_H; py = py +1)
		begin
			RenderBox #(.SCREEN_WIDTH(SCR_W),
				.SCREEN_HEIGHT(SCR_H),
				.BLOCK_WIDTH(BLK_W),
				.BLOCK_HEIGHT(BLK_H),
				.X(px),
				.Y(py)) _renderBox 
						(_screen[(px * SCR_H)+py], doodleX, doodleY, blocksX, blocksY,
						minY, isBlockActive, reset);
		end
	end
endgenerate

// connect wires and registers
always @(_screen, left, right, reset, clk,
	_doodleX, _doodleY, _blocksX, _blocksY,
	_newView, _minY, _collisionX, _collisionY)
begin
	screen = _screen;

	_left = left;
	_right = right;
	_reset = reset;
	_clk = clk;

	doodleX = _doodleX;
	doodleY = _doodleY;

	blocksX = _blocksX;
	blocksY = _blocksY;
	isBlockActive = _isBlockActive;

	minY = _minY;
	newView = _newView;

	collisionX = _collisionX;
	collisionY = _collisionY;
	hasCollide = _hasCollide;
end
endmodule
